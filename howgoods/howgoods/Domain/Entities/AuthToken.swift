//
//  LoginResponse.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

/// 로그인 응답 모델
struct AuthToken: Decodable, Equatable {
    // 서버에서 발급받는 인증 토큰
    let token: String
}
