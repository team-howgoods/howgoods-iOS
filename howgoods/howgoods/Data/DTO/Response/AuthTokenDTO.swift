//
//  AuthTokenDTO.swift
//  howgoods
//
//  Created by 양원식 on 8/6/25.
//

struct AuthTokenDTO: Decodable {
    let memberEmail: String
    let accessToken: String
    let refreshToken: String

    func toDomain() -> AuthToken {
        return AuthToken(
            memberEmail: memberEmail,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
