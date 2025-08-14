//
//  TabBarCoordinator.swift
//  howgoods
//
//  Created by 양원식 on 8/14/25.
//

import UIKit
import Combine

final class TabBarCoordinator: Coordinator {
    let navigationController: UINavigationController
    private var homeCoordinator: HomeCoordinator!
    private var allGoodsCoordinator: AllGoodsCoordinator!
    private var goodsMapCoordinator: GoodsMapCoordinator!
    private var myPageCoordinator: MyPageCoordinator!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let tabBarVC = TabBarController()

        // 각 탭 Coordinator 생성
        homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
        allGoodsCoordinator = AllGoodsCoordinator(navigationController: UINavigationController())
        goodsMapCoordinator = GoodsMapCoordinator(navigationController: UINavigationController())
        myPageCoordinator = MyPageCoordinator(navigationController: UINavigationController())

        homeCoordinator.start()
        allGoodsCoordinator.start()
        goodsMapCoordinator.start()
        myPageCoordinator.start()

        tabBarVC.viewControllers = [
            homeCoordinator.navigationController,
            allGoodsCoordinator.navigationController,
            goodsMapCoordinator.navigationController,
            myPageCoordinator.navigationController
        ]

        tabBarVC.bindActions(TabBarActions(
            onHome: { tabBarVC.selectedIndex = 0 },
            onAllGoods: { tabBarVC.selectedIndex = 1 },
            onGoodsMap: { tabBarVC.selectedIndex = 2 },
            onMyPage: { tabBarVC.selectedIndex = 3 }
        ))

        navigationController.setViewControllers([tabBarVC], animated: false)
    }

    func navigate(to destination: TabDestination) {
        guard let tabBarVC = navigationController.viewControllers.first as? UITabBarController else { return }

        let index: Int
        switch destination {
        case .home: index = 0
        case .allGoods: index = 1
        case .goodsMap: index = 2
        case .myPage: index = 3
        }

        tabBarVC.selectedIndex = index
        if let nav = tabBarVC.viewControllers?[index] as? UINavigationController {
            nav.popToRootViewController(animated: false)
        }
    }
}
