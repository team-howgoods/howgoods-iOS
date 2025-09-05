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
    case fetchGoodsType
    case fetchCharacters([Int])
    case fetchGoods([Int], [Int])
    
    private var baseURL: URL {
        return Bundle.main.baseAPIURL
    }
    
    private var method: HTTPMethod {
        switch self {
        case .fetchAnimations, .fetchGoodsType, .fetchCharacters, .fetchGoods:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .fetchAnimations:
            return "/api/survey/animations"
        case .fetchGoodsType:
            return "/api/survey/goods-types"
        case .fetchCharacters:
            return "/api/survey/characters"
        case .fetchGoods:
            return "/api/survey/goods"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var url = baseURL.appendingPathComponent(path)
        
        switch self {
        case .fetchCharacters(let ids):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = ids.map { URLQueryItem(name: "animationIds", value: "\($0)") }
            if let composedURL = components?.url { url = composedURL }
            
        case .fetchGoods(let animationIds, let goodsTypeIds):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            var query: [URLQueryItem] = []
            query.append(contentsOf: animationIds.map { URLQueryItem(name: "animationIds", value: "\($0)") })
            query.append(contentsOf: goodsTypeIds.map { URLQueryItem(name: "goodsTypeIds", value: "\($0)") })
            components?.queryItems = query
            if let composedURL = components?.url { url = composedURL }
            
        default:
            break
        }
        
        var request = URLRequest(url: url)
        request.method = method
        return request
    }
}
