//
//  AppCoordinator.swift
//  howgoods
//
//  Created by 양원식 on 8/14/25.
//

import UIKit

final class AppCoordinator: Coordinator {
    let navigationController: UINavigationController
    var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
        self.navigationController = UINavigationController()
        self.navigationController.navigationBar.isHidden = true
    }

    func start() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.start()

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
