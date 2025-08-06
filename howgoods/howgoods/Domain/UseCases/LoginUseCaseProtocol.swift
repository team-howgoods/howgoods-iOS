//
//  LoginWithAppleUseCase.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import RxSwift

/// 소셜 로그인 인증을 수행하는 유즈케이스 인터페이스입니다.
///
/// `LoginType`에 따라 해당 로그인 흐름을 실행하고, 서버로 인증 코드를 전송하여 access token을 획득합니다.
/// 결과는 `Observable<Result<String, Error>>` 형태로 반환되어 ViewModel에서 반응형 처리에 용이합니다.
protocol LoginUseCaseProtocol {

    /// 로그인 타입에 따른 인증 실행 메서드
    ///
    /// - Parameter type: 로그인 방식 (Apple, Naver, Kakao 등)
    /// - Returns: 인증 성공 시 access token, 실패 시 Error 를 포함한 Rx Observable
    func execute(type: LoginType) -> Observable<Result<String, Error>>
}
