//
//  AppleAuthService.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import Combine
import Alamofire
import Foundation

/// 인증 관련 네트워크 요청을 담당하는 서비스
///
/// - 역할:
///   - Apple, Naver, Kakao 로그인 요청을 서버에 전송
///   - 서버로부터 인증 토큰(`AuthToken`)을 수신하여 반환
///   - 네트워크 및 서버 응답 에러를 처리하고 `NetworkError` 형태로 매핑
final class AuthNetworkService: AuthNetworkServiceProtocol {
    
    // MARK: - Public Methods
    
    /// Apple 로그인 요청
    ///
    /// - Parameter code: Apple 로그인 후 발급받은 인증 코드
    /// - Returns:
    ///   - `AnyPublisher<Result<AuthToken, NetworkError>, Never>`:
    ///     - `.success(AuthToken)`: 인증 성공 시 서버에서 발급받은 토큰
    ///     - `.failure(NetworkError)`: 인증 실패 시 에러
    func loginWithApple(code: String) -> AnyPublisher<Result<AuthToken, NetworkError>, Never> {
        print("Apple 호출됨, code:", code)
        return sendRequest(router: AuthRouter.loginWithApple(code: code))
    }
    
    /// Naver 로그인 요청
    ///
    /// - Parameter code: Naver 로그인 후 발급받은 인증 코드
    /// - Returns:
    ///   - 동일한 반환 구조
    func loginWithNaver(code: String) -> AnyPublisher<Result<AuthToken, NetworkError>, Never> {
        print("Naver 호출됨, code:", code)
        return sendRequest(router: AuthRouter.loginWithNaver(code: code))
    }
    
    /// Kakao 로그인 요청
    ///
    /// - Parameter code: Kakao 로그인 후 발급받은 인증 코드
    /// - Returns:
    ///   - 동일한 반환 구조
    func loginWithKakao(code: String) -> AnyPublisher<Result<AuthToken, NetworkError>, Never> {
        print("Kakao 호출됨, code:", code)
        return sendRequest(router: AuthRouter.loginWithKakao(code: code))
    }
    
    // MARK: - Private Methods
    
    /// 공통 네트워크 요청 처리 메서드
    ///
    /// - Parameter router: API 요청 정보를 담은 `URLRequestConvertible`
    /// - Returns:
    ///   - `AnyPublisher<Result<AuthToken, NetworkError>, Never>`
    ///   - 요청 성공 시 토큰 반환, 실패 시 `NetworkError` 반환
    private func sendRequest(router: URLRequestConvertible) -> AnyPublisher<Result<AuthToken, NetworkError>, Never> {
        Future { promise in
            AF.request(router)
                .validate()
                .responseDecodable(of: AuthResponseDTO.self) { response in
                    
                    // 서버 응답 JSON 예쁘게 출력 (디버깅 용도)
                    if let data = response.data {
                        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
                           let prettyString = String(data: prettyData, encoding: .utf8) {
                            print("서버 응답 JSON:\n\(prettyString)")
                        }
                    }
                    
                    switch response.result {
                    case .success(let dto):
                        // 서버 응답 코드 검증
                        guard dto.code == 200 else {
                            promise(.success(.failure(.server(message: dto.message))))
                            return
                        }
                        // 토큰 데이터 존재 여부 확인
                        guard let tokenDTO = dto.data else {
                            promise(.success(.failure(.decoding)))
                            return
                        }
                        // DTO → Domain 변환 후 반환
                        promise(.success(.success(tokenDTO.toDomain())))
                        
                    case .failure(let afError):
                        // HTTP 상태 코드 기반 에러 처리
                        if let status = response.response?.statusCode {
                            switch status {
                            case 401: promise(.success(.failure(.unauthorized))); return
                            case 408: promise(.success(.failure(.timeout))); return
                            default: break
                            }
                        }
                        
                        // 서버에서 내려주는 에러 메시지 처리
                        if let data = response.data,
                           let err = try? JSONDecoder().decode(ErrorResponseDTO.self, from: data) {
                            promise(.success(.failure(.server(message: err.message))))
                        }
                        // 디코딩 실패 처리
                        else if case .responseSerializationFailed = afError.asAFError {
                            promise(.success(.failure(.decoding)))
                        }
                        // 알 수 없는 에러 처리
                        else {
                            promise(.success(.failure(.unknown)))
                        }
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
