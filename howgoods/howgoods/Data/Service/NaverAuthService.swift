//
//  NaverAuthService.swift
//  howgoods
//
//  Created by 양원식 on 8/4/25.
//

import Foundation
import RxSwift
import NidThirdPartyLogin

/// Naver 로그인 인증을 처리하는 서비스입니다.
///
/// 네이버 SDK(`NidThirdPartyLogin`)를 이용하여 로그인, 로그아웃, 연동 해제, 사용자 프로필 조회를 지원하며,
/// 인증 결과는 `Observable<Result<...>>` 형태로 반환됩니다.
final class NaverAuthService {
    
    /// 네이버 인증 전용 객체 (싱글톤)
    private let oauth = NidOAuth.shared

    /// 초기화 시 로그인 방식을 설정합니다.
    ///
    /// 앱 로그인 우선 → 실패 시 인앱 브라우저로 fallback
    init() {
        oauth.setLoginBehavior(.appPreferredWithInAppBrowserFallback)
    }

    // MARK: - 인증 요청

    /// 네이버 로그인 인증을 시작합니다.
    ///
    /// 이미 로그인 상태라면 로그아웃 후 다시 시도합니다.
    ///
    /// - Returns: 인증 성공 시 accessToken 문자열, 실패 시 Error를 포함한 `Result`
    func authorizeWithNaver() -> Observable<Result<String, Error>> {
        return Observable.create { observer in
            
            if self.oauth.accessToken != nil {
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

    // MARK: - 로그아웃

    /// 네이버 로그아웃 요청
    ///
    /// - Returns: 완료 시 `Void` Observable
    func logout() -> Observable<Void> {
        return Observable.create { observer in
            self.oauth.logout()
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }

    // MARK: - 연동 해제

    /// 네이버 연동 해제를 요청합니다. (사용자 동의 필요)
    ///
    /// - Returns: 연동 해제 결과 (`Result<Void, NidError>`)
    func disconnect() -> Observable<Result<Void, NidError>> {
        return Observable.create { observer in
            self.oauth.disconnect { result in
                observer.onNext(result)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    // MARK: - 프로필 조회

    /// 네이버 사용자 프로필 정보를 가져옵니다.
    ///
    /// - Parameter accessToken: 사용자 인증 토큰
    /// - Returns: 프로필 정보 (`[String: String]`) 또는 오류
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
