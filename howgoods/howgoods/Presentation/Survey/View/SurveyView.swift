//
//  SurveyView.swift
//  howgoods
//
//  Created by 양원식 on 8/20/25.
//

import UIKit
import Combine

final class SurveyView: UIView {
    // MARK: - Properties
    
    // MARK: - UI Components
    private let headTitle: UILabel = {
        let label = UILabel()
        label.setText("좋아하는 굿즈,\n더 똑똑하게 살 수 있어요!", style: .headingSemibold22, color: .textDefault)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let captionTitle: UILabel = {
        // TODO: 추후 폰트 바꾸기.
        let label = UILabel()
        label.text = "몇 가지 질문에 답하면 원하는 상품 중심으로\n최저가 정보를 알려드릴게요"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lineDefault
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleImage: UIImageView = {
        // TODO: 현재 임시 이미지, 추후 바꾸기.
        let image = UIImageView()
        image.image = UIImage(systemName: "circle.fill")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let startButton: SolidButton = {
        let button = SolidButton(frame: .zero, title: "지금 시작하기", color: .primary)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // TODO: 추후 버튼 색상 변경
    private let skipButton: SkipButton = {
        let button = SkipButton(frame: .zero, title: "건너뛰기", color: .gray600)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Public Publishers
    var startButtonPublisher: AnyPublisher<Void, Never> {
        startButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    
    var skipButtonPublisher: AnyPublisher<Void, Never> {
        skipButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
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

private extension SurveyView {
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
            headTitle,
            captionTitle,
            titleImage,
            startButton,
            skipButton
        )
    }
    
    // MARK: - setStyles
    func setStyles() {
        backgroundColor = .white
    }
    
    // MARK: - setConstraints
    func setConstraints() {
        NSLayoutConstraint.activate([
        headTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 79),
        headTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        
        captionTitle.topAnchor.constraint(equalTo: headTitle.bottomAnchor, constant: 12),
        captionTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        
        titleImage.topAnchor.constraint(equalTo: captionTitle.bottomAnchor, constant: 105),
        titleImage.centerXAnchor.constraint(equalTo: centerXAnchor),
        titleImage.widthAnchor.constraint(equalToConstant: 158),
        titleImage.heightAnchor.constraint(equalToConstant: 158),
        
        startButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        startButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        startButton.heightAnchor.constraint(equalToConstant: 52),
        startButton.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -11),
        
        skipButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        skipButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - setBindings
    func setBindings() {
        
    }
}


