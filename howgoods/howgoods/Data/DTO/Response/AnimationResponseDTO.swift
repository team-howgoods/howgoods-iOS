//
//  AnimationResponseDTO.swift
//  howgoods
//
//  Created by 양원식 on 8/22/25.
//

struct AnimationResponseDTO: Decodable {
    let code: Int
    let message: String
    let validationErrors: String?
    let data: AnimationListData
    
    struct AnimationListData: Decodable {
        let items: [AnimationItemDTO]
    }
}

struct AnimationItemDTO: Decodable {
    let animationId: Int
    let name: String
    let imageUrl: String
    
    func toDomain() -> Animation {
        return Animation(
            id: animationId,
            name: name,
            imageUrl: imageUrl
        )
    }
}
