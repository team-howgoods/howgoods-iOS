//
//  AuthRepositoryProtocol.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import RxSwift

/// 소셜 로그인 흐름을 추상화한 리포지토리 프로토콜입니다.
///
/// Apple, Naver, Kakao 로그인을 수행하고, 획득한 인증 코드를 서버에 전달하여
/// access token을 수신하는 과정을 정의합니다.
///
/// 이 프로토콜은 ViewModel/UseCase에서 소셜 로그인 방식에 구애받지 않고 공통 로직을 처리할 수 있도록 돕습니다.
protocol AuthRepositoryProtocol {

    /// Apple 로그인 인증을 요청합니다.
    ///
    /// - Returns: 인증 성공 시 authorization code, 실패 시 error 를 포함한 `Result`
    func loginWithApple() -> Observable<Result<String, Error>>

    /// Naver 로그인 인증을 요청합니다.
    func loginWithNaver() -> Observable<Result<String, Error>>

    /// Kakao 로그인 인증을 요청합니다.
    func loginWithKakao() -> Observable<Result<String, Error>>

    /// 소셜 로그인 인증 코드(code)를 서버에 전송하여 access token을 요청합니다.
    ///
    /// - Parameter code: 각 소셜 로그인에서 획득한 인증 코드
    /// - Returns: 서버에서 받은 access token 또는 error
    func sendCodeToServer(code: String) -> Observable<Result<String, Error>>
}
