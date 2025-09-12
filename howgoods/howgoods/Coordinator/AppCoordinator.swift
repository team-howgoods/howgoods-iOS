//
//  AppCoordinator.swift
//  howgoods
//
//  Created by 양원식 on 8/14/25.
//

import UIKit
import Combine
import Alamofire

final class AppCoordinator: Coordinator {
    let navigationController: UINavigationController
    var window: UIWindow?
    
    private var cancellables = Set<AnyCancellable>()
    private let session: Session
    
    private var surveyCoordinator: SurveyCoordinator?
    private var tabBarCoordinator: TabBarCoordinator?
    
    init(window: UIWindow?) {
        self.window = window
        self.navigationController = UINavigationController()
        self.navigationController.navigationBar.isHidden = true
        
        let authRepository = AuthRepository(
            appleAuthService: AppleAuthService(authNetworkService: AuthNetworkService()),
            naverAuthService: NaverAuthService(authNetworkService: AuthNetworkService()),
            kakaoAuthService: KakaoAuthService(authNetworkService: AuthNetworkService()),
            authNetworkService: AuthNetworkService()
        )
        
        self.session = NetworkProvider.makeSession(
            authRepository: authRepository,
            onLogout: { [weak window] in
                // RefreshToken 만료 → 로그인 화면 전환
                if let window = window {
                    let coordinator = AppCoordinator(window: window)
                    coordinator.start()
                }
            }
        )
    }
    
    func start() {
        // 항상 로그인 안 된 상태처럼 시작
        // TODO: 로그인 상태 확인하려면 바로 밑에 줄 코드 지워주세요 !
        TokenStorage.clear() // 토큰 제거
        
        UserDefaultsHelper.hasSeenSurvey = false
        startMainTabs()

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func startSurvey() {
        let viewModel = SurveyViewModel(
            surveyUseCase: SurveyUseCase(repository: SurveyRepository(session: session)))
        let surveyCoordinator = SurveyCoordinator(
            navigationController: navigationController,
            viewModel: viewModel
        )
        surveyCoordinator.onFinish = { [weak self] in
            UserDefaultsHelper.hasSeenSurvey = true
            self?.startMainTabs()
        }
        surveyCoordinator.start()
        self.surveyCoordinator = surveyCoordinator
    }
    
    private func showLogin() {
        let loginVC = AuthFactory.makeLoginViewController()
        
        loginVC.onLoginSuccess = { [weak self] in
            guard let self = self else { return }
            if UserDefaultsHelper.hasSeenSurvey {
                self.startMainTabs()
            } else {
                self.startSurvey()
            }
        }
        
        loginVC.onLoginFailure = { error in
            print("로그인 실패: \(error.localizedDescription)")
        }
        
        navigationController.setViewControllers([loginVC], animated: false)
    }
    
    private func startMainTabs() {
        let tab = TabBarCoordinator(navigationController: navigationController)
        tab.start()
        tab.navigate(to: .home)
        self.tabBarCoordinator = tab
        self.surveyCoordinator = nil
    }
}
