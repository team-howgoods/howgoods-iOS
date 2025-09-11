//
//  SurveyStepFourView.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//

import UIKit
import Combine

final class SurveyStepFourView: UIView {
    // MARK: - UI Components
    private let navigationBar: CustomNavigationBar = {
        let v = CustomNavigationBar()
        v.backgroundColor = .bgAlternative
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
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.allowsMultipleSelection = false
        cv.backgroundColor = .clear
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
    
    /// dataSource 기반 레이아웃 생성
    func createLayout(
        dataSource: UICollectionViewDiffableDataSource<
            SurveyStepFourViewController.Section,
            SurveyStepFourViewController.Item
        >
    ) -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self else { return nil }
            let identifiers = dataSource.snapshot().sectionIdentifiers
            guard sectionIndex < identifiers.count else { return nil }
            
            switch identifiers[sectionIndex] {
            case .selected:
                return self.makeSelectedSection()
            case .goods(_):
                return self.makeCardSection(environment: environment)
            }
        }
    }
}

// MARK: - Configure
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
        backgroundColor = .bgAlternative
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            headTitle.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 14),
            headTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
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

// MARK: - Layout
private extension SurveyStepFourView {
    /// 선택된 굿즈 섹션 (88x88, 가로 스크롤)
    func makeSelectedSection() -> NSCollectionLayoutSection {
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
        return section
    }
    
    /// 굿즈 카드 섹션 (카드 하나씩 세로로 쌓기)
    func makeCardSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(530) // 카드 높이는 내부 콘텐츠에 따라 자동 계산
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(530)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
        return section
    }
}
