//
//  LoginWithAppleUseCase.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import RxSwift
import Foundation

/// 로그인 유형에 따라 인증 요청 → 서버 전송 → access token 수신까지의 흐름을 처리하는 유즈케이스입니다.
///
/// 각 소셜 로그인에 대해 인증 과정을 수행하고, 얻은 인증 코드를 서버에 전송하여 access token을 획득합니다.
/// 내부적으로 AuthRepository를 소셜별로 주입받아 실행합니다.
final class LoginUseCase: LoginUseCaseProtocol {

    // MARK: - Dependencies

    private let appleAuthRepository: AuthRepository
    private let naverAuthRepository: AuthRepository
    private let kakaoAuthRepository: AuthRepository

    /// 소셜별 인증 리포지토리를 주입받아 초기화합니다.
    init(
        appleAuthRepository: AuthRepository,
        naverAuthRepository: AuthRepository,
        kakaoAuthRepository: AuthRepository
    ) {
        self.appleAuthRepository = appleAuthRepository
        self.naverAuthRepository = naverAuthRepository
        self.kakaoAuthRepository = kakaoAuthRepository
    }

    // MARK: - Execute

    /// 지정된 로그인 타입에 따라 인증을 실행하고 access token을 반환합니다.
    ///
    /// - Parameter type: 로그인 방식 (Apple / Naver / Kakao)
    /// - Returns: 로그인 성공 시 access token, 실패 시 Error를 포함한 Result Observable
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
        }
    }
}
