//
//  AppleAuthService.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import AuthenticationServices
import RxSwift

final class AppleAuthService: NSObject {
    private let authorizationSubject = PublishSubject<Result<String, Error>>()

    func authorizeWithApple() -> Observable<Result<String, Error>> {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()

        return authorizationSubject.asObservable()
    }
}

extension AppleAuthService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let codeData = credential.authorizationCode,
              let code = String(data: codeData, encoding: .utf8) else {
            authorizationSubject.onNext(.failure(NSError(domain: "AppleAuth", code: -1)))
            return
        }
        authorizationSubject.onNext(.success(code))
        authorizationSubject.onCompleted()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authorizationSubject.onNext(.failure(error))
        authorizationSubject.onCompleted()
    }
}

extension AppleAuthService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}
