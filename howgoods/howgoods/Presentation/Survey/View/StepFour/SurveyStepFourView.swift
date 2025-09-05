//
//  SurveyStepFourView.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//

import UIKit
import Combine

final class SurveyStepFourView: UIView {
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
        let bar = SearchBar(placeholder: "굿즈 이름을 입력해 주세요", isActive: false)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 12

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(GoodsCell.self, forCellWithReuseIdentifier: GoodsCell.identifier)
        
        cv.allowsMultipleSelection = true
        
        cv.backgroundColor = .white
        return cv
    }()
    
    private let twoButton: TwoButtonBar = {
        let button = TwoButtonBar()
        button.translatesAutoresizingMaskIntoConstraints = false
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
    var searchBarTapPublisher: AnyPublisher<Void, Never> {
        searchBar.didTapSearchBar
    }
    
    var getNavigationBar: CustomNavigationBar {
        navigationBar
    }
    
    var getCollectionView: UICollectionView {
        collectionView
    }
}

private extension SurveyStepFourView {
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
            searchBar,
            collectionView,
            twoButton
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
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: twoButton.topAnchor),
            
            twoButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            twoButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            twoButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -11)
        ])
    }
    
    // MARK: - setBindings
    func setBindings() {
        
    }
}


