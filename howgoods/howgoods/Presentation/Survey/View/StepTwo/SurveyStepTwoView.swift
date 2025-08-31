//
//  SurveyStepTwoView.swift
//  howgoods
//
//  Created by 양원식 on 8/23/25.
//

import UIKit
import Combine

final class SurveyStepTwoView: UIView {

    // MARK: - Properties
    private let navigationBar: CustomNavigationBar = {
        let nv = CustomNavigationBar()
        nv.translatesAutoresizingMaskIntoConstraints = false
        return nv
    }()
    
    private let requiredLabel: UILabel = {
        let label = UILabel()
        label.setText("필수 선택", style: .captionSemibold12, color: .primary)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let headTitle: UILabel = {
        let label = UILabel()
        label.setText("가장 좋아하는 캐릭터는 누구인가요?", style: .headlineSemibold, color: .textDefault)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.setText("최대 5개 선택 가능", style: .label1Medium22, color: .textAssistive)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.setText("오류 메세지", style: .body2Medium, color: .warning)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let nextButton: OneButton = {
        let button = OneButton(frame: .zero, title: "다음(0/5)", color: .primary, disabledColor: .bgDelete)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "다음"
        button.isEnabled = false
        return button
    }()
    
    // MARK: - tagCollectionView
    private lazy var tagCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            return self.createCharacterSection()
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
        collectionView.register(TitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderView.identifier)
        
        collectionView.allowsMultipleSelection = true
        
        return collectionView
    }()
    
    // MARK: - Public Publishers
    var nextButtonPublisher: AnyPublisher<Void, Never> {
        nextButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    
    var getNavigationBar: CustomNavigationBar {
        navigationBar
    }
    
    var getTagCollectionView: UICollectionView {
        tagCollectionView
    }

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    // MARK: - Public Methods
    func createCharacterSection() -> NSCollectionLayoutSection {
        // 아이템 크기 설정 (가로 100, 세로 108)
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(108), heightDimension: .absolute(108))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 그룹 크기 설정 (아이템 크기와 간격을 포함해서 계산)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(116), heightDimension: .absolute(132)) // 100 (셀) + 8 (간격) + 8 (간격)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous  // 수평 스크롤 동작 설정
        
        // 섹션 헤더 (애니메이션 그룹 타이틀)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(26))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]

        return section
    }
    
    func updateNextButtonTitle(count: Int) {
        nextButton.updateTitle("다음(\(count)/5)")
    }
    
    func setNextButtonEnabled(_ enabled: Bool) {
        nextButton.isEnabled = enabled
    }
}

// MARK: - Private Methods
private extension SurveyStepTwoView {
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
    }
    
    func setHierarchy() {
        addSubviews(
            navigationBar,
            requiredLabel,
            headTitle,
            captionLabel,
            errorLabel,
            tagCollectionView,
            nextButton
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
            
            requiredLabel.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 14),
            requiredLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            headTitle.topAnchor.constraint(equalTo: requiredLabel.bottomAnchor, constant: 7),
            headTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            captionLabel.topAnchor.constraint(equalTo: headTitle.bottomAnchor, constant: 4),
            captionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            errorLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 16),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            // tagCollectionView Constraints
            tagCollectionView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 8),
            tagCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tagCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tagCollectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -8),
        ])
        
        // 버튼 (하단 고정)
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 52),
            nextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -11),
        ])
    }
}
