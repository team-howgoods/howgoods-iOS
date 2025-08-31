//
//  GoodsTypeResponseDTO.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//

struct GoodsTypeResponseDTO: Decodable {
    let code: Int
    let message: String
    let validationErrors: String?
    let data: GoodsTypeListData
    
    struct GoodsTypeListData: Decodable {
        let items: [GoodsTypeDTO]
    }
}

struct GoodsTypeDTO: Decodable {
    let goodsTypeId: Int
    let name: String
    let imageUrl: String

    func toDomain() -> GoodsType {
        GoodsType(goodsTypeId: goodsTypeId, name: name, imageUrl: imageUrl)
    }
}
