//
//  LoginResponse.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

/// 인증 토큰을 나타내는 도메인 모델입니다.
///
/// 로그인 또는 회원가입 성공 시 서버에서 발급되는 토큰 정보를 담고 있으며,
/// access token은 API 요청 인증에 사용되고, refresh token은 만료된 토큰을 갱신할 때 사용됩니다.
struct AuthToken: Decodable, Equatable {
    
    /// 로그인된 사용자의 이메일 주소
    let memberEmail: String
    
    /// 인증에 사용할 access token (단기 토큰)
    let accessToken: String
    
    /// access token 갱신에 사용할 refresh token (장기 토큰)
    let refreshToken: String
}
