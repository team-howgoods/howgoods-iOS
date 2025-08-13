//
//  KakaoAuthService.swift
//  howgoods
//
//  Created by 양원식 on 8/4/25.
//

import Combine
import KakaoSDKAuth
import KakaoSDKUser

/// 카카오 로그인 기능을 담당하는 서비스
///
/// - 역할:
///   - `KakaoSDKUser`를 이용해 카카오톡 앱 또는 계정 로그인 처리
///   - 카카오에서 발급받은 액세스 토큰을 서버로 전달하여 최종 인증 토큰 발급
///   - 결과를 `Combine` 퍼블리셔 형태로 반환
final class KakaoAuthService {
    
    // MARK: - Dependencies
    
    /// 카카오 사용자 API 객체
    private let userApi = UserApi.shared
    
    /// 서버와 통신하여 카카오 인증 토큰을 교환하는 네트워크 서비스
    private let authNetworkService: AuthNetworkService
    
    /// Combine 구독 관리용 Set
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer
    
    /// 카카오 인증 서비스 초기화
    /// - Parameter authNetworkService: 서버 통신을 담당하는 네트워크 서비스
    init(authNetworkService: AuthNetworkService) {
        self.authNetworkService = authNetworkService
    }

    // MARK: - Public Methods
    
    /// 카카오 로그인 진행
    ///
    /// - 동작 흐름:
    ///   1. 기존 로그인 세션 로그아웃
    ///   2. 기기에 카카오톡 앱이 설치되어 있으면 앱 로그인, 아니면 계정 로그인 진행
    ///   3. 로그인 성공 시 발급받은 액세스 토큰을 서버에 전달하여 최종 인증 토큰 발급
    ///   4. 성공 시 `.success(String)` 반환, 실패 시 `.failure(Error)` 반환
    ///
    /// - Returns:
    ///   - `AnyPublisher<Result<String, Error>, Never>`:
    ///     - `.success(String)`: 서버 인증 성공 시 발급된 최종 액세스 토큰
    ///     - `.failure(Error)`: 인증 실패 시 에러 정보
    func authorizeWithKakao() -> AnyPublisher<Result<String, Error>, Never> {
        Future { [weak self] promise in
            guard let self = self else { return }

            // 기존 세션 로그아웃
            self.userApi.logout { _ in
                if UserApi.isKakaoTalkLoginAvailable() {
                    // 카카오톡 앱 로그인
                    self.userApi.loginWithKakaoTalk { oauthToken, error in
                        if let error = error {
                            promise(.success(.failure(error)))
                        } else if let token = oauthToken?.accessToken {
                            self.authNetworkService.loginWithKakao(code: token)
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
                        }
                    }
                } else {
                    // 카카오 계정 로그인
                    self.userApi.loginWithKakaoAccount { oauthToken, error in
                        if let error = error {
                            promise(.success(.failure(error)))
                        } else if let token = oauthToken?.accessToken {
                            self.authNetworkService.loginWithKakao(code: token)
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
                        }
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
