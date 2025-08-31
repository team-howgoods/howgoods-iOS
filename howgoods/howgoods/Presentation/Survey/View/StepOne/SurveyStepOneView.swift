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
    
    private let introLabel: UILabel = {
        let label = UILabel()
        label.setText("최저가 굿즈 찾기, 시작해볼까요?", style: .body1Medium, color: .textAssistive)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let headTitle: UILabel = {
        let label = UILabel()
        label.setText("먼저 가장 좋아하는 애니메이션을 골라주세요!", style: .headlineSemibold, color: .textDefault)
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
    
    private lazy var tagCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 8
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = true
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
            introLabel,
            headTitle,
            captionLabel,
            errorLabel,
            tagCollectionView,
            twoButton
        )
    }

    func setStyles() {
        backgroundColor = .white
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            // 인트로
            introLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 44),
            introLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            // 타이틀
            headTitle.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 16),
            headTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            // 캡션
            captionLabel.topAnchor.constraint(equalTo: headTitle.bottomAnchor, constant: 4),
            captionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            errorLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 16),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            // 컬렉션뷰
            tagCollectionView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
            tagCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tagCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tagCollectionView.bottomAnchor.constraint(equalTo: twoButton.topAnchor, constant: -25)
        ])
        
        // 버튼 (하단 고정)
        NSLayoutConstraint.activate([
            twoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            twoButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            twoButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            twoButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -11)
        ])
    }
}
