//
//  NetworkError.swift
//  howgoods
//
//  Created by 양원식 on 8/6/25.
//

/// 네트워크 요청 중 발생할 수 있는 오류를 정의한 열거형
enum NetworkError: Error {
    
    /// 서버에서 반환한 커스텀 에러 메시지를 포함한 오류
    /// - Parameter message: 서버에서 제공하는 에러 메시지
    case server(message: String)
    
    /// 응답 데이터를 디코딩하는 데 실패한 경우
    case decoding
    
    /// 인증되지 않은 요청 (예: 토큰 만료 등)
    case unauthorized
    
    /// 요청 시간이 초과된 경우
    case timeout
    
    /// 알 수 없는 에러
    case unknown
}
