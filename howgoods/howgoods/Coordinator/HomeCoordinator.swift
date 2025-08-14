//
//  HomeCoordinator.swift
//  howgoods
//
//  Created by 양원식 on 8/14/25.
//

import UIKit

final class HomeCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeVC = HomeViewController()
        navigationController.pushViewController(homeVC, animated: true)
    }
}
