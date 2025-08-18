//
//  TabbarController.swift
//  howgoods
//
//  Created by 양원식 on 8/13/25.
//

import UIKit
import Combine

final class TabBarView: UIView {
    // MARK: - Properties
    // 버튼과 레이블 간격
    private let spacing: CGFloat = 6
    
    // MARK: - UI Components
    
    private let tabBarstackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Private Buttons
    private lazy var homeButton: UIButton = makeButton(title: "홈", imageName: "Home")
    private lazy var allGoodsButton: UIButton = makeButton(title: "전체 굿즈", imageName: "plusButton")
    private lazy var goodsMapButton: UIButton = makeButton(title: "덕질 지도", imageName: "plusButton")
    private lazy var myPageButton: UIButton = makeButton(title: "마이페이지", imageName: "MyPage")
    
    // MARK: - Public Publishers
    var homeButtonPublisher: AnyPublisher<Void, Never> {
        homeButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    var allGoodsButtonPublisher: AnyPublisher<Void, Never> {
        allGoodsButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    var goodsMapButtonPublisher: AnyPublisher<Void, Never> {
        goodsMapButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    var myPageButtonPublisher: AnyPublisher<Void, Never> {
        myPageButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }

    
    // MARK: - Helpers
    private func makeButton(title: String, imageName: String) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: imageName)
        config.imagePlacement = .top
        config.imagePadding = spacing
        let attrs = Typography.attributes(for: .captionSemibold12, color: .textAssistive)
        config.attributedTitle = AttributedString(NSAttributedString(string: title, attributes: attrs))
        return UIButton(configuration: config)
    }
    
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
}
