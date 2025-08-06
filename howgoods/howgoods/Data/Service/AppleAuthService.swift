//
//  AppleAuthService.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import AuthenticationServices
import RxSwift

/// Apple 로그인 인증을 처리하는 서비스 클래스입니다.
///
/// `ASAuthorizationController`를 통해 Apple 로그인 인증을 요청하고,
/// 결과를 `Observable<Result<String, Error>>` 형태로 반환합니다.
///
/// 반환되는 `String`은 Apple에서 발급한 `authorizationCode`입니다.
final class AppleAuthService: NSObject {

    /// 인증 결과를 전달하는 Subject (성공 시 code, 실패 시 error)
    private let authorizationSubject = PublishSubject<Result<String, Error>>()

    /// Apple 로그인 인증을 시작하고 결과를 옵저버블로 반환합니다.
    ///
    /// - Returns: `Observable` 형태의 Apple 로그인 결과 (`authorizationCode` 또는 `Error`)
    func authorizeWithApple() -> Observable<Result<String, Error>> {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email] // 이메일 범위 요청 (최초 로그인 시에만 제공)

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()

        return authorizationSubject.asObservable()
    }
}

// MARK: - 인증 결과 델리게이트

extension AppleAuthService: ASAuthorizationControllerDelegate {

    /// Apple 인증 성공 시 호출됩니다.
    ///
    /// - Parameter authorization: 인증 결과 객체
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let codeData = credential.authorizationCode,
              let code = String(data: codeData, encoding: .utf8) else {
            // code 추출 실패
            authorizationSubject.onNext(.failure(NSError(domain: "AppleAuth", code: -1)))
            return
        }

        // 인증 코드 전달
        authorizationSubject.onNext(.success(code))
        authorizationSubject.onCompleted()
    }

    /// Apple 인증 실패 시 호출됩니다.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authorizationSubject.onNext(.failure(error))
        authorizationSubject.onCompleted()
    }
}

// MARK: - 인증 프레젠테이션 Anchor 제공

extension AppleAuthService: ASAuthorizationControllerPresentationContextProviding {

    /// Apple 인증 UI가 표시될 윈도우를 반환합니다.
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}
