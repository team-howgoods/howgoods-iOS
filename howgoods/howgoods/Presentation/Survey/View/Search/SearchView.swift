//
//  SearchView.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//

import UIKit
import Combine

final class SearchView: UIView {
    // MARK: - Properties
    
    // MARK: - UI Components
    private let navigationBar: CustomNavigationBar = {
        let v = CustomNavigationBar()
        v.backgroundColor = .bgAlternative
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // TODO: 임시
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.setText("검색 결과가 없습니다",
                      style: .body1Semibold,
                      color: .gray600)
        label.textAlignment = .center
        label.isHidden = true // 기본은 숨김
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(GoodsCell.self, forCellWithReuseIdentifier: GoodsCell.identifier)
        cv.allowsMultipleSelection = true
        cv.backgroundColor = .white
        return cv
    }()
    
    private let confirmButton: OneButton = {
        let button = OneButton(frame: .zero, title: "완료", color: .primary, disabledColor: .bgDelete)
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
    var getNavigationBar: CustomNavigationBar {
        navigationBar
    }
    var getConfirmButton: OneButton { confirmButton }
    var getCollectionView: UICollectionView { collectionView }
    var getSearchBar: SearchBar { searchBar }
    var getEmptyLabel: UILabel { emptyLabel }
    
    var confirmButtonPublisher: AnyPublisher<Void, Never> {
        confirmButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let interItemSpacing: CGFloat = 8
        let itemsPerRow: CGFloat = 2
        let itemHeightExtra: CGFloat = 48
        
        return UICollectionViewCompositionalLayout { _, environment in
            let availableWidth = environment.container.effectiveContentSize.width
            - (itemsPerRow - 1) * interItemSpacing
            let itemWidth = availableWidth / itemsPerRow
            let itemHeight = itemWidth + itemHeightExtra
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(itemWidth),
                heightDimension: .absolute(itemHeight)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(itemHeight)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
            group.interItemSpacing = .fixed(interItemSpacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 12
            return section
        }
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
            searchBar,
            collectionView,
            emptyLabel,
            confirmButton
        )
    }
    
    // MARK: - setStyles
    func setStyles() {
        backgroundColor = .bgAlternative
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
        collectionView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -12),
        
        emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        
        confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        confirmButton.heightAnchor.constraint(equalToConstant: 52),
        confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -11)
        ])
    }
    
    // MARK: - setBindings
    func setBindings() {
        
    }
}
