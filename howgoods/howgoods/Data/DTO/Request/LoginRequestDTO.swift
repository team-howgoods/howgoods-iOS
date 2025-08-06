//
//  LoginRequestDTO.swift
//  howgoods
//
//  Created by 양원식 on 8/6/25.
//

/// 로그인 요청 시 서버에 전달할 데이터 객체입니다.
///
/// 예: 소셜 로그인 인증 코드를 백엔드로 전달할 때 사용됩니다.
///
/// ```json
/// {
///   "code": "authorization_code_here"
/// }
/// ```
struct LoginRequestDTO: Encodable {
    
    /// 클라이언트가 획득한 인증 코드
    ///
    /// - 예: Apple, Google, Kakao 로그인에서 받은 `authorizationCode` 또는 `idToken`
    let code: String
}
