//
//  AuthTokenDTO.swift
//  howgoods
//
//  Created by 양원식 on 8/6/25.
//

/// 서버로부터 받은 인증 토큰 정보를 담는 데이터 전송 객체(DTO)
///
/// - 사용 목적:
///   - 로그인, 회원가입, 토큰 갱신 등 인증 관련 API 호출 후 서버에서 반환하는 토큰 데이터를 매핑
///   - 도메인 계층의 `AuthToken` 모델로 변환하여 앱 전역에서 사용
struct AuthTokenDTO: Decodable {
    
    /// 로그인된 회원의 이메일 주소
    let nickname: String?
    
    /// 액세스 토큰
    /// - 보호된 API 요청 시 인증 헤더(`Authorization: Bearer <token>`)에 포함
    let accessToken: String
    
    /// 리프레시 토큰
    /// - 액세스 토큰이 만료되었을 때 새로운 토큰을 발급받기 위해 사용
    let refreshToken: String

    /// DTO를 도메인 모델 `AuthToken`으로 변환
    ///
    /// - Returns: `AuthToken` 도메인 모델 인스턴스
    func toDomain() -> AuthToken {
        return AuthToken(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
