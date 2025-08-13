//
//  GoodsMapCoordinator.swift
//  howgoods
//
//  Created by 양원식 on 8/14/25.
//

import UIKit

final class GoodsMapCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let goodsMapVC = GoodsMapViewController()
        navigationController.pushViewController(goodsMapVC, animated: true)
    }
}
