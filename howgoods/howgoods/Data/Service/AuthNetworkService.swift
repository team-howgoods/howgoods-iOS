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
        return Observable.create { observer in
            let router = AuthRouter.loginWithApple(code: code)

            AF.request(router)
                .validate()
                .responseDecodable(of: AuthToken.self) { response in
                    switch response.result {
                    case .success(let token):
                        observer.onNext(.success(token))
                    case .failure(let error):
                        observer.onNext(.failure(error))
                    }
                    observer.onCompleted()
                }

            return Disposables.create()
        }
    }
    
    // TODO: loginWithNaver
    
    // TODO: loginWithKakao
}
