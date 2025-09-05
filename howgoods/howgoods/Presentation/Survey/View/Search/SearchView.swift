//
//  SearchView.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//

import UIKit

final class SearchView: UIView {
    // MARK: - Properties
    
    // MARK: - UI Components
    private let navigationBar: CustomNavigationBar = {
        let v = CustomNavigationBar()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let headTitle: UILabel = {
        let label = UILabel()
        label.setText("최근 관심 있는 굿즈가 있다면 골라주세요!\n최저가일 때 알려드릴게요",
                      style: .headlineSemibold,
                      color: .textDefault)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchBar: SearchBar = {
        let bar = SearchBar(placeholder: "굿즈 이름을 입력해 주세요", isActive: true)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
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
    var getNavigationBar: CustomNavigationBar {
        navigationBar
    }
}

private extension SearchView {
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
            navigationBar,
            headTitle,
            searchBar
        )
    }
    
    // MARK: - setStyles
    func setStyles() {
        backgroundColor = .white
    }
    
    // MARK: - setConstraints
    func setConstraints() {
        NSLayoutConstraint.activate([
        navigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
        navigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
        navigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),
        
        headTitle.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 14),
        headTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        
        searchBar.topAnchor.constraint(equalTo: headTitle.bottomAnchor, constant: 16),
        searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - setBindings
    func setBindings() {
        
    }
}


