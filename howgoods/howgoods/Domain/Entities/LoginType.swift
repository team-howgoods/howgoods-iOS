//
//  LoginType.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

/// 로그인 방식을 구분하는 열거형입니다.
///
/// Apple, Naver, Kakao 중 어떤 로그인 방식이 선택되었는지를 나타냅니다.
/// 인증 요청 시 로그인 흐름을 분기 처리하는 데 사용됩니다.
enum LoginType {
    
    /// Apple 로그인
    case apple
    
    /// Naver 로그인
    case naver
    
    /// Kakao 로그인
    case kakao
}
