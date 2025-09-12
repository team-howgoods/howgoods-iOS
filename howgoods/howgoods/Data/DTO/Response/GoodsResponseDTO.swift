//
//  GoodsResponseDTO.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//

struct GoodsResponseDTO: Codable {
    let data: GoodsDataDTO
    
    struct GoodsDataDTO: Codable {
        let items: [GoodsItemDTO]
    }
}

struct GoodsItemDTO: Codable {
    let goodsId: Int
    let name: String
    let imageUrl: String
    let animationId: Int
    let animationName: String
    let characterId: Int
    
    func toDomain() -> GoodsItem {
        GoodsItem(
            id: goodsId,
            name: name,
            imageUrl: imageUrl,
            animationId: animationId,
            animationName: animationName,
            characterId: characterId
        )
    }
}
