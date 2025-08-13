//
//  NaverAuthService.swift
//  howgoods
//
//  Created by 양원식 on 8/4/25.
//

import Combine
import NidThirdPartyLogin

/// 네이버 로그인 기능을 담당하는 서비스
///
/// - 역할:
///   - `NidThirdPartyLogin` 라이브러리를 이용하여 네이버 OAuth 인증 처리
///   - 네이버에서 발급받은 액세스 토큰을 서버로 전달해 최종 인증 토큰을 수신
///   - 결과를 `Combine` 퍼블리셔 형태로 반환
final class NaverAuthService {
    
    // MARK: - Dependencies
    
    /// 네이버 OAuth 인증 객체
    private let oauth = NidOAuth.shared
    
    /// 서버와 통신하여 인증 토큰을 교환하는 네트워크 서비스
    private let authNetworkService: AuthNetworkService
    
    /// Combine 구독 해제를 관리하는 Set
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer
    
    /// 네이버 인증 서비스 초기화
    /// - Parameter authNetworkService: 서버와 통신하는 네트워크 서비스
    init(authNetworkService: AuthNetworkService) {
        self.authNetworkService = authNetworkService
        // 앱 설치 시 앱 우선, 미설치 시 인앱 브라우저로 로그인 시도
        oauth.setLoginBehavior(.appPreferredWithInAppBrowserFallback)
    }

    // MARK: - Public Methods
    
    /// 네이버 로그인 진행
    ///
    /// - 동작 흐름:
    ///   1. 기존 액세스 토큰이 존재하면 로그아웃 처리
    ///   2. `NidOAuth`를 통해 네이버 로그인 요청
    ///   3. 로그인 성공 시, 네이버 액세스 토큰을 서버에 전달하여 최종 인증 토큰 발급
    ///   4. 성공 시 `.success(String)` 반환, 실패 시 `.failure(Error)` 반환
    ///
    /// - Returns:
    ///   - `AnyPublisher<Result<String, Error>, Never>`:
    ///     - `.success(String)`: 서버 인증 성공 시 발급받은 최종 액세스 토큰
    ///     - `.failure(Error)`: 인증 실패 시 에러 정보
    func authorizeWithNaver() -> AnyPublisher<Result<String, Error>, Never> {
        Future { [weak self] promise in
            guard let self = self else { return }

            // 기존 로그인 세션이 있다면 로그아웃
            if self.oauth.accessToken != nil {
                self.oauth.logout()
            }

            // 네이버 로그인 요청
            self.oauth.requestLogin { result in
                switch result {
                case .success(let loginResult):
                    let token = loginResult.accessToken.tokenString
                    
                    // 네이버에서 받은 토큰을 서버로 전달하여 최종 인증 토큰 발급
                    self.authNetworkService.loginWithNaver(code: token)
                        .map { result in
                            switch result {
                            case .success(let authToken):
                                return .success(authToken.accessToken)
                            case .failure(let err):
                                return .failure(err)
                            }
                        }
                        .sink(receiveValue: { promise(.success($0)) })
                        .store(in: &self.cancellables)

                case .failure(let error):
                    // 로그인 실패 시 에러 전달
                    promise(.success(.failure(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
