//
//  GoodsSectionHeader.swift
//  howgoods
//
//  Created by 양원식 on 9/5/25.
//

import UIKit
import Combine

final class GoodsSectionHeader: UICollectionReusableView {
    static let identifier = "GoodsSectionHeader"
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setText("", style: .headlineMedium, color: .textDefault)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(title: String) {
        titleLabel.setText(title, style: .headlineMedium, color: .textDefault)
    }
}

// MARK: - Private Methods
private extension GoodsSectionHeader {
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
    }
    
    func setHierarchy() {
        addSubviews(
            titleLabel
        )
    }
    
    func setStyles() {
        backgroundColor = .white
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
