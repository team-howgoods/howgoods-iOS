//
//  AuthTokenDTO.swift
//  howgoods
//
//  Created by 양원식 on 8/6/25.
//

/// 서버로부터 받은 인증 토큰 정보를 담는 DTO입니다.
///
/// 로그인/회원가입 등 인증 API 호출 후 서버가 반환하는 토큰 정보입니다.
/// 이 객체는 도메인 모델 `AuthToken`으로 변환될 수 있습니다.
struct AuthTokenDTO: Decodable {
    
    /// 로그인된 회원의 이메일 주소
    let memberEmail: String
    
    /// 액세스 토큰 (API 요청 시 사용)
    let accessToken: String
    
    /// 리프레시 토큰 (토큰 갱신 시 사용)
    let refreshToken: String

    /// DTO를 도메인 모델 `AuthToken`으로 변환합니다.
    ///
    /// - Returns: `AuthToken` 도메인 모델 인스턴스
    func toDomain() -> AuthToken {
        return AuthToken(
            memberEmail: memberEmail,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
