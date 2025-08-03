//
//  LoginWithAppleUseCase.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import RxSwift

protocol LoginUseCaseProtocol {
    func execute(type: LoginType) -> Observable<Result<String, Error>>
}
