//
//  LoginViewModel.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import Combine
import Foundation

// MARK: - Input / Output Protocol

/// ViewModel이 외부(View)로부터 받을 입력 이벤트 정의
protocol LoginViewModelInput {
    /// Apple 로그인 버튼 탭 이벤트
    var appleLoginTapped: PassthroughSubject<Void, Never> { get }
    /// Naver 로그인 버튼 탭 이벤트
    var naverLoginTapped: PassthroughSubject<Void, Never> { get }
    /// Kakao 로그인 버튼 탭 이벤트
    var kakaoLoginTapped: PassthroughSubject<Void, Never> { get }
}

/// ViewModel이 외부(View)로 내보낼 출력 데이터 정의
protocol LoginViewModelOutput {
    /// 로그인 요청 결과 스트림
    /// - 성공: 로그인 토큰(String)
    /// - 실패: Error
    var loginResult: AnyPublisher<Result<String, Error>, Never> { get }
}

/// 로그인 화면의 ViewModel
/// - 역할: 로그인 버튼 탭 이벤트를 받아 해당 로그인 로직을 실행하고 결과를 View에 전달
final class LoginViewModel: LoginViewModelInput, LoginViewModelOutput {

    // MARK: - Input
    /// Apple 로그인 버튼 탭 이벤트
    let appleLoginTapped = PassthroughSubject<Void, Never>()
    /// Naver 로그인 버튼 탭 이벤트
    let naverLoginTapped = PassthroughSubject<Void, Never>()
    /// Kakao 로그인 버튼 탭 이벤트
    let kakaoLoginTapped = PassthroughSubject<Void, Never>()

    // MARK: - Output
    /// 내부에서 로그인 결과를 저장하는 Subject
    private let loginResultSubject = PassthroughSubject<Result<String, Error>, Never>()
    /// 외부에서 구독 가능한 로그인 결과 스트림
    var loginResult: AnyPublisher<Result<String, Error>, Never> {
        loginResultSubject.eraseToAnyPublisher()
    }

    // MARK: - Dependencies
    /// 실제 로그인 로직을 수행하는 UseCase
    private let loginUseCase: LoginUseCaseProtocol
    /// Combine 구독 관리
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    /// ViewModel 초기화
    /// - Parameter loginUseCase: 로그인 비즈니스 로직을 수행하는 UseCase
    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase

        // Apple 로그인 버튼 탭 시 실행 로직
        appleLoginTapped
            .flatMap { loginUseCase.execute(type: .apple) } // Apple 로그인 실행
            .sink { [weak self] result in
                self?.loginResultSubject.send(result) // 결과 전달
            }
            .store(in: &cancellables)

        // Naver 로그인 버튼 탭 시 실행 로직
        naverLoginTapped
            .flatMap { loginUseCase.execute(type: .naver) } // Naver 로그인 실행
            .sink { [weak self] result in
                self?.loginResultSubject.send(result) // 결과 전달
            }
            .store(in: &cancellables)

        // Kakao 로그인 버튼 탭 시 실행 로직
        kakaoLoginTapped
            .flatMap { loginUseCase.execute(type: .kakao) } // Kakao 로그인 실행
            .sink { [weak self] result in
                self?.loginResultSubject.send(result) // 결과 전달
            }
            .store(in: &cancellables)
    }
}
