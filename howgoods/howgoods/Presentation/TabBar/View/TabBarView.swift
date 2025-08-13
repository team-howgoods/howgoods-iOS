//
//  TabbarController.swift
//  howgoods
//
//  Created by 양원식 on 8/13/25.
//

import UIKit

final class TabBarView: UIView {
    // MARK: - Properties
    // 버튼과 레이블 간격
    private let spacing: CGFloat = 6
    private let tapBarHight: CGFloat = 72
    
    // MARK: - UI Components
    
    private let tabBarstackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - 홈 스택
    private lazy var homeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Home")
        config.imagePlacement = .top
        config.imagePadding = spacing

        let attrs = Typography.attributes(for: .caption2, color: .textAssistive)
        let nsAttrString = NSAttributedString(string: "홈", attributes: attrs)
        config.attributedTitle = AttributedString(nsAttrString)

        let button = UIButton(configuration: config)
        return button
    }()
    
    // MARK: - 전체 굿즈 스택
    private lazy var allGoodsButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "plusButton")
        config.imagePlacement = .top
        config.imagePadding = spacing

        let attrs = Typography.attributes(for: .caption2, color: .textAssistive)
        let nsAttrString = NSAttributedString(string: "전체 굿즈", attributes: attrs)
        config.attributedTitle = AttributedString(nsAttrString)

        let button = UIButton(configuration: config)
        return button
    }()
    
    // MARK: - 덕질 지도 스택
    private lazy var goodsMapButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "plusButton")
        config.imagePlacement = .top
        config.imagePadding = spacing

        let attrs = Typography.attributes(for: .caption2, color: .textAssistive)
        let nsAttrString = NSAttributedString(string: "덕질 지도", attributes: attrs)
        config.attributedTitle = AttributedString(nsAttrString)

        let button = UIButton(configuration: config)
        return button
    }()
    
    // MARK: - 마이페이지 스택
    private lazy var myPageButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "MyPage")
        config.imagePlacement = .top
        config.imagePadding = spacing

        let attrs = Typography.attributes(for: .caption2, color: .textAssistive)
        let nsAttrString = NSAttributedString(string: "마이페이지", attributes: attrs)
        config.attributedTitle = AttributedString(nsAttrString)

        let button = UIButton(configuration: config)
        return button
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

private extension TabBarView {
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
            tabBarstackView
        )
        
        tabBarstackView.addArrangedSubviews(
            homeButton,
            allGoodsButton,
            goodsMapButton,
            myPageButton
        )
        
    }
    
    // MARK: - setStyles
    func setStyles() {
        backgroundColor = .white
    }
    
    // MARK: - setConstraints
    func setConstraints() {
        tabBarstackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabBarstackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabBarstackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabBarstackView.topAnchor.constraint(equalTo: topAnchor),
            tabBarstackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - setBindings
    func setBindings() {
        
    }
}
