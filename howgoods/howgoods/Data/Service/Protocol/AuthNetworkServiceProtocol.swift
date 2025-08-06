//
//  AppleAuthServiceProtocol.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import RxSwift

/// 인증 관련 네트워크 요청을 담당하는 서비스 계층 프로토콜입니다.
///
/// Apple, Naver, Kakao 소셜 로그인에서 발급받은 인증 코드를 서버에 전달하고,
/// 서버로부터 인증 토큰(`AuthToken`)을 수신하는 역할을 합니다.
///
/// 이 프로토콜은 실제 구현체(`AuthNetworkService` 등)와 분리되어 테스트 가능성과 확장성을 높입니다.
protocol AuthNetworkServiceProtocol {

    /// Apple 로그인 인증 코드를 서버에 전송하고 토큰을 반환합니다.
    ///
    /// - Parameter code: Apple 로그인 후 획득한 authorization code
    /// - Returns: 서버로부터 수신한 `AuthToken` 또는 `Error`
    func loginWithApple(code: String) -> Observable<Result<AuthToken, Error>>

    /// Naver 로그인 인증 코드를 서버에 전송하고 토큰을 반환합니다.
    ///
    /// - Parameter code: Naver 로그인 후 획득한 token
    func loginWithNaver(code: String) -> Observable<Result<AuthToken, Error>>

    /// Kakao 로그인 인증 코드를 서버에 전송하고 토큰을 반환합니다.
    ///
    /// - Parameter code: Kakao 로그인 후 획득한 token
    func loginWithKakao(code: String) -> Observable<Result<AuthToken, Error>>
}
