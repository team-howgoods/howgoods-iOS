//
//  AllGoodsViewController.swift
//  howgoods
//
//  Created by 양원식 on 8/13/25.
//

import UIKit

final class AllGoodsViewController: UIViewController {
    
    // MARK: - Properties
    private let allGoodsView = AllGoodsView()
    
    // private let viewModel: <#ViewModel#>
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = allGoodsView
    }
    
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
    
}

// MARK: - UI Methods

private extension AllGoodsViewController {
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
        setActions()
        setBinding()
    }
    
    // MARK: - setBinding
    func setHierarchy() { }
    func setStyles() { }
    func setConstraints() { }
    func setActions() { }
    func setBinding() { }
    
}

