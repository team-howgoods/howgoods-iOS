//
//  LoginViewModel.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import RxSwift
import RxCocoa
import Foundation

// MARK: - Input / Output Protocol

protocol LoginViewModelInput {
    var appleLoginTapped: PublishRelay<Void> { get }
    var naverLoginTapped: PublishRelay<Void> { get }
    var kakaoLoginTapped: PublishRelay<Void> { get }
}

protocol LoginViewModelOutput {
    var loginResult: Driver<Result<String, Error>> { get }
}

// MARK: - ViewModel

final class LoginViewModel: LoginViewModelInput, LoginViewModelOutput {

    // MARK: - Input
    let appleLoginTapped = PublishRelay<Void>()
    let naverLoginTapped = PublishRelay<Void>()
    let kakaoLoginTapped = PublishRelay<Void>()

    // MARK: - Output
    let loginResult: Driver<Result<String, Error>>

    // MARK: - Dependencies
    private let loginUseCase: LoginUseCase
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase

        let result = PublishRelay<Result<String, Error>>()

        appleLoginTapped
            .map { LoginType.apple }
            .flatMapLatest { loginUseCase.execute(type: $0) }
            .bind(to: result)
            .disposed(by: disposeBag)
        
        naverLoginTapped
            .map { LoginType.naver }
            .flatMapLatest { loginUseCase.execute(type: $0) }
            .bind(to: result)
            .disposed(by: disposeBag)
        
        kakaoLoginTapped
            .map { LoginType.kakao }
            .flatMapLatest { loginUseCase.execute(type: $0) }
            .bind(to: result)
            .disposed(by: disposeBag)

        self.loginResult = result
            .asDriver(onErrorJustReturn: .failure(NSError(domain: "", code: -1)))
    }
}
