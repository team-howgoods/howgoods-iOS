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

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private let loginView = LoginView()
    private let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
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
    
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
        setActions()
        setBinding()
    }
    
    func setHierarchy() { }
    func setStyles() { }
    func setConstraints() { }
    func setActions() { }
    func setBinding() {
        loginView.getAppleLoginButton.rx.controlEvent(.touchUpInside)
            .bind(to: viewModel.appleLoginTapped)
            .disposed(by: disposeBag)

        viewModel.loginResult
            .drive(onNext: { result in
                switch result {
                case .success(let token):
                    print("로그인 성공: \(token)")
                case .failure(let error):
                    print("로그인 실패: \(error.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)
    }
}

