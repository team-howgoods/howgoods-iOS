//
//  ViewController.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import UIKit
import AuthenticationServices
import RxSwift
import RxCocoa

/// 로그인 화면을 담당하는 ViewController입니다.
///
/// 소셜 로그인 버튼(Apple, Naver, Kakao)을 통해 사용자의 로그인 요청을 처리하고,
/// ViewModel을 통해 인증 흐름을 수행한 후, 결과를 출력합니다.
final class LoginViewController: UIViewController {
    
    // MARK: - Properties

    /// ViewModel로부터 전달받은 로그인 결과를 구독하고 처리
    private let viewModel: LoginViewModel
    
    /// 로그인 화면의 UI 컴포넌트를 담고 있는 커스텀 뷰
    private let loginView = LoginView()
    
    /// Rx 구독 해제를 위한 DisposeBag
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer

    /// ViewModel 주입을 통한 초기화
    /// - Parameter viewModel: MVVM 구조의 LoginViewModel 인스턴스
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message: "Storyboard is not supported")
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle

    override func loadView() {
        self.view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - UI Methods

private extension LoginViewController {
    
    /// 전체 UI 초기 설정 메서드
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
        setActions()
        setBinding()
    }

    /// 뷰 계층 구성
    func setHierarchy() {
        // TODO: loginView 내부에서 이미 구성된 버튼 계층 사용
    }

    /// 스타일 설정
    func setStyles() {
        // TODO: 배경색, 폰트 등 지정 가능
    }

    /// 오토레이아웃 제약 설정
    func setConstraints() {
        // TODO: SnapKit 등으로 구성 가능
    }

    /// 버튼 액션 등 기본 이벤트 설정
    func setActions() {
        // TODO: 비 Rx 액션 연결 시 사용
    }

    /// Rx 바인딩 설정
    func setBinding() {
        
        // Apple 로그인 버튼 탭 → ViewModel Input
        loginView.getAppleLoginButton.rx.controlEvent(.touchUpInside)
            .bind(to: viewModel.appleLoginTapped)
            .disposed(by: disposeBag)

        // Naver 로그인 버튼 탭
        loginView.getNaverLoginButton.rx.tap
            .bind(to: viewModel.naverLoginTapped)
            .disposed(by: disposeBag)

        // Kakao 로그인 버튼 탭
        loginView.getKakaoLoginButton.rx.tap
            .bind(to: viewModel.kakaoLoginTapped)
            .disposed(by: disposeBag)

        // ViewModel Output: 로그인 결과 수신
        viewModel.loginResult
            .drive(onNext: { result in
                switch result {
                case .success(let token):
                    print("로그인 성공: \(token)")
                    // TODO: 화면 전환 또는 토큰 저장 등 후속 처리
                case .failure(let error):
                    print("로그인 실패: \(error.localizedDescription)")
                    // TODO: 사용자 알림 처리 (Alert 등)
                }
            })
            .disposed(by: disposeBag)
    }
}


