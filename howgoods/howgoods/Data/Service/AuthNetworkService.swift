//
//  AppleAuthService.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import AuthenticationServices
import RxSwift
import Alamofire

/// 인증 관련 네트워크 요청을 처리하는 서비스 클래스입니다.
///
/// `AuthRouter`를 기반으로 소셜 로그인 인증 코드를 서버에 전송하고,
/// 서버로부터 access token을 포함한 `AuthToken`을 수신합니다.
///
/// `RxSwift`의 `Observable`을 통해 비동기 처리를 제공합니다.
final class AuthNetworkService: AuthNetworkServiceProtocol {

    /// Apple 로그인 인증 코드를 서버에 전송합니다.
    ///
    /// - Parameter code: Apple 로그인 후 발급받은 authorization code
    /// - Returns: 인증 성공 시 `AuthToken`, 실패 시 `Error`를 포함한 `Result`
    func loginWithApple(code: String) -> Observable<Result<AuthToken, Error>> {
        return sendRequest(router: AuthRouter.loginWithApple(code: code))
    }

    /// Naver 로그인 인증 코드를 서버에 전송합니다.
    func loginWithNaver(code: String) -> Observable<Result<AuthToken, Error>> {
        return sendRequest(router: AuthRouter.loginWithNaver(code: code))
    }

    /// Kakao 로그인 인증 코드를 서버에 전송합니다.
    func loginWithKakao(code: String) -> Observable<Result<AuthToken, Error>> {
        return sendRequest(router: AuthRouter.loginWithKakao(code: code))
    }

    // MARK: - Private

    /// 공통 인증 요청 처리 함수
    ///
    /// - Parameter router: 요청 정보를 담고 있는 `AuthRouter`
    /// - Returns: 서버 응답을 도메인 모델로 변환한 `Observable<Result<AuthToken, Error>>`
    private func sendRequest(router: URLRequestConvertible) -> Observable<Result<AuthToken, Error>> {
        return Observable.create { observer in
            AF.request(router)
                .validate()
                .responseDecodable(of: AuthResponseDTO.self) { response in

                    // 서버 응답 JSON 출력 (디버깅용)
                    if let data = response.data {
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
                            if let prettyString = String(data: prettyData, encoding: .utf8) {
                                print("서버 응답 JSON:\n\(prettyString)")
                            }
                        } catch {
                            print("JSON 포맷팅 실패: \(error.localizedDescription)")
                            if let rawString = String(data: data, encoding: .utf8) {
                                print("원본 JSON:\n\(rawString)")
                            }
                        }
                    } else {
                        print("서버 응답 데이터 없음")
                    }

                    // 응답 처리
                    switch response.result {
                    case .success(let authResponseDTO):
                        // 성공 시 도메인 모델로 변환
                        let domainModel = authResponseDTO.data.toDomain()
                        observer.onNext(.success(domainModel))

                    case .failure(let error):
                        // 상태 코드 기반 에러 처리
                        if let responseCode = response.response?.statusCode {
                            switch responseCode {
                            case 401:
                                observer.onNext(.failure(NetworkError.unauthorized))
                                observer.onCompleted()
                                return

                            case 408:
                                observer.onNext(.failure(NetworkError.timeout))
                                observer.onCompleted()
                                return

                            default:
                                break
                            }
                        }

                        // 서버에서 내려준 에러 메시지 디코딩
                        if let data = response.data,
                           let errorDTO = try? JSONDecoder().decode(ErrorResponseDTO.self, from: data) {
                            observer.onNext(.failure(NetworkError.server(message: errorDTO.message)))
                        } else {
                            observer.onNext(.failure(NetworkError.unknown))
                        }

                        observer.onCompleted()
                    }
                }

            return Disposables.create()
        }
    }
}
