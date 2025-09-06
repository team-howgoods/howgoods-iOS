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

extension SubmitSurveyRequestDTO {
    var normalized: SubmitSurveyRequestDTO {
        return SubmitSurveyRequestDTO(
            animationSurveyResults: animationSurveyResults.isEmpty
                ? [AnimationSurveyResultDTO(animationId: nil)]
                : animationSurveyResults,
            characterSurveyResults: characterSurveyResults.isEmpty
                ? [CharacterSurveyResultDTO(characterId: nil)]
                : characterSurveyResults,
            goodsTypeSurveyResults: goodsTypeSurveyResults.isEmpty
                ? [GoodsTypeSurveyResultDTO(goodsTypeId: nil)]
                : goodsTypeSurveyResults,
            goodsSurveyResults: goodsSurveyResults.isEmpty
                ? [GoodsSurveyResultDTO(goodsId: nil)]
                : goodsSurveyResults
        )
    }
}
