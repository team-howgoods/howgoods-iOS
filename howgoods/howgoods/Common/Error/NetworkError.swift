//
//  NetworkError.swift
//  howgoods
//
//  Created by 양원식 on 8/6/25.
//

/// 네트워크 요청 처리 중 발생할 수 있는 오류 유형
///
/// - 사용 목적:
///   - 네트워크 계층에서 발생하는 다양한 오류 상황을 하나의 타입으로 관리
///   - 서버 응답 코드 및 클라이언트 측 네트워크 상태를 기반으로 구분
enum NetworkError: Error {
    
    /// 서버에서 반환한 커스텀 에러 메시지를 포함한 오류
    /// - Parameter message: 서버에서 제공하는 에러 메시지
    case server(message: String)
    
    /// 응답 데이터를 디코딩하는 데 실패한 경우
    /// - 예: 서버 응답 JSON 구조가 예상과 다르거나 데이터 타입이 불일치
    case decoding
    
    /// 인증되지 않은 요청
    /// - 예: 액세스 토큰 만료, 유효하지 않은 자격 증명
    case unauthorized
    
    /// 요청 시간이 초과된 경우
    /// - 예: 네트워크 불안정, 서버 지연
    case timeout
    
    /// 알 수 없는 에러
    /// - 예: 위 케이스로 분류할 수 없는 모든 기타 오류
    case unknown
}

