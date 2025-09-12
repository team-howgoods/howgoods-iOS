//
//  SurveyCoordinator.swift
//  howgoods
//
//  Created by 양원식 on 8/22/25.
//

import UIKit

final class SurveyCoordinator: Coordinator {
    let navigationController: UINavigationController
    private let viewModel: SurveyViewModel
    
    var onFinish: (() -> Void)?
    
    init(navigationController: UINavigationController, viewModel: SurveyViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let stepOneVC = SurveyStepOneViewController(viewModel: viewModel)

        stepOneVC.didTapNext = { [weak self] in
            self?.showStepTwo()
        }
        
        stepOneVC.didTapSkip = { [weak self] in
            self?.showNoPreference()
        }
        
        stepOneVC.didTapHome = { [weak self] in
            self?.onFinish?()
        }
        
        navigationController.pushViewController(stepOneVC, animated: true)
        
        // TODO: 안쓸 것 같음 일딴 보류
//        let surveyVC = SurveyViewController(viewModel: viewModel)
//        
//        surveyVC.didTapStart = { [weak self] in
//            self?.showStepOne()
//        }
//        
//        navigationController.pushViewController(surveyVC, animated: true)
    }
    
    private func showStepTwo() {
        let stepTwoVC = SurveyStepTwoViewController(viewModel: viewModel)
        
        stepTwoVC.didTapNext = { [weak self] in
            self?.showStepThree()
        }
        
        navigationController.pushViewController(stepTwoVC, animated: true)
    }
    
    private func showStepThree() {
        let stepThreeVC = SurveyStepThreeViewController(viewModel: viewModel)
        
        stepThreeVC.didTapNext = { [weak self] in
            self?.showStepFour()
        }
        
        navigationController.pushViewController(stepThreeVC, animated: true)
    }
    
    private func showStepFour() {
        let stepFourVC = SurveyStepFourViewController(viewModel: viewModel)
        
        stepFourVC.didTapSearch = { [weak self] in
            self?.showSearchView()
        }
        
        stepFourVC.didTapHome = { [weak self] in
            self?.onFinish?()
        }
        
        navigationController.pushViewController(stepFourVC, animated: true)
    }
    
    private func showSearchView() {
        let searchVC = SearchViewController(viewModel: viewModel)
        navigationController.pushViewController(searchVC, animated: true)
    }
    
    private func showNoPreference() {
        let noPreferenceVC = SurveyNoPreferenceViewController(viewModel: viewModel)
        
        noPreferenceVC.didTapHome = { [weak self] in
            self?.onFinish?()
        }
        
        navigationController.pushViewController(noPreferenceVC, animated: true)
    }
}
