//
//  SubmitSurveyResponseDTO.swift
//  howgoods
//
//  Created by 양원식 on 8/22/25.
//

struct SubmitSurveyResponseDTO: Decodable {
    let code: Int
    let message: String
    let validationErrors: String?
    let data: String?
}
