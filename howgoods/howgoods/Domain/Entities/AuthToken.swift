//
//  LoginResponse.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

struct AuthToken: Decodable, Equatable {
    let memberEmail: String
    let accessToken: String
    let refreshToken: String
}

