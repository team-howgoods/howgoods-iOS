//
//  SubmitSurveyRequestDTO.swift
//  howgoods
//
//  Created by 양원식 on 8/22/25.
//

struct SubmitSurveyRequestDTO: Encodable {
    let animationSurveyResults: [AnimationSurveyResultDTO]
    let characterSurveyResults: [CharacterSurveyResultDTO]
    let goodsTypeSurveyResults: [GoodsTypeSurveyResultDTO]
    let goodsSurveyResults: [GoodsSurveyResultDTO]
}
