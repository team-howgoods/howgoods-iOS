//
//  AuthRepositoryProtocol.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//
import Combine

/// 인증 관련 데이터 처리를 담당하는 저장소 프로토콜
///
/// - 역할:
///   - Apple, Naver, Kakao 각 소셜 로그인 요청 수행
///   - 로그인 후 발급받은 인증 코드를 서버로 전달
///   - 모든 메서드는 비동기 작업 결과를 `Combine` 퍼블리셔 형태로 반환
protocol AuthRepositoryProtocol {
    
    /// Apple 로그인 실행
    ///
    /// - Returns:
    ///   - `AnyPublisher<Result<String, Error>, Never>`:
    ///     - `.success(String)`: 로그인 성공 시 토큰 반환
    ///     - `.failure(Error)`: 로그인 실패 시 에러 반환
    func loginWithApple() -> AnyPublisher<Result<String, Error>, Never>
    
    /// Naver 로그인 실행
    ///
    /// - Returns:
    ///   - `AnyPublisher<Result<String, Error>, Never>`:
    ///     - `.success(String)`: 로그인 성공 시 토큰 반환
    ///     - `.failure(Error)`: 로그인 실패 시 에러 반환
    func loginWithNaver() -> AnyPublisher<Result<String, Error>, Never>
    
    /// Kakao 로그인 실행
    ///
    /// - Returns:
    ///   - `AnyPublisher<Result<String, Error>, Never>`:
    ///     - `.success(String)`: 로그인 성공 시 토큰 반환
    ///     - `.failure(Error)`: 로그인 실패 시 에러 반환
    func loginWithKakao() -> AnyPublisher<Result<String, Error>, Never>
    
    /// 인증 코드 서버 전송
    ///
    /// - Parameter code: 소셜 로그인 후 발급받은 인증 코드
    /// - Returns:
    ///   - `AnyPublisher<Result<String, Error>, Never>`:
    ///     - `.success(String)`: 서버에서 처리 성공 시 응답 데이터 반환
    ///     - `.failure(Error)`: 처리 실패 시 에러 반환
    func sendCodeToServer(code: String) -> AnyPublisher<Result<String, Error>, Never>
}
