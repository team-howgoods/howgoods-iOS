//
//  RefreshTokenUseCaseProtocol.swift
//  howgoods
//
//  Created by 양원식 on 9/5/25.
//

import Combine

protocol RefreshTokenUseCaseProtocol {
    func execute() -> AnyPublisher<Result<AuthToken, Error>, Never>
}
