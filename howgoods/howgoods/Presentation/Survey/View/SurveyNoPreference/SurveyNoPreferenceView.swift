//
//  SurveyNoPreferenceView.swift
//  howgoods
//
//  Created by 양원식 on 8/30/25.
//

import UIKit
import Combine

final class SurveyNoPreferenceView: UIView {
    // MARK: - Properties
    
    // MARK: - UI Components
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setText("좋아하는 애니메이션을 선택하지 않으셨어요!", style: .headlineSemibold, color: .textDefault)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.setText("대신 지금 인기 많은 굿즈를 보여드릴게요\n(설정은 언제든 변경할 수 있어요)", style: .body1Medium, color: .textDefault)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let homeButton: SolidButton = {
        let button = SolidButton(frame: .zero, title: "홈으로 이동할게요", color: .primary)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var homeButtonPublisher: AnyPublisher<Void, Never> {
        homeButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
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

private extension SurveyNoPreferenceView {
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
            contentView
        )
        
        contentView.addSubviews(
            titleLabel,
            captionLabel,
            homeButton
        )
    }
    
    // MARK: - setStyles
    func setStyles() {
        backgroundColor = .white
    }
    
    // MARK: - setConstraints
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            captionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            captionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            homeButton.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 24),
            homeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            homeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            homeButton.widthAnchor.constraint(equalToConstant: 165),
            homeButton.heightAnchor.constraint(equalToConstant: 49)
        ])
    }
    
    // MARK: - setBindings
    func setBindings() {
        
    }
}
