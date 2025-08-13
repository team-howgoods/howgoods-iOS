//
//  AuthResponseDTO.swift
//  howgoods
//
//  Created by 양원식 on 8/6/25.
//

/// 인증 요청에 대한 서버 응답을 나타내는 데이터 전송 객체(DTO)
///
/// - 사용 목적:
///   - 로그인, 회원가입, 토큰 갱신 등 인증 관련 API 호출의 응답을 매핑
///   - 성공 여부, 상태 코드, 메시지, 유효성 검사 오류, 토큰 데이터를 포함
///
/// - JSON 예시:
/// ```json
/// {
///   "success": true,
///   "code": 200,
///   "message": "로그인 성공",
///   "validationErrors": null,
///   "data": {
///     "memberEmail": "user@example.com",
///     "accessToken": "your_access_token_here",
///     "refreshToken": "your_refresh_token_here"
///   }
/// }
/// ```
struct AuthResponseDTO: Decodable {
    
    /// 요청 처리 성공 여부
    /// - `true`: 요청 성공
    /// - `false`: 요청 실패 (에러 코드와 메시지 참고)
    let success: Bool?
    
    /// HTTP 상태 코드 또는 서버 정의 응답 코드
    /// - 예: 200(성공), 400(잘못된 요청), 401(인증 실패), 422(유효성 검증 실패)
    let code: Int
    
    /// 응답 메시지
    /// - 예: `"로그인 성공"`, `"토큰이 유효하지 않습니다"`
    let message: String
    
    /// 유효성 검사 실패 시 서버에서 내려주는 상세 오류 메시지
    /// - Key: 필드명
    /// - Value: 해당 필드에 대한 오류 메시지 배열
    let validationErrors: [String: [String]]?
    
    /// 인증 관련 데이터
    /// - 예: Access Token, Refresh Token 등 (`AuthTokenDTO`)
    let data: AuthTokenDTO?
}
