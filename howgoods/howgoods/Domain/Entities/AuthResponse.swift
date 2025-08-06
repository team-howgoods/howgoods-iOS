//
//  AuthResponse.swift
//  howgoods
//
//  Created by 양원식 on 8/6/25.
//

struct AuthResponse: Decodable {
    let success: Bool
    let code: Int
    let message: String
    let validationErrors: String?
    let data: AuthToken
}
