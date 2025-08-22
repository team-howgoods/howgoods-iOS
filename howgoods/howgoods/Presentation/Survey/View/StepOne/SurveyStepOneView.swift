//
//  SurveyStepOneView.swift
//  howgoods
//
//  Created by 양원식 on 8/22/25.
//

import UIKit
import Combine

final class SurveyStepOneView: UIView {
    // MARK: - Properties
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - UI Components
    private let navigationBar: CustomNavigationBar = {
        let nv = CustomNavigationBar()
        nv.translatesAutoresizingMaskIntoConstraints = false
        return nv
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let requiredLabel: UILabel = {
        let label = UILabel()
        label.setText("필수", style: .captionSemibold12, color: .primary)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let headTitle: UILabel = {
        let label = UILabel()
        label.setText("가장 좋아하는\n애니메이션을 골라주세요!", style: .headingSemibold22, color: .textDefault)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let captionTitle: UILabel = {
        let label = UILabel()
        label.text = "최대 3개까지만 선택 가능해요"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lineDefault
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tagCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 8
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = false
        return cv
    }()
    
    private let nextButton: SolidButton = {
        let button = SolidButton(frame: .zero, title: "다음", color: .primary)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let skipButton: SkipButton = {
        let button = SkipButton(frame: .zero, title: "건너뛰기", color: .gray600)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Public Publishers
    var nextButtonPublisher: AnyPublisher<Void, Never> {
        nextButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    
    var skipButtonPublisher: AnyPublisher<Void, Never> {
        skipButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    
    var getTagCollectionView: UICollectionView {
        tagCollectionView
    }
    
    var getNavigationBar: CustomNavigationBar {
        navigationBar
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
    func updateCollectionViewHeight() {
        layoutIfNeeded()
        collectionViewHeightConstraint?.constant = tagCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
}

// MARK: - Private Methods
private extension SurveyStepOneView {
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
    }
    
    func setHierarchy() {
        addSubviews(
            navigationBar,
            scrollView,
            nextButton,
            skipButton
        )
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(
            requiredLabel,
            headTitle,
            captionTitle,
            tagCollectionView
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
            
            // 스크롤뷰
            scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -16),
            
            // 콘텐츠 뷰
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            // 라벨 + 타이틀 + 캡션
            requiredLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            requiredLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            headTitle.topAnchor.constraint(equalTo: requiredLabel.bottomAnchor, constant: 4),
            headTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            captionTitle.topAnchor.constraint(equalTo: headTitle.bottomAnchor, constant: 12),
            captionTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            // 컬렉션뷰
            tagCollectionView.topAnchor.constraint(equalTo: captionTitle.bottomAnchor, constant: 16),
            tagCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tagCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tagCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        // 컬렉션뷰 높이 자동 업데이트용 제약
        collectionViewHeightConstraint = tagCollectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint?.isActive = true
        
        // 버튼 (하단 고정)
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 52),
            nextButton.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -11),
            
            skipButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            skipButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
