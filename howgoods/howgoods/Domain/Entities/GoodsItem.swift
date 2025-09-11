//
//  GoodsItem.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//

struct GoodsItem: Codable, Hashable {
    let id: Int
    let name: String
    let imageUrl: String
    let animationId: Int
    let animationName: String
    let characterId: Int
}
