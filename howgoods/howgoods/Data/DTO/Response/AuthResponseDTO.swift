//
//  AuthResponseDTO.swift
//  howgoods
//
//  Created by 양원식 on 8/6/25.
//

/// 인증 요청에 대한 서버 응답을 나타내는 DTO입니다.
///
/// 일반적인 API 응답 구조를 따르며, 인증 성공 여부, 응답 코드, 메시지, 에러 및 토큰 데이터를 포함합니다.
///
/// ```json
/// {
///   "success": true,
///   "code": 200,
///   "message": "로그인 성공",
///   "validationErrors": null,
///   "data": {
///     "token": "your_access_token_here"
///   }
/// }
/// ```
struct AuthResponseDTO: Decodable {
    
    /// 요청 처리 성공 여부
    let success: Bool
    
    /// HTTP 상태 코드 또는 서버 정의 응답 코드
    let code: Int
    
    /// 응답 메시지 (예: "로그인 성공", "토큰이 유효하지 않습니다" 등)
    let message: String
    
    /// 유효성 검사 실패 시 서버에서 내려주는 상세 오류 메시지 (선택적)
    let validationErrors: String?
    
    /// 인증 관련 실제 데이터 (ex. access token 등)
    let data: AuthTokenDTO
}
