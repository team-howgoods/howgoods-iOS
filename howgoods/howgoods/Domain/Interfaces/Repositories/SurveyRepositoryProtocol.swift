//
//  SurveyRepositoryProtocol.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//

protocol SurveyRepositoryProtocol {
    func fetchAnimations(completion: @escaping (Result<[Animation], Error>) -> Void)
    func fetchCharacters(animationIds: [Int], completion: @escaping (Result<[CharacterAnimation], Error>) -> Void)
    func fetchGoodsTypes(completion: @escaping (Result<[GoodsType], Error>) -> Void)
    func fetchGoods(animationIds: [Int], goodsTypeIds: [Int], completion: @escaping (Result<[GoodsItem], Error>) -> Void)
}
