//
//  RefreshTokenUseCase.swift
//  howgoods
//
//  Created by 양원식 on 9/5/25.
//

import Combine

final class RefreshTokenUseCase: RefreshTokenUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<Result<AuthToken, Error>, Never> {
        guard let refreshToken = TokenStorage.loadToken()?.refreshToken else {
            return Just(.failure(NetworkError.unauthorized))
                .eraseToAnyPublisher()
        }
        return repository.refreshToken(refreshToken)
    }
}
