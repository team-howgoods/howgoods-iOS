//
//  GoodsMapView.swift
//  howgoods
//
//  Created by 양원식 on 8/13/25.
//

import UIKit

final class GoodsMapView: UIView {
    // MARK: - Properties
    
    // MARK: - UI Components
    private let label: UILabel = {
        let label = UILabel()
        label.text = "굿즈 지도"
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

private extension GoodsMapView {
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
        backgroundColor = .yellow
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


