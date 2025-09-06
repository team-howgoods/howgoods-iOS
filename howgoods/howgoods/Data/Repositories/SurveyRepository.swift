//
//  SurveyRepository.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//
import Alamofire

final class SurveyRepository: SurveyRepositoryProtocol {
    private let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func fetchAnimations(completion: @escaping (Result<[Animation], Error>) -> Void) {
        session.request(SurveyRouter.fetchAnimations)
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
        session.request(SurveyRouter.fetchCharacters(animationIds))
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
        session.request(SurveyRouter.fetchGoodsType)
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
    
    func fetchGoods(animationIds: [Int], goodsTypeIds: [Int], completion: @escaping (Result<[GoodsItem], Error>) -> Void) {
        session.request(SurveyRouter.fetchGoods(animationIds, goodsTypeIds))
            .validate()
            .responseDecodable(of: GoodsResponseDTO.self) { response in
                switch response.result {
                case .success(let dto):
                    print("fetchGoods 응답 성공")
                    print("animations:", animationIds)
                    print("goodsTypes:", goodsTypeIds)
                    print("raw dto:", dto)

                    let items = dto.data.items.map { $0.toDomain() }
                    print("변환된 GoodsItem 개수:", items.count)
                    items.forEach { print("   •", $0) }

                    completion(.success(items))

                case .failure(let error):
                    print("fetchGoods 실패:", error)
                    if let data = response.data,
                       let rawString = String(data: data, encoding: .utf8) {
                        print("서버 raw response:", rawString)
                    }
                    completion(.failure(error))
                }
            }
    }
    
    func searchGoods(keyword: String, completion: @escaping (Result<[GoodsItem], Error>) -> Void) {
        session.request(SurveyRouter.searchGoods(keyword))
            .validate()
            .responseDecodable(of: SearchGoodsResponseDTO.self) { response in
                switch response.result {
                case .success(let dto):
                    completion(.success(dto.data.items.map { $0.toDomain() }))
                case .failure(let error):
                    if let data = response.data,
                       let rawString = String(data: data, encoding: .utf8) {
                        print("searchGoods 실패, raw response:", rawString)
                    }
                    completion(.failure(error))
                }
            }
    }
    
    func submitSurvey(
        requestDTO: SubmitSurveyRequestDTO,
        completion: @escaping (Result<SubmitSurveyResponseDTO, Error>) -> Void
    ) {
        session.request(SurveyRouter.submitSurvey(requestDTO))
            .validate()
            .responseDecodable(of: SubmitSurveyResponseDTO.self) { response in
                switch response.result {
                case .success(let dto):
                    completion(.success(dto))
                case .failure(let error):
                    if let data = response.data,
                       let rawString = String(data: data, encoding: .utf8) {
                        print("submitSurvey 실패, raw response:", rawString)
                    }
                    completion(.failure(error))
                }
            }
    }
}
