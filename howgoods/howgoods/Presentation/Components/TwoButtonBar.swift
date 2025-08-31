//
//  TwoButtonBar.swift
//  howgoods
//
//  Created by 양원식 on 8/29/25.
//

import UIKit
import Combine

final class TwoButtonBar: UIView {

    // MARK: - UI
    private let skipButton: SkipButton = {
        let button = SkipButton(frame: .zero, title: "다음에 할게요", color: .textAssistive)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let primaryButton: OneButton = {
        let button = OneButton(frame: .zero,
                               title: "완료",
                               color: .primary,
                               disabledColor: .bgDelete)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Publishers
    var skipButtonTapPublisher: AnyPublisher<Void, Never> {
        skipButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }

    var primaryTapPublisher: AnyPublisher<Void, Never> {
        primaryButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        configure()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // 외부에서 상태 제어
    func setPrimaryEnabled(_ enabled: Bool) {
        primaryButton.isEnabled = enabled
    }
}

// MARK: - Private
private extension TwoButtonBar {
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
    }

    func setHierarchy() {
        addSubviews(
            skipButton,
            primaryButton
        )
    }

    func setStyles() {
        backgroundColor = .clear
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            skipButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            skipButton.topAnchor.constraint(equalTo: topAnchor),
            skipButton.bottomAnchor.constraint(equalTo: bottomAnchor),

            primaryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            primaryButton.leadingAnchor.constraint(equalTo: skipButton.trailingAnchor, constant: 4),
            primaryButton.topAnchor.constraint(equalTo: topAnchor),
            primaryButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            primaryButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
}
