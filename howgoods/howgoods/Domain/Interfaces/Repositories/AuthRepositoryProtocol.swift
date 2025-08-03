//
//  AuthRepositoryProtocol.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import RxSwift

protocol AuthRepositoryProtocol {
    func loginWithApple() -> Observable<Result<String, Error>>
    func loginWithNaver() -> Observable<Result<String, Error>>
    func sendCodeToServer(code: String) -> Observable<Result<String, Error>>
}
