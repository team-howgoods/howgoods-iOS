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
    private let titleImage: UIImageView = {
        // TODO: 현재 임시 이미지, 추후 바꾸기.
        let image = UIImageView()
        image.image = UIImage(systemName: "square.fill")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setText("좋아하는 애니메이션을\n선택하지 않으셨어요!", style: .headlineSemibold, color: .textDefault)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.setText("대신 지금 인기 많은 굿즈를 보여드릴게요\n(설정은 언제든 변경할 수 있어요)", style: .captionRagular11, color: .textAssistive)
        label.numberOfLines = 0
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
            titleImage,
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
            titleImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 141),
            titleImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleImage.widthAnchor.constraint(equalToConstant: 181),
            titleImage.heightAnchor.constraint(equalToConstant: 188),
            
            titleLabel.topAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            captionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 9),
            captionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            homeButton.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 28),
            homeButton.widthAnchor.constraint(equalToConstant: 165),
            homeButton.heightAnchor.constraint(equalToConstant: 49),
            homeButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    // MARK: - setBindings
    func setBindings() {
        
    }
}
