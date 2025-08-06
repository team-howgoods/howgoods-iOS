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
    private let naverAuthRepository: AuthRepository
    private let kakaoAuthRepository: AuthRepository

    init(
        appleAuthRepository: AuthRepository,
        naverAuthRepository: AuthRepository,
        kakaoAuthRepository: AuthRepository
    ) {
        self.appleAuthRepository = appleAuthRepository
        self.naverAuthRepository = naverAuthRepository
        self.kakaoAuthRepository = kakaoAuthRepository
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
            
        case .naver:
            return naverAuthRepository.loginWithNaver()
                .flatMap { result -> Observable<Result<String, Error>> in
                    switch result {
                    case .success(let accessToken):
                        return self.naverAuthRepository.sendNaverCodeToServer(code: accessToken)
                    case .failure(let error):
                        return .just(.failure(error))
                    }
                }

        case .kakao:
            return kakaoAuthRepository.loginWithKakao()
                .flatMap { result -> Observable<Result<String, Error>> in
                    switch result {
                    case .success(let accessToken):
                        return self.kakaoAuthRepository.sendKakaoCodeToServer(code: accessToken)
                    case .failure(let error):
                        return .just(.failure(error))
                    }
                }

        default:
            return .just(.failure(NSError(domain: "Unsupported LoginType", code: -999)))
        }
    }
}

