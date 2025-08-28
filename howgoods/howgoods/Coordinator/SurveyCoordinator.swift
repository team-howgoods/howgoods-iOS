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
    
    init(navigationController: UINavigationController, viewModel: SurveyViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let surveyVC = SurveyViewController(viewModel: viewModel)
        
        surveyVC.didTapStart = { [weak self] in
            self?.showStepOne()
        }
        
        navigationController.pushViewController(surveyVC, animated: true)
    }
    
    private func showStepOne() {
        let stepOneVC = SurveyStepOneViewController(viewModel: viewModel)

        stepOneVC.didTapNext = { [weak self] in
            self?.showStepTwo()
        }
        
        navigationController.pushViewController(stepOneVC, animated: true)
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
        navigationController.pushViewController(stepThreeVC, animated: true)
    }
}
