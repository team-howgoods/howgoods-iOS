//
//  AuthRouter.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import Alamofire
import Foundation

/// 인증 관련 API 요청의 스펙을 정의하는 라우터
enum AuthRouter: URLRequestConvertible {
    
    /// Apple 로그인 요청 (authorization code 전송)
    case loginWithApple(code: String)
    
    // TODO: case loginWithGoogle(token: String)
    // TODO: case loginWithKakao(token: String)

    var method: HTTPMethod { .post }

    var path: String {
        switch self {
        case .loginWithApple:
            return "/api/auth/apple/callback"
        // TODO: case .loginWithNaver:
        //   return "/api/auth/naver"
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = Bundle.main.baseAPIURL
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.method = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        switch self {
        case .loginWithApple(let code):
            request.httpBody = try JSONEncoder().encode(["code": code])
        }

        return request
    }
}
