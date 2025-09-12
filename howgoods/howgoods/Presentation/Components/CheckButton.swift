//
//  CheckButton.swift
//  howgoods
//
//  Created by 양원식 on 9/12/25.
//

import UIKit
import Combine

final class CheckButton: UIControl {
    
    // MARK: - UI
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setText("", style: .label1Semibold20, color: .textDefault)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Combine
    private let tapSubject = PassthroughSubject<Bool, Never>()
    var tapPublisher: AnyPublisher<Bool, Never> {
        tapSubject.eraseToAnyPublisher()
    }
    
    // MARK: - State
    override var isSelected: Bool {
        didSet { updateUI() }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public
extension CheckButton {
    func setTitle(_ text: String) {
        titleLabel.setText(text, style: .label1Semibold20, color: .textDefault)
    }
}

// MARK: - Private
private extension CheckButton {
    func configure() {
        addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 4),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // UIControl은 intrinsic size가 없으므로 높이 지정
        heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        // 전체 UIView가 터치 영역
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleSelected))
        addGestureRecognizer(tapGesture)
        
        updateUI()
    }
    
    func updateUI() {
        let imageName = isSelected ? "check_circle_selected" : "check_circle_unselected"
        iconImageView.image = UIImage(named: imageName)
    }
    
    @objc func toggleSelected() {
        isSelected.toggle()
        tapSubject.send(isSelected) // Combine 이벤트 방출
        sendActions(for: .valueChanged) // UIControl 이벤트도 같이 방출
    }
}
