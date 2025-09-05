//
//  AuthRepository.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//
import Combine

/// 인증 관련 저장소 구현체
///
/// - 역할:
///   - Apple, Naver, Kakao 각 로그인 서비스(`AuthService`)를 호출하여 인증 플로우 실행
///   - 필요 시 서버에 인증 코드를 직접 전달하여 최종 액세스 토큰 발급
///   - `AuthRepositoryProtocol`을 구현하여 UseCase 계층에 데이터 제공
final class AuthRepository: AuthRepositoryProtocol {
    
    // MARK: - Dependencies
    
    /// Apple 로그인 처리 서비스
    private let appleAuthService: AppleAuthService
    
    /// Naver 로그인 처리 서비스
    private let naverAuthService: NaverAuthService
    
    /// Kakao 로그인 처리 서비스
    private let kakaoAuthService: KakaoAuthService
    
    /// 서버와의 인증 토큰 교환을 처리하는 네트워크 서비스
    private let authNetworkService: AuthNetworkService

    // MARK: - Initializer
    
    /// 인증 저장소 초기화
    /// - Parameters:
    ///   - appleAuthService: Apple 로그인 처리 서비스
    ///   - naverAuthService: Naver 로그인 처리 서비스
    ///   - kakaoAuthService: Kakao 로그인 처리 서비스
    ///   - authNetworkService: 서버 통신용 네트워크 서비스
    init(appleAuthService: AppleAuthService,
         naverAuthService: NaverAuthService,
         kakaoAuthService: KakaoAuthService,
         authNetworkService: AuthNetworkService) {
        self.appleAuthService = appleAuthService
        self.naverAuthService = naverAuthService
        self.kakaoAuthService = kakaoAuthService
        self.authNetworkService = authNetworkService
    }

    // MARK: - AuthRepositoryProtocol
    
    /// Apple 로그인 실행
    /// - Returns: 로그인 성공 시 토큰 문자열, 실패 시 에러를 포함한 퍼블리셔
    func loginWithApple() -> AnyPublisher<Result<AuthToken, Error>, Never> {
        appleAuthService.authorizeWithApple()
    }

    /// Naver 로그인 실행
    func loginWithNaver() -> AnyPublisher<Result<AuthToken, Error>, Never> {
        naverAuthService.authorizeWithNaver()
    }

    /// Kakao 로그인 실행
    func loginWithKakao() -> AnyPublisher<Result<AuthToken, Error>, Never> {
        kakaoAuthService.authorizeWithKakao()
    }

    /// 발급받은 인증 코드를 서버로 전송하여 최종 액세스 토큰 발급
    ///
    /// - Parameter code: 인증 코드
    /// - Returns:
    ///   - `.success(String)`: 서버 인증 성공 시 발급받은 액세스 토큰
    ///   - `.failure(Error)`: 인증 실패 시 에러
    func sendCodeToServer(code: String, type: LoginType) -> AnyPublisher<Result<AuthToken, Error>, Never> {
        let publisher: AnyPublisher<Result<AuthToken, NetworkError>, Never>
        
        switch type {
        case .apple:
            publisher = authNetworkService.loginWithApple(code: code)
        case .kakao:
            publisher = authNetworkService.loginWithKakao(code: code)
        case .naver:
            publisher = authNetworkService.loginWithNaver(code: code)
        }
        
        return publisher
            .map { result in
                switch result {
                case .success(let token):
                    return .success(token)
                case .failure(let error):
                    return .failure(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func refreshToken(_ refreshToken: String) -> AnyPublisher<Result<AuthToken, Error>, Never> {
        authNetworkService.refreshToken(refreshToken)
            .map { result in
                switch result {
                case .success(let token):
                    if let loginType = TokenStorage.loadLoginType() {
                        TokenStorage.save(token: token, loginType: loginType)
                    }
                    return .success(token)
                case .failure(let error):
                    return .failure(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
