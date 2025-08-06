//
//  AppleAuthService.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import AuthenticationServices
import RxSwift
import Alamofire

final class AuthNetworkService: AuthNetworkServiceProtocol {
    
    func loginWithApple(code: String) -> Observable<Result<AuthToken, Error>> {
        return sendRequest(router: AuthRouter.loginWithApple(code: code))
    }
    
    func loginWithNaver(code: String) -> Observable<Result<AuthToken, Error>> {
        return sendRequest(router: AuthRouter.loginWithNaver(code: code))
    }
    
    func loginWithKakao(code: String) -> Observable<Result<AuthToken, Error>> {
        return sendRequest(router: AuthRouter.loginWithKakao(code: code))
    }
    
    // MARK: - Private 공통 요청 처리
    private func sendRequest(router: URLRequestConvertible) -> Observable<Result<AuthToken, Error>> {
        return Observable.create { observer in
            AF.request(router)
                .validate()
                .responseDecodable(of: AuthResponseDTO.self) { response in
                    
                    ///  Server Response 확인
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
                    
                    switch response.result {
                    case .success(let authResponseDTO):
                        let domainModel = authResponseDTO.data.toDomain()
                        observer.onNext(.success(domainModel))
                        
                    case .failure(let error):
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
