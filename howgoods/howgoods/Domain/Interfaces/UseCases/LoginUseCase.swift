//
//  LoginWithAppleUseCase.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import Combine

/// 로그인 비즈니스 로직을 담당하는 유스케이스
///
/// - 역할:
///   - 전달받은 로그인 타입(Apple, Naver, Kakao)에 따라 해당 인증 로직을 호출
///   - `AuthRepository`를 통해 실제 인증 요청을 수행
///   - 결과를 `Combine` 퍼블리셔 형태로 반환
final class LoginUseCase: LoginUseCaseProtocol {
    
    // MARK: - Dependencies
    
    /// 로그인 API 호출 및 인증 처리를 담당하는 저장소 객체
    private let authRepository: AuthRepositoryProtocol

    // MARK: - Initializer
    
    /// 의존성 주입을 통한 초기화
    /// - Parameter authRepository: 인증 로직을 수행하는 저장소 객체
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

    // MARK: - Public Methods
    
    /// 로그인 실행
    ///
    /// - Parameter type: 로그인 타입 (`LoginType`)
    /// - Returns:
    ///   - `AnyPublisher<Result<String, Error>, Never>`:
    ///     - `.success(String)`: 로그인 성공 시 토큰 반환
    ///     - `.failure(Error)`: 로그인 실패 시 에러 반환
    func execute(type: LoginType) -> AnyPublisher<Result<String, Error>, Never> {
        switch type {
        case .apple:
            return authRepository.loginWithApple()
        case .naver:
            return authRepository.loginWithNaver()
        case .kakao:
            return authRepository.loginWithKakao()
        }
    }
}
