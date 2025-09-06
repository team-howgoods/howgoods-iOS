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
    
    // 더미 데이터를 생성하는 정적 변수
       static var dummy: [GoodsItem] {
           return [
               // 주술회전 애니메이션의 굿즈 10개
               GoodsItem(id: 1, name: "주술회전 극장판0 스티커/고죠 사토루 유카타", imageUrl: "https://animate.godohosting.com/Goods/4550621155161.jpg", animationId: 18, animationName: "주술회전", characterId: 123),
               GoodsItem(id: 2, name: "주술회전 자개풍 시리즈 아크릴키홀더 Vol.2 이타도리 유지", imageUrl: "https://animate.godohosting.com/Goods/4580722007922.jpg", animationId: 18, animationName: "주술회전", characterId: 121),
               GoodsItem(id: 3, name: "주술회전 아크릴 스탠드/메가네", imageUrl: "https://animate.godohosting.com/Goods/4550621155162.jpg", animationId: 18, animationName: "주술회전", characterId: 124),
               GoodsItem(id: 4, name: "주술회전 볼펜/이타도리", imageUrl: "https://animate.godohosting.com/Goods/4550621155163.jpg", animationId: 18, animationName: "주술회전", characterId: 121),
               GoodsItem(id: 5, name: "주술회전 스티커 세트/고죠 사토루", imageUrl: "https://animate.godohosting.com/Goods/4550621155164.jpg", animationId: 18, animationName: "주술회전", characterId: 123),
               GoodsItem(id: 6, name: "주술회전 펜케이스/이타도리 유지", imageUrl: "https://animate.godohosting.com/Goods/4550621155165.jpg", animationId: 18, animationName: "주술회전", characterId: 121),
               GoodsItem(id: 7, name: "주술회전 USB 드라이브/고죠", imageUrl: "https://animate.godohosting.com/Goods/4550621155166.jpg", animationId: 18, animationName: "주술회전", characterId: 123),
               GoodsItem(id: 8, name: "주술회전 인형/메가네", imageUrl: "https://animate.godohosting.com/Goods/4550621155167.jpg", animationId: 18, animationName: "주술회전", characterId: 124),
               GoodsItem(id: 9, name: "주술회전 포스터/이타도리", imageUrl: "https://animate.godohosting.com/Goods/4550621155168.jpg", animationId: 18, animationName: "주술회전", characterId: 121),
               GoodsItem(id: 10, name: "주술회전 티셔츠/고죠 사토루", imageUrl: "https://animate.godohosting.com/Goods/4550621155169.jpg", animationId: 18, animationName: "주술회전", characterId: 123),
               
               // 나루토 애니메이션의 굿즈 10개
               GoodsItem(id: 11, name: "나루토 아크릴 피규어/우즈마키 나루토", imageUrl: "https://animate.godohosting.com/Goods/4550621155170.jpg", animationId: 19, animationName: "나루토", characterId: 130),
               GoodsItem(id: 12, name: "나루토 엽서 세트/사스케", imageUrl: "https://animate.godohosting.com/Goods/4550621155171.jpg", animationId: 19, animationName: "나루토", characterId: 131),
               GoodsItem(id: 13, name: "나루토 스티커/사스케", imageUrl: "https://animate.godohosting.com/Goods/4550621155172.jpg", animationId: 19, animationName: "나루토", characterId: 131),
               GoodsItem(id: 14, name: "나루토 점토 피규어/사스케", imageUrl: "https://animate.godohosting.com/Goods/4550621155173.jpg", animationId: 19, animationName: "나루토", characterId: 131),
               GoodsItem(id: 15, name: "나루토 자개풍 시리즈/카카시", imageUrl: "https://animate.godohosting.com/Goods/4550621155174.jpg", animationId: 19, animationName: "나루토", characterId: 132),
               GoodsItem(id: 16, name: "나루토 미니어쳐/카카시", imageUrl: "https://animate.godohosting.com/Goods/4550621155175.jpg", animationId: 19, animationName: "나루토", characterId: 132),
               GoodsItem(id: 17, name: "나루토 아크릴 키홀더/사스케", imageUrl: "https://animate.godohosting.com/Goods/4550621155176.jpg", animationId: 19, animationName: "나루토", characterId: 131),
               GoodsItem(id: 18, name: "나루토 티셔츠/나루토", imageUrl: "https://animate.godohosting.com/Goods/4550621155177.jpg", animationId: 19, animationName: "나루토", characterId: 130),
               GoodsItem(id: 19, name: "나루토 핸드폰 케이스/카카시", imageUrl: "https://animate.godohosting.com/Goods/4550621155178.jpg", animationId: 19, animationName: "나루토", characterId: 132),
               GoodsItem(id: 20, name: "나루토 키링/우즈마키 나루토", imageUrl: "https://animate.godohosting.com/Goods/4550621155179.jpg", animationId: 19, animationName: "나루토", characterId: 130),

               // 원피스 애니메이션의 굿즈 10개
               GoodsItem(id: 21, name: "원피스 피규어/루피", imageUrl: "https://animate.godohosting.com/Goods/4550621155180.jpg", animationId: 20, animationName: "원피스", characterId: 140),
               GoodsItem(id: 22, name: "원피스 티셔츠/조로", imageUrl: "https://animate.godohosting.com/Goods/4550621155181.jpg", animationId: 20, animationName: "원피스", characterId: 141),
               GoodsItem(id: 23, name: "원피스 아크릴 스탠드/루피", imageUrl: "https://animate.godohosting.com/Goods/4550621155182.jpg", animationId: 20, animationName: "원피스", characterId: 140),
               GoodsItem(id: 24, name: "원피스 피규어/조로", imageUrl: "https://animate.godohosting.com/Goods/4550621155183.jpg", animationId: 20, animationName: "원피스", characterId: 141),
               GoodsItem(id: 25, name: "원피스 스티커/루피", imageUrl: "https://animate.godohosting.com/Goods/4550621155184.jpg", animationId: 20, animationName: "원피스", characterId: 140),
               GoodsItem(id: 26, name: "원피스 볼펜/조로", imageUrl: "https://animate.godohosting.com/Goods/4550621155185.jpg", animationId: 20, animationName: "원피스", characterId: 141),
               GoodsItem(id: 27, name: "원피스 아크릴 키홀더/루피", imageUrl: "https://animate.godohosting.com/Goods/4550621155186.jpg", animationId: 20, animationName: "원피스", characterId: 140),
               GoodsItem(id: 28, name: "원피스 엽서/조로", imageUrl: "https://animate.godohosting.com/Goods/4550621155187.jpg", animationId: 20, animationName: "원피스", characterId: 141),
               GoodsItem(id: 29, name: "원피스 가방/루피", imageUrl: "https://animate.godohosting.com/Goods/4550621155188.jpg", animationId: 20, animationName: "원피스", characterId: 140),
               GoodsItem(id: 30, name: "원피스 머그컵/조로", imageUrl: "https://animate.godohosting.com/Goods/4550621155189.jpg", animationId: 20, animationName: "원피스", characterId: 141)
           ]
       }
}
