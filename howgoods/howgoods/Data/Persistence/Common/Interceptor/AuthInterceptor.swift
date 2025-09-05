//
//  AuthInterceptor.swift
//  howgoods
//
//  Created by 양원식 on 9/5/25.
//

import Alamofire
import Combine
import Foundation

final class AuthInterceptor: RequestInterceptor, @unchecked Sendable {
    private let refreshUseCase: RefreshTokenUseCaseProtocol
    private var isRefreshing = false
    private var completions: [(RetryResult) -> Void] = []
    private var cancellables = Set<AnyCancellable>()
    
    var onLogout: (() -> Void)?
    
    init(refreshUseCase: RefreshTokenUseCaseProtocol) {
        self.refreshUseCase = refreshUseCase
    }
    
    // 요청 보낼 때 AccessToken 헤더 자동 추가
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        if let token = TokenStorage.loadToken()?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }
    
    // 401 Unauthorized 시 재시도 처리
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        completions.append(completion)
        
        if !isRefreshing {
            isRefreshing = true
            refreshUseCase.execute()
                .sink { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        print("AccessToken 갱신 성공 → 요청 재시도")
                        self.completions.forEach { $0(.retry) }
                    case .failure:
                        print(" RefreshToken 만료 → 로그아웃 처리 필요")
                        TokenStorage.clear()
                        self.completions.forEach { $0(.doNotRetry) }
                        // TODO: 로그인 화면으로 전환 처리
                        self.onLogout?()
                    }
                    self.completions.removeAll()
                    self.isRefreshing = false
                }
                .store(in: &cancellables)
        }
    }
}
