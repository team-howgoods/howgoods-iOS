//
//  AppleAuthService.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import Combine
import AuthenticationServices

/// Apple 로그인 기능을 담당하는 서비스
///
/// - 역할:
///   - `ASAuthorizationController`를 사용해 Apple ID 로그인 플로우 실행
///   - 인증 후 발급받은 `authorizationCode`를 서버에 전달하여 최종 인증 토큰 발급
///   - Combine 퍼블리셔로 로그인 성공/실패 결과 반환
final class AppleAuthService: NSObject {
    
    // MARK: - Properties
    
    /// Apple 로그인 완료 후 결과를 전달하는 클로저
    private var promise: ((Result<String, Error>) -> Void)?
    
    /// 서버와 통신하여 Apple 인증 토큰을 교환하는 네트워크 서비스
    private let authNetworkService: AuthNetworkService
    
    /// Combine 구독 관리용 Set
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer
    
    /// Apple 인증 서비스 초기화
    /// - Parameter authNetworkService: 서버 통신을 담당하는 네트워크 서비스
    init(authNetworkService: AuthNetworkService) {
        self.authNetworkService = authNetworkService
    }

    // MARK: - Public Methods
    
    /// Apple 로그인 실행
    ///
    /// - 동작 흐름:
    ///   1. Apple 로그인 요청(`ASAuthorizationController`) 실행
    ///   2. 인증 성공 시 `authorizationCode` 획득
    ///   3. 해당 코드를 서버에 전달하여 최종 액세스 토큰 발급
    ///   4. 성공 시 `.success(String)`, 실패 시 `.failure(Error)` 반환
    ///
    /// - Returns:
    ///   - `AnyPublisher<Result<String, Error>, Never>`:
    ///     - `.success(String)`: 최종 액세스 토큰
    ///     - `.failure(Error)`: 인증 실패 에러
    func authorizeWithApple() -> AnyPublisher<Result<AuthToken, Error>, Never> {
        Future { [weak self] promise in
            // Apple 인증 결과를 처리할 콜백 저장
            self?.promise = { result in
                switch result {
                case .success(let code):
                    // 서버에 코드 전달 → 최종 토큰 발급
                    self?.authNetworkService.loginWithApple(code: code)
                        .map { result in
                            switch result {
                            case .success(let authToken):
                                return .success(authToken)
                            case .failure(let err):
                                return .failure(err)
                            }
                        }
                        .sink(receiveValue: { promise(.success($0)) })
                        .store(in: &self!.cancellables)

                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }

            // Apple 로그인 요청 생성
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.email] // 이메일 권한 요청

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AppleAuthService: ASAuthorizationControllerDelegate {
    
    /// Apple 로그인 성공 시 호출
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let codeData = credential.authorizationCode,
              let code = String(data: codeData, encoding: .utf8) else {
            promise?(.failure(NSError(domain: "AppleAuth", code: -1)))
            return
        }
        promise?(.success(code))
    }

    /// Apple 로그인 실패 시 호출
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        promise?(.failure(error))
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AppleAuthService: ASAuthorizationControllerPresentationContextProviding {
    
    /// Apple 로그인 UI를 표시할 윈도우 지정
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}
