//
//  Character.swift
//  howgoods
//
//  Created by 양원식 on 8/23/25.
//

// MARK: - CharacterAnimation 모델
struct CharacterAnimation: Codable {
    let id: Int
    let name: String
    let characters: [Character]
}

// MARK: - Character 모델
struct Character: Codable {
    let id: Int
    let name: String
    let imageUrl: String
}
