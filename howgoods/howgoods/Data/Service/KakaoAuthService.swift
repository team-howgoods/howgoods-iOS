//
//  KakaoAuthService.swift
//  howgoods
//
//  Created by 양원식 on 8/4/25.
//

import Foundation
import RxSwift
import KakaoSDKAuth
import KakaoSDKUser

/// Kakao 로그인을 처리하는 인증 서비스입니다.
///
/// 카카오톡 앱 또는 카카오 계정 웹로그인을 통해 사용자 인증을 수행하고,
/// access token을 `Observable<Result<String, Error>>` 형태로 반환합니다.
final class KakaoAuthService {
    
    /// 카카오 API 엔드포인트
    private let userApi = UserApi.shared

    /// 카카오 로그인 인증을 시작합니다.
    ///
    /// 기존 로그인 상태가 있다면 먼저 로그아웃을 시도하고,
    /// 이후 카카오톡 앱이 설치되어 있으면 앱 로그인을, 아니면 계정 로그인을 시도합니다.
    ///
    /// - Returns: 인증 성공 시 accessToken, 실패 시 Error가 포함된 Rx Observable
    func authorizeWithKakao() -> Observable<Result<String, Error>> {
        return Observable.create { observer in
            
            // 기존 로그인 상태가 있다면 로그아웃
            self.userApi.logout { logoutError in
                if let logoutError = logoutError {
                    print("카카오 로그아웃 실패: \(logoutError.localizedDescription)")
                } else {
                    print("이미 로그인되어 있어 로그아웃 후 재시도합니다.")
                }

                // 현재 토큰 상태 확인
                let currentToken = AuthApi.hasToken()
                    ? (TokenManager.manager.getToken()?.accessToken ?? "없음")
                    : "없음"
                print("로그인 시도 직전 accessToken 상태: \(currentToken)")

                // 카카오톡 앱이 설치되어 있다면 앱 로그인, 아니면 계정 로그인
                if UserApi.isKakaoTalkLoginAvailable() {
                    self.loginWithKakaoTalk(observer)
                } else {
                    self.loginWithKakaoAccount(observer)
                }
            }

            return Disposables.create()
        }
    }

    /// 카카오톡 앱을 통한 로그인 요청
    ///
    /// - Parameter observer: Rx Observable을 구독 중인 옵저버
    private func loginWithKakaoTalk(_ observer: AnyObserver<Result<String, Error>>) {
        userApi.loginWithKakaoTalk { oauthToken, error in
            if let error = error {
                observer.onNext(.failure(error))
            } else if let token = oauthToken?.accessToken {
                print("카카오톡 accessToken: \(token)")
                observer.onNext(.success(token))
            }
            observer.onCompleted()
        }
    }

    /// 카카오 계정(웹)을 통한 로그인 요청
    ///
    /// - Parameter observer: Rx Observable을 구독 중인 옵저버
    private func loginWithKakaoAccount(_ observer: AnyObserver<Result<String, Error>>) {
        userApi.loginWithKakaoAccount { oauthToken, error in
            if let error = error {
                observer.onNext(.failure(error))
            } else if let token = oauthToken?.accessToken {
                print("카카오 계정 accessToken: \(token)")
                observer.onNext(.success(token))
            }
            observer.onCompleted()
        }
    }
}
