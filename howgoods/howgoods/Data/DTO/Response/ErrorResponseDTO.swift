//
//  ErrorResponseDTO.swift
//  howgoods
//
//  Created by 양원식 on 8/13/25.
//

/// 서버로부터의 에러 응답을 표현하는 데이터 전송 객체(DTO)
///
/// - 사용 목적:
///   - 인증 실패, 유효성 검증 실패 등 서버 처리 오류를 클라이언트에 전달
///   - `validationErrors` 필드를 통해 폼 필드별 상세 오류 메시지 확인 가능
///
/// - JSON 예시:
/// ```json
/// {
///   "success": false,
///   "code": 422,
///   "message": "입력값이 올바르지 않습니다.",
///   "validationErrors": {
///     "email": ["이메일 형식이 올바르지 않습니다."],
///     "password": ["비밀번호는 최소 8자 이상이어야 합니다."]
///   }
/// }
/// ```
struct ErrorResponseDTO: Decodable {
    
    /// 요청 처리 성공 여부
    /// - `false`인 경우 에러 응답을 의미
    let success: Bool?
    
    /// 서버에서 정의한 에러 코드
    /// - 예: 400 (잘못된 요청), 401 (인증 실패), 422 (유효성 검증 실패)
    let code: Int
    
    /// 에러 메시지 (일반적인 오류 설명)
    let message: String
    
    /// 폼 필드별 유효성 검증 오류 메시지
    /// - Key: 필드명 (예: `"email"`, `"password"`)
    /// - Value: 해당 필드의 오류 메시지 배열
    let validationErrors: [String: [String]]?
}
