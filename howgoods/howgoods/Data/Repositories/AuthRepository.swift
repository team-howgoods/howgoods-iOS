//
//  AuthRepository.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//
import RxSwift

/// 인증 관련 기능을 담당하는 리포지토리입니다.
///
/// Apple, Naver, Kakao 소셜 로그인 인증 흐름을 추상화하여 ViewModel 또는 UseCase 계층에서 쉽게 사용할 수 있도록 제공합니다.
/// 인증 코드 획득 → 서버에 코드 전송 → accessToken 반환까지의 전체 과정을 캡슐화합니다.
final class AuthRepository: AuthRepositoryProtocol {

    // MARK: - Dependencies

    /// Apple 로그인 인증 로직 담당
    private let appleAuthService: AppleAuthService

    /// Naver 로그인 인증 로직 담당
    private let naverAuthService: NaverAuthService

    /// Kakao 로그인 인증 로직 담당
    private let kakaoAuthService: KakaoAuthService

    /// 인증 코드 서버 전송 및 토큰 수신 로직 담당
    private let authNetworkService: AuthNetworkService

    // MARK: - Initializer

    /// 인증에 필요한 각 서비스들을 주입받아 초기화합니다.
    init(
        appleAuthService: AppleAuthService,
        naverAuthService: NaverAuthService,
        kakaoAuthService: KakaoAuthService,
        authNetworkService: AuthNetworkService
    ) {
        self.appleAuthService = appleAuthService
        self.naverAuthService = naverAuthService
        self.kakaoAuthService = kakaoAuthService
        self.authNetworkService = authNetworkService
    }

    // MARK: - Apple Login

    /// Apple 로그인 인증을 시작합니다.
    ///
    /// - Returns: 인증 성공 시 `authorizationCode`, 실패 시 `Error`를 포함한 `Result`
    func loginWithApple() -> Observable<Result<String, Error>> {
        return appleAuthService.authorizeWithApple()
    }

    /// Apple 인증 코드를 서버에 전송하고 access token을 반환합니다.
    ///
    /// - Parameter code: Apple에서 발급받은 authorization code
    /// - Returns: 서버에서 받은 accessToken 또는 Error
    func sendCodeToServer(code: String) -> Observable<Result<String, Error>> {
        return authNetworkService.loginWithApple(code: code)
            .map { result in
                switch result {
                case .success(let tokenEntity):
                    return .success(tokenEntity.accessToken)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }

    // MARK: - Naver Login

    /// Naver 로그인 인증을 시작합니다.
    func loginWithNaver() -> Observable<Result<String, Error>> {
        return naverAuthService.authorizeWithNaver()
    }

    /// Naver 인증 코드를 서버에 전송하고 access token을 반환합니다.
    func sendNaverCodeToServer(code: String) -> Observable<Result<String, Error>> {
        return authNetworkService.loginWithNaver(code: code)
            .map { result in
                switch result {
                case .success(let tokenEntity):
                    return .success(tokenEntity.accessToken)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }

    // MARK: - Kakao Login

    /// Kakao 로그인 인증을 시작합니다.
    func loginWithKakao() -> Observable<Result<String, Error>> {
        return kakaoAuthService.authorizeWithKakao()
    }

    /// Kakao 인증 코드를 서버에 전송하고 access token을 반환합니다.
    func sendKakaoCodeToServer(code: String) -> Observable<Result<String, Error>> {
        return authNetworkService.loginWithKakao(code: code)
            .map { result in
                switch result {
                case .success(let tokenEntity):
                    return .success(tokenEntity.accessToken)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
