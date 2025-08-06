//
//  AuthRepository.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//
import RxSwift

final class AuthRepository: AuthRepositoryProtocol {

    private let appleAuthService: AppleAuthService
    private let naverAuthService: NaverAuthService
    private let kakaoAuthService: KakaoAuthService
    private let authNetworkService: AuthNetworkService

    init(
        appleAuthService: AppleAuthService,
        naverAuthService: NaverAuthService,
        kakaoAuthService: KakaoAuthService,
        authNetworkService: AuthNetworkService
    ) {
        self.appleAuthService = appleAuthService
        self.naverAuthService = naverAuthService
        self.kakaoAuthService = kakaoAuthService
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
                    return .success(tokenEntity.accessToken)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func loginWithNaver() -> Observable<Result<String, Error>> {
        return naverAuthService.authorizeWithNaver()
    }
    
    func sendNaverCodeToServer(code: String) -> Observable<Result<String, Error>> {
        return authNetworkService.loginWithNaver(code: code)
            .map { result in
                switch result {
                case .success(let tokenEntity):
                    return .success(tokenEntity.accessToken)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func loginWithKakao() -> Observable<Result<String, Error>> {
        return kakaoAuthService.authorizeWithKakao()
    }
    
    func sendKakaoCodeToServer(code: String) -> Observable<Result<String, Error>> {
        return authNetworkService.loginWithKakao(code: code)
            .map { result in
                switch result {
                case .success(let tokenEntity):
                    return .success(tokenEntity.accessToken)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}

