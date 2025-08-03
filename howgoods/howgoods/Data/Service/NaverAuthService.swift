//
//  NaverAuthService.swift
//  howgoods
//
//  Created by 양원식 on 8/4/25.
//

import Foundation
import RxSwift
import NidThirdPartyLogin

final class NaverAuthService {

    private let oauth = NidOAuth.shared

    init() {
        // 앱 preferred → 실패 시 인앱 브라우저
        oauth.setLoginBehavior(.appPreferredWithInAppBrowserFallback)
    }

    /// 네이버 로그인 흐름
    func authorizeWithNaver() -> Observable<Result<String, Error>> {
        return Observable.create { observer in
            
            // TODO: 네이버는 Firebase 처럼 토큰이 유지가 됌
            if (self.oauth.refreshToken != nil) {
                print("이미 로그인되어 있어 로그아웃 후 재시도합니다.")
                self.oauth.logout()
            }
            
            let currentToken = self.oauth.accessToken?.tokenString
            print("로그인 시도 직전 accessToken 상태: \(currentToken ?? "없음")")
            
            self.oauth.requestLogin { result in
                switch result {
                case .success(let loginResult):
                    let accessToken = loginResult.accessToken.tokenString
                    print("네이버 accessToken: \(accessToken)")
                    observer.onNext(.success(accessToken))

                case .failure(let error):
                    observer.onNext(.failure(error))
                }

                observer.onCompleted()
            }

            return Disposables.create()
        }
    }


    /// 로그아웃
    func logout() -> Observable<Void> {
        return Observable.create { observer in
            self.oauth.logout()
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }

    /// 연동 해제 (선택)
    func disconnect() -> Observable<Result<Void, NidError>> {
        return Observable.create { observer in
            self.oauth.disconnect { result in
                observer.onNext(result)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    /// 프로필 조회 (선택)
    func fetchProfile(accessToken: String) -> Observable<Result<[String: String], NidError>> {
        return Observable.create { observer in
            self.oauth.getUserProfile(accessToken: accessToken) { result in
                observer.onNext(result)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

