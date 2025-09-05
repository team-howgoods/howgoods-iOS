//
//  SurveyRepository.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//
import Alamofire

final class SurveyRepository: SurveyRepositoryProtocol {
    func fetchAnimations(completion: @escaping (Result<[Animation], Error>) -> Void) {
        AF.request(SurveyRouter.fetchAnimations)
            .validate()
            .responseDecodable(of: AnimationResponseDTO.self) { response in
                switch response.result {
                case .success(let dto):
                    completion(.success(dto.data.items.map { $0.toDomain() }))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchCharacters(animationIds: [Int], completion: @escaping (Result<[CharacterAnimation], Error>) -> Void) {
        AF.request(SurveyRouter.fetchCharacters(animationIds))
            .validate()
            .responseDecodable(of: CharacterAnimationsResponseDTO.self) { response in
                switch response.result {
                case .success(let dto):
                    completion(.success(dto.data.items.map { $0.toDomain() }))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchGoodsTypes(completion: @escaping (Result<[GoodsType], Error>) -> Void) {
        AF.request(SurveyRouter.fetchGoods)
            .validate()
            .responseDecodable(of: GoodsTypeResponseDTO.self) { response in
                switch response.result {
                case .success(let dto):
                    completion(.success(dto.data.items.map { $0.toDomain() }))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

}
