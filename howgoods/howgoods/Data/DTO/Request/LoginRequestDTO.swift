//
//  LoginRequestDTO.swift
//  howgoods
//
//  Created by 양원식 on 8/6/25.
//

/// 로그인 요청 시 서버에 전달할 데이터 전송 객체(DTO)
///
/// - 사용 목적:
///   - 소셜 로그인(Apple, Naver, Kakao 등) 인증 과정에서 발급받은 인증 코드를 서버로 전송
///   - 서버는 이 코드를 사용하여 해당 소셜 플랫폼에서 사용자 정보 및 액세스 토큰을 획득
///
/// - JSON 예시:
/// ```json
/// {
///   "code": "authorization_code_here"
/// }
/// ```
struct LoginRequestDTO: Encodable {
    
    /// 클라이언트가 소셜 로그인 과정에서 획득한 인증 코드
    ///
    /// - 예:
    ///   - Apple: `authorizationCode`
    ///   - Naver/Kakao: OAuth2 Access Token
    let code: String
}
