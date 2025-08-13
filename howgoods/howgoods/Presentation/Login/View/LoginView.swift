//
//  LoginView.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import UIKit
import AuthenticationServices

/// 로그인 화면의 UI 컴포넌트를 구성하는 커스텀 뷰
///
/// - 역할:
///   - Apple, Naver, Kakao 로그인 버튼을 계층적으로 배치
///   - `SnapKit`과 `Then`을 사용해 선언적이고 간결하게 UI 작성
final class LoginView: UIView {
    
    // MARK: - UI Components
    
    /// Apple 로그인 버튼
    /// - `ASAuthorizationAppleIDButton`은 시스템에서 제공하는 공식 Apple 로그인 버튼 스타일을 지원
    private let appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    /// Naver 로그인 버튼
    /// - 버튼 이미지 리소스: "NaverLoginButton_G"
    private let naverLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "NaverLoginButton_G"), for: .normal)
        return button
    }()
    
    /// Kakao 로그인 버튼
    /// - 버튼 이미지 리소스: "KakaoLoginButton"
    private let kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "KakaoLoginButton"), for: .normal)
        return button
    }()

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
    /// - 호출 시 `configure()` 메서드로 UI 초기화 진행
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    /// Storyboard 사용 불가 처리
    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
}

// MARK: - UI Configuration

private extension LoginView {
    
    /// 전체 UI 구성 흐름 제어
    /// - 뷰 계층 설정 → 스타일 지정 → 오토레이아웃 제약 설정
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
    }

    /// 뷰 계층 구성
    /// - 각 로그인 버튼을 뷰에 추가
    func setHierarchy() {
        addSubviews(
            appleLoginButton,
            naverLoginButton,
            kakaoLoginButton
        )
    }

    /// 기본 스타일 설정
    /// - 배경색: 흰색
    func setStyles() {
        backgroundColor = .white
    }

    /// 오토레이아웃 제약 설정
    /// - 버튼 크기, 위치, 간격 지정
    func setConstraints() {
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        naverLoginButton.translatesAutoresizingMaskIntoConstraints = false
        kakaoLoginButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // appleLoginButton
            appleLoginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 50),
            appleLoginButton.widthAnchor.constraint(equalToConstant: 280),
            
            // naverLoginButton
            naverLoginButton.topAnchor.constraint(equalTo: appleLoginButton.bottomAnchor, constant: 16),
            naverLoginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            naverLoginButton.heightAnchor.constraint(equalToConstant: 50),
            naverLoginButton.widthAnchor.constraint(equalToConstant: 280),
            
            // kakaoLoginButton
            kakaoLoginButton.topAnchor.constraint(equalTo: naverLoginButton.bottomAnchor, constant: 16),
            kakaoLoginButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            kakaoLoginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            kakaoLoginButton.heightAnchor.constraint(equalToConstant: 50),
            kakaoLoginButton.widthAnchor.constraint(equalToConstant: 280)
        ])

    }
}
