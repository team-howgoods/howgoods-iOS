//
//  AppleAuthServiceProtocol.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import RxSwift

/// 인증 관련 네트워크 요청을 담당하는 서비스 계층
protocol AuthNetworkServiceProtocol {
    func loginWithApple(code: String) -> Observable<Result<AuthToken, Error>>
    func loginWithNaver(code: String) -> Observable<Result<AuthToken, Error>>
    func loginWithKakao(code: String) -> Observable<Result<AuthToken, Error>>
}
