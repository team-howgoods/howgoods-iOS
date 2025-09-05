//
//  ViewController.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import UIKit
import Combine
import AuthenticationServices

/// 로그인 화면을 담당하는 ViewController
///
/// - 역할:
///   - Apple, Naver, Kakao 로그인 버튼 클릭 이벤트를 ViewModel에 전달
///   - ViewModel의 로그인 처리 결과를 구독하여 UI에 반영
final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    /// MVVM 구조에서 View와 Model을 연결하는 ViewModel
    /// - 사용자의 버튼 입력을 전달하고 결과를 수신
    private let viewModel: LoginViewModel
    
    /// 로그인 화면의 UI 요소를 포함하는 커스텀 뷰
    /// - 버튼, 로고, 설명 라벨 등
    private let loginView = LoginView()
    
    /// Combine의 구독을 관리하는 Set
    /// - 메모리 누수를 방지하고, ViewController 해제 시 구독 해제
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    /// 의존성 주입을 통한 초기화
    /// - Parameter viewModel: `LoginViewModel` 인스턴스
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Storyboard 초기화 방지
    @available(*, unavailable, message: "Storyboard is not supported")
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    /// ViewController의 root view를 `loginView`로 설정
    override func loadView() {
        self.view = loginView
    }
    
    /// 화면 로드 완료 시 UI와 바인딩 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    /// Coordinator에서 구독할 수 있는 콜백
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((Error) -> Void)?
}

// MARK: - UI Methods

private extension LoginViewController {
    
    /// 전체 UI 및 이벤트 바인딩 초기 설정
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
        setActions()
        setBinding()
    }
    
    /// 뷰 계층 구성
    /// - 현재 `loginView` 내부에서 버튼과 UI 요소가 이미 구성되어 있음
    func setHierarchy() {
        // TODO: loginView 내부 요소 추가 시 확장 가능
    }
    
    /// 스타일 설정 (배경색, 폰트 등)
    func setStyles() {
        // TODO: 화면 전체 스타일 지정
    }
    
    /// 오토레이아웃 제약 설정
    func setConstraints() {
        // TODO: SnapKit 등으로 레이아웃 구성
    }
    
    /// 버튼 액션 설정 (비 Combine 방식)
    func setActions() {
        // TODO: 필요 시 target-action 방식 이벤트 연결
    }
    
    /// Combine 기반 이벤트 바인딩
    func setBinding() {
        // Apple 로그인 버튼 탭 이벤트 → ViewModel Input 전달
        loginView.getAppleLoginButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.appleLoginTapped.send(())
            }
            .store(in: &cancellables)
        
        // Naver 로그인 버튼 탭 이벤트
        loginView.getNaverLoginButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.naverLoginTapped.send(())
            }
            .store(in: &cancellables)
        
        // Kakao 로그인 버튼 탭 이벤트
        loginView.getKakaoLoginButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.kakaoLoginTapped.send(())
            }
            .store(in: &cancellables)
        
        // ViewModel Output 구독 → 로그인 결과 처리
        viewModel.loginResult
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success(let token):
                    print("로그인 성공: \(token.accessToken)")
                    TokenStorage.save(token: token, loginType: .kakao)
                    self.onLoginSuccess?()
                    // TODO: 성공 후 화면 전환 또는 토큰 저장 로직 추가
                case .failure(let error):
                    self.onLoginFailure?(error)
                    // TODO: 실패 시 Alert 표시
                }
            }
            .store(in: &cancellables)
        
    }
}
