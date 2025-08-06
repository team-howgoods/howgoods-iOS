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

/// 로그인 뷰에서 발생하는 사용자 액션들을 정의한 입력 프로토콜입니다.
protocol LoginViewModelInput {
    
    /// Apple 로그인 버튼이 탭되었을 때 전달되는 이벤트
    var appleLoginTapped: PublishRelay<Void> { get }
    
    /// Naver 로그인 버튼이 탭되었을 때 전달되는 이벤트
    var naverLoginTapped: PublishRelay<Void> { get }
    
    /// Kakao 로그인 버튼이 탭되었을 때 전달되는 이벤트
    var kakaoLoginTapped: PublishRelay<Void> { get }
}

/// 로그인 결과(성공/실패)를 뷰에 전달하는 출력 프로토콜입니다.
protocol LoginViewModelOutput {
    
    /// 로그인 결과를 전달하는 드라이버 (accessToken or Error)
    var loginResult: Driver<Result<String, Error>> { get }
}

// MARK: - ViewModel

/// 소셜 로그인 버튼 탭 이벤트를 처리하고, 로그인 결과를 바인딩하는 ViewModel입니다.
///
/// 각 로그인 버튼의 입력 이벤트를 수신하여 `LoginUseCase`를 통해 인증 과정을 실행하고,
/// 최종 결과(accessToken 또는 error)를 `loginResult`로 전달합니다.
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

    /// ViewModel 생성자
    /// - Parameter loginUseCase: 소셜 로그인 실행을 위한 유즈케이스
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase

        let result = PublishRelay<Result<String, Error>>()

        // Apple 로그인 흐름
        appleLoginTapped
            .map { LoginType.apple }
            .flatMapLatest { loginUseCase.execute(type: $0) }
            .bind(to: result)
            .disposed(by: disposeBag)

        // Naver 로그인 흐름
        naverLoginTapped
            .map { LoginType.naver }
            .flatMapLatest { loginUseCase.execute(type: $0) }
            .bind(to: result)
            .disposed(by: disposeBag)

        // Kakao 로그인 흐름
        kakaoLoginTapped
            .map { LoginType.kakao }
            .flatMapLatest { loginUseCase.execute(type: $0) }
            .bind(to: result)
            .disposed(by: disposeBag)

        // 결과를 Output으로 노출 (에러 발생 시 기본값 반환)
        self.loginResult = result
            .asDriver(onErrorJustReturn: .failure(NSError(domain: "", code: -1)))
    }
}
