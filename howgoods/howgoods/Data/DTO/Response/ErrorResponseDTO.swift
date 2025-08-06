//
//  ErrorResponseDTO.swift
//  howgoods
//
//  Created by 양원식 on 8/6/25.
//

/// 서버로부터의 에러 응답을 표현하는 DTO입니다.
///
/// 주로 인증 실패, 유효성 검증 실패 등의 상황에서 사용됩니다.
/// `validationErrors` 필드를 통해 폼 필드별 구체적인 오류 메시지를 확인할 수 있습니다.
///
/// ```json
/// {
///   "success": false,
///   "code": 422,
///   "message": "입력값이 올바르지 않습니다.",
///   "validationErrors": {
///     "email": "이메일 형식이 올바르지 않습니다.",
///     "password": "비밀번호는 최소 8자 이상이어야 합니다."
///   }
/// }
/// ```
struct ErrorResponseDTO: Decodable {
    
    /// 요청 처리 성공 여부 (`false`일 경우 에러 응답)
    let success: Bool
    
    /// 서버에서 정의한 에러 코드 (예: 400, 401, 422 등)
    let code: Int
    
    /// 에러 메시지 (일반적인 설명)
    let message: String
    
    /// 폼 필드별 유효성 검증 오류 메시지
    ///
    /// - Key: 필드명 (예: "email", "password")
    /// - Value: 해당 필드의 오류 메시지
    let validationErrors: [String: String]?
}
