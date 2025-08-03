//
//  ViewController.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    //private let viewModel: <#ViewModel#>
    
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

private extension LoginViewController {
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
        setActions()
        setBinding()
    }
    // ...
    
    // MARK: - setBinding
    func setHierarchy() { }
    func setStyles() { }
    func setConstraints() { }
    func setActions() { }
    func setBinding() { }
    
}

