//
//  LoginView.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import UIKit
import SnapKit
import Then
import AuthenticationServices

final class LoginView: UIView {
    // MARK: - Properties
    
    // MARK: - UI Components
    private let appleLoginButton = ASAuthorizationAppleIDButton().then {
        $0.cornerRadius = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let naverLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "NaverLoginButton_G"), for: .normal)
    }
    
    // MARK: - Getter
    var getAppleLoginButton: ASAuthorizationAppleIDButton {
        return appleLoginButton
    }
    var getNaverLoginButton: UIButton { naverLoginButton }

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: - Public Methods
}

private extension LoginView {
    // MARK: - configure
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
    }
    
    // MARK: - setHierarchy
    func setHierarchy() {
        addSubviews(
            appleLoginButton,
            naverLoginButton
        )
    }
    
    // MARK: - setStyles
    func setStyles() {
        backgroundColor = .white
    }
    
    // MARK: - setConstraints
    func setConstraints() {
        appleLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(280)
        }
        
        naverLoginButton.snp.makeConstraints {
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(280)
        }
    }
}
