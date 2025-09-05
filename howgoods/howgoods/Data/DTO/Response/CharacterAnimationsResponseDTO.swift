//
//  CharacterDTO.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//

struct CharacterAnimationsResponseDTO: Decodable {
    let code: Int
    let message: String
    let validationErrors: String?
    let data: CharacterAnimationsData
    
    struct CharacterAnimationsData: Decodable {
        let items: [CharacterAnimationDTO]
    }
}

struct CharacterAnimationDTO: Decodable {
    let animationId: Int
    let animationName: String
    let characters: [CharacterDTO]
    
    func toDomain() -> CharacterAnimation {
        CharacterAnimation(
            id: animationId,
            name: animationName,
            characters: characters.map { $0.toDomain() }
        )
    }
}

struct CharacterDTO: Decodable {
    let characterId: Int
    let name: String
    let imageUrl: String

    func toDomain() -> Character {
        Character(id: characterId, name: name, imageUrl: imageUrl)
    }
}
