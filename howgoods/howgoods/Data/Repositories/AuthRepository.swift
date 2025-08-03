//
//  AuthRepository.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//
import RxSwift

final class AuthRepository: AuthRepositoryProtocol {

    private let appleAuthService: AppleAuthService
    private let authNetworkService: AuthNetworkService

    init(
        appleAuthService: AppleAuthService,
        authNetworkService: AuthNetworkService
    ) {
        self.appleAuthService = appleAuthService
        self.authNetworkService = authNetworkService
    }

    func loginWithApple() -> Observable<Result<String, Error>> {
        return appleAuthService.authorizeWithApple()
    }

    func sendCodeToServer(code: String) -> Observable<Result<String, Error>> {
        return authNetworkService.loginWithApple(code: code)
            .map { result in
                switch result {
                case .success(let tokenEntity):
                    return .success(tokenEntity.token)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}

