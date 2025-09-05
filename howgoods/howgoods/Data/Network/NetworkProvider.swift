//
//  NetworkProvider.swift
//  howgoods
//
//  Created by 양원식 on 9/5/25.
//

import Alamofire

enum NetworkProvider {
    static func makeSession(authRepository: AuthRepositoryProtocol,
                            onLogout: @escaping () -> Void) -> Session {
        let refreshUseCase = RefreshTokenUseCase(repository: authRepository)
        let interceptor = AuthInterceptor(refreshUseCase: refreshUseCase)
        interceptor.onLogout = onLogout
        return Session(interceptor: interceptor)
    }
}
