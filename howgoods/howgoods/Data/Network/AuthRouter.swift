//
//  AuthRouter.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import Alamofire
import Foundation

/// 인증 관련 API 요청의 스펙을 정의하는 라우터입니다.
///
/// `URLRequestConvertible`을 채택하여 `Alamofire` 요청에 바로 사용할 수 있도록 구성되어 있습니다.
///
/// 각각의 소셜 로그인 방식(Apple, Naver, Kakao)에 따라 요청 경로(path)와 body(`LoginRequestDTO`)가 설정됩니다.
enum AuthRouter: URLRequestConvertible {
    
    /// Apple 로그인 요청
    /// - Parameter code: Apple 로그인 후 획득한 인증 코드 (authorizationCode)
    case loginWithApple(code: String)
    
    /// Naver 로그인 요청
    /// - Parameter code: Naver 로그인 후 획득한 인증 코드
    case loginWithNaver(code: String)
    
    /// Kakao 로그인 요청
    /// - Parameter code: Kakao 로그인 후 획득한 인증 코드
    case loginWithKakao(code: String)

    /// HTTP 요청 방식 (모든 케이스에서 POST)
    var method: HTTPMethod { .post }

    /// 요청 경로 (소셜별 콜백 URL)
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

    /// URLRequest를 구성하여 반환합니다.
    ///
    /// - Returns: `URLRequest` 인스턴스 (Alamofire에서 사용 가능)
    /// - Throws: `EncodingError` 발생 시 throw
    func asURLRequest() throws -> URLRequest {
        // Info.plist에 정의된 BASE_API_URL 사용
        let url = Bundle.main.baseAPIURL

        var request = URLRequest(url: url.appendingPathComponent(path))
        request.method = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // 각 로그인 케이스에 대해 공통적으로 LoginRequestDTO 생성 및 JSON 인코딩
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
