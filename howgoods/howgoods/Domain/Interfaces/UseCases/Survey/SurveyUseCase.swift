//
//  SurveyUseCase.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//

final class SurveyUseCase: SurveyUseCaseProtocol {
    private let repository: SurveyRepository
    
    init(repository: SurveyRepository) {
        self.repository = repository
    }
    
    func fetchAnimations(completion: @escaping (Result<[Animation], Error>) -> Void) {
        repository.fetchAnimations(completion: completion)
    }
    
    func fetchCharacters(animationIds: [Int], completion: @escaping (Result<[CharacterAnimation], Error>) -> Void) {
        repository.fetchCharacters(animationIds: animationIds, completion: completion)
    }
    
    func fetchGoodsTypes(completion: @escaping (Result<[GoodsType], Error>) -> Void) {
        repository.fetchGoodsTypes(completion: completion)
    }
    
    func fetchGoods(animationIds: [Int], goodsTypeIds: [Int], completion: @escaping (Result<[GoodsItem], Error>) -> Void) {
        repository.fetchGoods(animationIds: animationIds, goodsTypeIds: goodsTypeIds, completion: completion)
    }
}
