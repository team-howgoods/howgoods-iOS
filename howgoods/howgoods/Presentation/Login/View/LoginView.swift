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

/// 로그인 화면의 UI 컴포넌트를 구성하는 커스텀 뷰입니다.
///
/// Apple, Naver, Kakao 로그인 버튼을 계층적으로 배치하고,
/// `SnapKit`, `Then`을 활용해 선언적으로 UI를 구성합니다.
final class LoginView: UIView {
    
    // MARK: - UI Components

    /// Apple 로그인 버튼
    private let appleLoginButton = ASAuthorizationAppleIDButton().then {
        $0.cornerRadius = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Naver 로그인 버튼 (이미지 기반)
    private let naverLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "NaverLoginButton_G"), for: .normal)
    }
    
    /// Kakao 로그인 버튼 (이미지 기반)
    private let kakaoLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "KakaoLoginButton"), for: .normal)
    }

    // MARK: - Getter

    /// 외부에서 접근 가능한 Apple 로그인 버튼
    var getAppleLoginButton: ASAuthorizationAppleIDButton {
        return appleLoginButton
    }

    /// 외부에서 접근 가능한 Naver 로그인 버튼
    var getNaverLoginButton: UIButton {
        return naverLoginButton
    }

    /// 외부에서 접근 가능한 Kakao 로그인 버튼
    var getKakaoLoginButton: UIButton {
        return kakaoLoginButton
    }

    // MARK: - Initializer

    /// 기본 생성자
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
}

private extension LoginView {
    
    /// 전체 UI 구성 순서를 제어합니다.
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
    }

    /// 뷰 계층에 UI 컴포넌트를 추가합니다.
    func setHierarchy() {
        addSubviews(
            appleLoginButton,
            naverLoginButton,
            kakaoLoginButton
        )
    }

    /// 기본 스타일을 설정합니다.
    func setStyles() {
        backgroundColor = .white
    }

    /// 오토레이아웃 제약을 설정합니다.
    func setConstraints() {
        appleLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(280)
        }

        naverLoginButton.snp.makeConstraints {
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(280)
        }

        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalTo(naverLoginButton.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(280)
        }
    }
}

