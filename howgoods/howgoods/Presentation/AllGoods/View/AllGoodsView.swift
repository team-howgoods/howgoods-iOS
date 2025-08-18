//
//  AllGoodsView.swift
//  howgoods
//
//  Created by 양원식 on 8/13/25.
//

import UIKit

final class AllGoodsView: UIView {
    // MARK: - Properties
    
    // MARK: - UI Components
    private let label: UILabel = {
        let label = UILabel()
        label.text = "전체 굿즈"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: - Public Methods
}

private extension AllGoodsView {
    // MARK: - configure
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
        setBindings()
    }
    
    // MARK: - setHierarchy
    func setHierarchy() {
        addSubviews(
            label
        )
    }
    
    // MARK: - setStyles
    func setStyles() {
        backgroundColor = .red
    }
    
    // MARK: - setConstraints
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - setBindings
    func setBindings() {
        
    }
}


