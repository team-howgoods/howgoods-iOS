//
//  TabBarViewController.swift
//  howgoods
//
//  Created by 양원식 on 8/14/25.
//

import UIKit
import Combine

final class TabBarController: UITabBarController {

    private let tapBarHight: CGFloat = 72
    
    private let customTabBarView = TabBarView()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let heightConstraint = customTabBarView.constraints.first(where: { $0.firstAttribute == .height }) {
            heightConstraint.constant = tapBarHight + view.safeAreaInsets.bottom
        }
    }

    private func setupCustomTabBar() {
        tabBar.isHidden = true // 기본 탭바 숨기기

        view.addSubview(customTabBarView)
        customTabBarView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            customTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customTabBarView.heightAnchor.constraint(equalToConstant: tapBarHight)
        ])
    }

    func bindActions(_ actions: TabBarActions) {
        customTabBarView.homeButtonPublisher
            .sink { actions.onHome() }
            .store(in: &cancellables)

        customTabBarView.allGoodsButtonPublisher
            .sink { actions.onAllGoods() }
            .store(in: &cancellables)

        customTabBarView.goodsMapButtonPublisher
            .sink { actions.onGoodsMap() }
            .store(in: &cancellables)

        customTabBarView.myPageButtonPublisher
            .sink { actions.onMyPage() }
            .store(in: &cancellables)
    }
}
