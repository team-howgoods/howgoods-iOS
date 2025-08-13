//
//  MyPageCoordinator.swift
//  howgoods
//
//  Created by 양원식 on 8/14/25.
//

import UIKit

final class MyPageCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let myPageVC = MyPageViewController()
        navigationController.pushViewController(myPageVC, animated: true)
    }
}
