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

final class KakaoAuthService {
    
    private let userApi = UserApi.shared

    func authorizeWithKakao() -> Observable<Result<String, Error>> {
        return Observable.create { observer in
            
            // TODO: 네이버랑 동일
            // 기존 로그인 상태가 있다면 로그아웃 처리
            self.userApi.logout { logoutError in
                if let logoutError = logoutError {
                    print("카카오 로그아웃 실패: \(logoutError.localizedDescription)")
                } else {
                    print("이미 로그인되어 있어 로그아웃 후 재시도합니다.")
                }

                // 로그아웃 후 현재 토큰 상태 출력 (accessToken은 직접 추출해야 함)
                let currentToken = AuthApi.hasToken() ? (TokenManager.manager.getToken()?.accessToken ?? "없음") : "없음"
                print("로그인 시도 직전 accessToken 상태: \(currentToken)")

                // 로그인 시도
                if UserApi.isKakaoTalkLoginAvailable() {
                    self.loginWithKakaoTalk(observer)
                } else {
                    self.loginWithKakaoAccount(observer)
                }
            }

            return Disposables.create()
        }
    }

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
