//
//  CustomNavigationBar.swift
//  howgoods
//
//  Created by 양원식 on 8/22/25.
//

import UIKit
import Combine

final class CustomNavigationBar: UIView {
    
    // MARK: - UI
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Public Publisher
    var backButtonPublisher: AnyPublisher<Void, Never> {
        backButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
private extension CustomNavigationBar {
    func configure() {
        backgroundColor = .white
        
        addSubview(backButton)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 46),  // 고정 높이
            
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
