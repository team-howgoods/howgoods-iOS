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
    case searchGoods(String)
    case submitSurvey(SubmitSurveyRequestDTO)
    
    private var baseURL: URL {
        return Bundle.main.baseAPIURL
    }
    
    private var method: HTTPMethod {
        switch self {
        case .fetchAnimations, .fetchGoodsType, .fetchCharacters, .fetchGoods, .searchGoods:
            return .get
        case .submitSurvey:
            return .post
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
        case .searchGoods:
            return "/api/survey/search/goods"
        case .submitSurvey:
            return "/api/survey"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        
        switch self {
        case .fetchCharacters(let ids):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = ids.map { URLQueryItem(name: "animationIds", value: "\($0)") }
            if let composedURL = components?.url { request.url = composedURL }
            
        case .fetchGoods(let animationIds, let goodsTypeIds):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            var query: [URLQueryItem] = []
            query.append(contentsOf: animationIds.map { URLQueryItem(name: "animationIds", value: "\($0)") })
            query.append(contentsOf: goodsTypeIds.map { URLQueryItem(name: "goodsTypeIds", value: "\($0)") })
            components?.queryItems = query
            if let composedURL = components?.url { request.url = composedURL }
            
        case .searchGoods(let keyword):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "keyword", value: keyword)]
            if let composedURL = components?.url { request.url = composedURL }
            
        case .submitSurvey(let dto):
            request = try JSONEncoding.default.encode(request, with: dto.toDictionary())
            
        default:
            break
        }
        return request
    }
}
