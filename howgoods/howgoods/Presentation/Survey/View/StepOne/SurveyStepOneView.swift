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
    
    
    private let headTitle: UILabel = {
        let label = UILabel()
        label.setText("먼저 가장 좋아하는 애니메이션을 골라주세요!", style: .headlineSemibold, color: .textDefault)
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
    
    private let twoButton: TwoButtonBar = {
        let button = TwoButtonBar()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Public Publishers
    var getTagCollectionView: UICollectionView {
        tagCollectionView
    }
    
    var getTwoButton: TwoButtonBar {
        twoButton
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
            scrollView,
            twoButton
        )
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(
            headTitle,
            tagCollectionView
        )
    }

    func setStyles() {
        backgroundColor = .white
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            // 스크롤뷰
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: twoButton.topAnchor, constant: -16),
            
            // 콘텐츠 뷰
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            headTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            headTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            // 컬렉션뷰
            tagCollectionView.topAnchor.constraint(equalTo: headTitle.bottomAnchor, constant: 16),
            tagCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tagCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tagCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        // 컬렉션뷰 높이 자동 업데이트용 제약
        collectionViewHeightConstraint = tagCollectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint?.isActive = true
        
        // 버튼 (하단 고정)
        NSLayoutConstraint.activate([
            twoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            twoButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            twoButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            twoButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -11)
        ])
    }
}
