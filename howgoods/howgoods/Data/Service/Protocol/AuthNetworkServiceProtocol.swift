//
//  AppleAuthServiceProtocol.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import Combine

/// 인증 관련 네트워크 요청을 담당하는 서비스 계층 프로토콜
///
/// - 역할:
///   - Apple, Naver, Kakao 로그인 과정에서 발급받은 인증 코드를 서버에 전달
///   - 서버로부터 최종 인증 토큰(`AuthToken`)을 수신
///   - 모든 메서드는 네트워크 요청 결과를 `Combine` 퍼블리셔 형태로 반환
protocol AuthNetworkServiceProtocol {
    
    /// Apple 로그인 코드 서버 전송
    ///
    /// - Parameter code: Apple 로그인 후 발급받은 인증 코드
    /// - Returns:
    ///   - `AnyPublisher<Result<AuthToken, NetworkError>, Never>`:
    ///     - `.success(AuthToken)`: 인증 성공 시 발급된 토큰
    ///     - `.failure(NetworkError)`: 인증 실패 사유
    func loginWithApple(code: String) -> AnyPublisher<Result<AuthToken, NetworkError>, Never>
    
    /// Naver 로그인 코드 서버 전송
    ///
    /// - Parameter code: Naver 로그인 후 발급받은 인증 코드
    /// - Returns:
    ///   - 동일한 반환 구조
    func loginWithNaver(code: String) -> AnyPublisher<Result<AuthToken, NetworkError>, Never>
    
    /// Kakao 로그인 코드 서버 전송
    ///
    /// - Parameter code: Kakao 로그인 후 발급받은 인증 코드
    /// - Returns:
    ///   - 동일한 반환 구조
    func loginWithKakao(code: String) -> AnyPublisher<Result<AuthToken, NetworkError>, Never>
}
