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
let dummyGoods: [GoodsItem] = [
    // 귀멸의 칼날 (animationId: 1)
    GoodsItem(id: 101, name: "탄지로 아크릴 스탠드", imageUrl: "https://i.imgur.com/21.png", animationId: 1, animationName: "귀멸의 칼날", characterId: 1),
    GoodsItem(id: 102, name: "네즈코 티셔츠", imageUrl: "https://i.imgur.com/22.png", animationId: 1, animationName: "귀멸의 칼날", characterId: 2),
    GoodsItem(id: 103, name: "렌고쿠 키링", imageUrl: "https://i.imgur.com/23.png", animationId: 1, animationName: "귀멸의 칼날", characterId: 3),
    GoodsItem(id: 104, name: "이노스케 인형", imageUrl: "https://i.imgur.com/24.png", animationId: 1, animationName: "귀멸의 칼날", characterId: 4),
    GoodsItem(id: 105, name: "시노부 포토카드", imageUrl: "https://i.imgur.com/25.png", animationId: 1, animationName: "귀멸의 칼날", characterId: 5),

    // 나루토 (animationId: 2)
    GoodsItem(id: 201, name: "나루토 포토카드", imageUrl: "https://i.imgur.com/26.png", animationId: 2, animationName: "나루토", characterId: 6),
    GoodsItem(id: 202, name: "사스케 인형", imageUrl: "https://i.imgur.com/27.png", animationId: 2, animationName: "나루토", characterId: 7),
    GoodsItem(id: 203, name: "사쿠라 문구세트", imageUrl: "https://i.imgur.com/28.png", animationId: 2, animationName: "나루토", characterId: 8),
    GoodsItem(id: 204, name: "카카시 아크릴 스탠드", imageUrl: "https://i.imgur.com/29.png", animationId: 2, animationName: "나루토", characterId: 9),
    GoodsItem(id: 205, name: "이타치 티셔츠", imageUrl: "https://i.imgur.com/30.png", animationId: 2, animationName: "나루토", characterId: 10),

    // 원피스 (animationId: 3)
    GoodsItem(id: 301, name: "루피 티셔츠", imageUrl: "https://i.imgur.com/31.png", animationId: 3, animationName: "원피스", characterId: 11),
    GoodsItem(id: 302, name: "조로 아크릴 스탠드", imageUrl: "https://i.imgur.com/32.png", animationId: 3, animationName: "원피스", characterId: 12),
    GoodsItem(id: 303, name: "나미 키링", imageUrl: "https://i.imgur.com/33.png", animationId: 3, animationName: "원피스", characterId: 13),
    GoodsItem(id: 304, name: "상디 인형", imageUrl: "https://i.imgur.com/34.png", animationId: 3, animationName: "원피스", characterId: 14),
    GoodsItem(id: 305, name: "우솝 포토카드", imageUrl: "https://i.imgur.com/35.png", animationId: 3, animationName: "원피스", characterId: 15)
]
