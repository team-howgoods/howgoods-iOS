//
//  SearchGoodsResponseDTO.swift
//  howgoods
//
//  Created by 양원식 on 9/6/25.
//

struct SearchGoodsResponseDTO: Decodable {
    let code: Int
    let message: String
    let data: SearchGoodsDataDTO
}

struct SearchGoodsDataDTO: Decodable {
    let items: [SearchGoodsItemDTO]
}

struct SearchGoodsItemDTO: Decodable {
    let goodsId: Int
    let name: String
    let imageUrl: String
    
    func toDomain() -> GoodsItem {
        GoodsItem(
            id: goodsId,
            name: name,
            imageUrl: imageUrl,
            animationId: -1,        // 기본값
            animationName: "",      // 기본값
            characterId: -1         // 기본값
        )
    }
}
