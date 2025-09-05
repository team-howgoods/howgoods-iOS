//
//  AuthFactory.swift
//  howgoods
//
//  Created by 양원식 on 9/5/25.
//

import Foundation

/// 로그인/인증 관련 객체 생성을 담당하는 팩토리
enum AuthFactory {
    
    // MARK: - Repository
    static func makeAuthRepository() -> AuthRepositoryProtocol {
        let networkService = AuthNetworkService()
        
        let apple = AppleAuthService(authNetworkService: networkService)
        let naver = NaverAuthService(authNetworkService: networkService)
        let kakao = KakaoAuthService(authNetworkService: networkService)
        
        return AuthRepository(
            appleAuthService: apple,
            naverAuthService: naver,
            kakaoAuthService: kakao,
            authNetworkService: networkService
        )
    }
    
    // MARK: - UseCase
    static func makeLoginUseCase() -> LoginUseCaseProtocol {
        LoginUseCase(authRepository: makeAuthRepository())
    }
    
    
    // MARK: - ViewModel
    static func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(loginUseCase: makeLoginUseCase())
    }
    
    // MARK: - ViewController
    static func makeLoginViewController() -> LoginViewController {
        LoginViewController(viewModel: makeLoginViewModel())
    }
}
