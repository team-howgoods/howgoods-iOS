//
//  AllGoodsCoordinator.swift
//  howgoods
//
//  Created by 양원식 on 8/14/25.
//

import UIKit

final class AllGoodsCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let allGoodsVC = AllGoodsViewController()
        navigationController.pushViewController(allGoodsVC, animated: true)
    }
}
