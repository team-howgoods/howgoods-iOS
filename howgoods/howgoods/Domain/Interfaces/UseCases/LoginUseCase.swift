//
//  LoginWithAppleUseCase.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import RxSwift
import Foundation

final class LoginUseCase: LoginUseCaseProtocol {

    private let appleAuthRepository: AuthRepository
    // TODO: private let naverAuthRepository: AuthRepository
    // TODO: private let kakaoAuthRepository: AuthRepository

    init(
        appleAuthRepository: AuthRepository
        // TODO: naverAuthRepository: AuthRepository
    ) {
        self.appleAuthRepository = appleAuthRepository
    }

    func execute(type: LoginType) -> Observable<Result<String, Error>> {
        switch type {
        case .apple:
            return appleAuthRepository.loginWithApple()
                .flatMap { result -> Observable<Result<String, Error>> in
                    switch result {
                    case .success(let code):
                        return self.appleAuthRepository.sendCodeToServer(code: code)
                    case .failure(let error):
                        return .just(.failure(error))
                    }
                }

        // TODO: case .naver:
        //   return naverAuthRepository.loginWithNaver()...

        default:
            return .just(.failure(NSError(domain: "Unsupported LoginType", code: -999)))
        }
    }
}

