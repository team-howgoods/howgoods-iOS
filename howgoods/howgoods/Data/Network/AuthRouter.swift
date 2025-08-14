//
//  AuthRouter.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import Alamofire
import Foundation

/// 인증 API 요청 경로 및 파라미터를 정의하는 라우터
///
/// - 역할:
///   - Apple, Naver, Kakao 소셜 로그인 요청을 서버에 전송하기 위한 `URLRequest` 구성
///   - 각 케이스별로 요청 경로(`path`), HTTP 메서드, 요청 바디를 설정
enum AuthRouter: URLRequestConvertible {
    
    /// Apple 로그인 요청
    case loginWithApple(code: String)
    /// Naver 로그인 요청
    case loginWithNaver(code: String)
    /// Kakao 로그인 요청
    case loginWithKakao(code: String)

    // MARK: - HTTP Method
    
    /// 모든 로그인 요청은 `POST` 메서드를 사용
    var method: HTTPMethod { .post }

    // MARK: - API Path
    
    /// 각 소셜 로그인 타입별 서버 API 엔드포인트 경로
    var path: String {
        switch self {
        case .loginWithApple:
            return "api/auth/apple/callback"
        case .loginWithNaver:
            return "api/auth/naver/callback"
        case .loginWithKakao:
            return "api/auth/kakao/callback"
        }
    }

    // MARK: - URLRequestConvertible
    
    /// `URLRequest` 객체 생성
    ///
    /// - Returns: 구성된 `URLRequest`
    /// - Throws: `JSONEncoder` 인코딩 실패 시 에러
    func asURLRequest() throws -> URLRequest {
        let url = Bundle.main.baseAPIURL
        var request = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP 메서드와 Content-Type 설정
        request.method = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // 요청 바디에 인증 코드 포함
        switch self {
        case .loginWithApple(let code),
             .loginWithNaver(let code),
             .loginWithKakao(let code):
            let dto = LoginRequestDTO(code: code)
            request.httpBody = try JSONEncoder().encode(dto)
        }

        return request
    }
}

