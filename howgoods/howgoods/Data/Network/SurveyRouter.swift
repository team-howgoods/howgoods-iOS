//
//  SurveyRouter.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//

import Alamofire
import Foundation

enum SurveyRouter: URLRequestConvertible {
    case fetchAnimations
    case fetchGoods
    case fetchCharacters([Int])
    
    private var baseURL: URL {
        return Bundle.main.baseAPIURL
    }
    
    private var method: HTTPMethod {
        switch self {
        case .fetchAnimations, .fetchGoods, .fetchCharacters:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .fetchAnimations:
            return "/api/survey/animations"
        case .fetchGoods:
            return "/api/survey/goods-types"
        case .fetchCharacters:
            return "/api/survey/characters"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var url = baseURL.appendingPathComponent(path)
        
        switch self {
        case .fetchCharacters(let ids):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            // Swagger처럼 animationIds=1&animationIds=2&animationIds=3 형식으로 조립
            components?.queryItems = ids.map { URLQueryItem(name: "animationIds", value: "\($0)") }
            if let composedURL = components?.url {
                url = composedURL
            }
        default:
            break
        }
        
        var request = URLRequest(url: url)
        request.method = method
        
        // GET 요청일 때는 Content-Type을 안 붙여도 됨
        // 붙이면 서버에 따라 403 나오는 경우 있음
        if method != .get {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
}
