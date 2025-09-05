//
//  LoginWithAppleUseCase.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import Combine

/// 로그인 유스케이스의 공통 인터페이스
///
/// - 역할:
///   - 로그인 타입(Apple, Naver, Kakao)에 따라 로그인 로직을 실행
///   - 실행 결과를 `Combine` 퍼블리셔 형태로 반환
protocol LoginUseCaseProtocol {
    
    /// 로그인 실행
    ///
    /// - Parameter type: 실행할 로그인 타입 (`LoginType`)
    /// - Returns:
    ///   - `AnyPublisher<Result<String, Error>, Never>`
    ///     - `.success(String)`: 로그인 성공 시 토큰 반환
    ///     - `.failure(Error)`: 로그인 실패 시 에러 반환
    func execute(type: LoginType) -> AnyPublisher<Result<AuthToken, Error>, Never>
}
