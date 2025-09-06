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
    var hasSelection: Bool = false {
        didSet {
            collectionView.setCollectionViewLayout(createLayout(), animated: false)
        }
    }
    
    // MARK: - UI Components
    private let navigationBar: CustomNavigationBar = {
        let v = CustomNavigationBar()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let headTitle: UILabel = {
        let label = UILabel()
        label.setText(
            "최근 관심 있는 굿즈가 있다면 골라주세요!\n최저가일 때 알려드릴게요",
            style: .headlineSemibold,
            color: .textDefault
        )
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
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self else { return nil }
            
            if self.hasSelection && sectionIndex == 0 {
                // 선택된 굿즈 섹션 → header/footer 없음
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(88),
                    heightDimension: .absolute(88)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 4
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
                section.boundarySupplementaryItems = []   // header/footer 제거
                return section
            } else {
                // 일반 굿즈 섹션
                let interItemSpacing: CGFloat = 8
                let itemsPerRow: CGFloat = 2
                let availableWidth = environment.container.effectiveContentSize.width
                    - 32 - (itemsPerRow - 1) * interItemSpacing
                let itemWidth = availableWidth / itemsPerRow
                let itemHeight = itemWidth + 48
                
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
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                
                // 헤더 / 푸터 추가
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(44)
                    ),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                
                let footer = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(60)
                    ),
                    elementKind: UICollectionView.elementKindSectionFooter,
                    alignment: .bottom
                )
                
                section.boundarySupplementaryItems = [header, footer]
                
                return section
            }
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(GoodsCell.self, forCellWithReuseIdentifier: GoodsCell.identifier)
        cv.register(SelectedGoodsCell.self, forCellWithReuseIdentifier: SelectedGoodsCell.identifier)
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
    var getTwoButton: TwoButtonBar { twoButton }
    var getNavigationBar: CustomNavigationBar { navigationBar }
    var getCollectionView: UICollectionView { collectionView }
}

private extension SurveyStepFourView {
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
    }
    
    func setHierarchy() {
        addSubviews(
            navigationBar,
            headTitle,
            searchBar,
            collectionView,
            twoButton
        )
    }
    
    func setStyles() {
        backgroundColor = .white
    }
    
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
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: twoButton.topAnchor),
            
            twoButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            twoButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            twoButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -11)
        ])
    }
}
