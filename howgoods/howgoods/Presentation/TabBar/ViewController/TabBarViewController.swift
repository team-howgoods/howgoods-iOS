//
//  TabBarViewController.swift
//  howgoods
//
//  Created by 양원식 on 8/14/25.
//

import UIKit

final class TabBarViewController: UIViewController {
    
    // MARK: - Properties
    private let tabBarView = TabBarView()
    
    // private let viewModel: <#ViewModel#>
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Initializer
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "compile error")
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc
    func didTapSomeButton(_ sender: UIButton) {
        
    }
}

// MARK: - UI Methods

private extension TabBarViewController {
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
        setActions()
        setBinding()
    }
    
    // MARK: - setBinding
    func setHierarchy() {
        view.addSubview(
            tabBarView
        )
    }
    func setStyles() { }
    func setConstraints() {
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

    }
    func setActions() { }
    func setBinding() { }
    
}
