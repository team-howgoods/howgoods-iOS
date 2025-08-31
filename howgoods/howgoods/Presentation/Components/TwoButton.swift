//
//  TwoButton.swift
//  howgoods
//
//  Created by 양원식 on 8/29/25.
//

import UIKit
import Combine

/// 하단 고정 두 버튼 바: [왼쪽] 회색 Secondary  [오른쪽] 초록 Solid
final class TwoButtonBar: UIView {

    // Public buttons (필요하면 직접 속성 조정 가능)
    let secondaryButton: SecondaryButton
    let primaryButton: OneButton

    // Combine publishers
    var secondaryTapPublisher: AnyPublisher<Void, Never> {
        secondaryButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    var primaryTapPublisher: AnyPublisher<Void, Never> {
        primaryButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }

    // MARK: - Init
    init(
        secondaryTitle: String = "다음에 할게요",
         primaryTitle: String = "완료",
         primaryColor: UIColor = .primary
    ) {
        self.secondaryButton = SecondaryButton(title: secondaryTitle)
        self.primaryButton = OneButton(frame: .zero, title: primaryTitle, color: primaryColor, disabledColor: .bgDelete)
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // 외부에서 상태 제어용
    func setPrimaryEnabled(_ enabled: Bool) {
        primaryButton.isEnabled = enabled
        primaryButton.alpha = enabled ? 1.0 : 0.5
    }

    func setSecondaryEnabled(_ enabled: Bool) {
        secondaryButton.isEnabled = enabled
        secondaryButton.alpha = enabled ? 1.0 : 0.5
    }
}

private extension TwoButtonBar {
    func configure() {
        backgroundColor = .clear
        secondaryButton.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(secondaryButton)
        addSubview(primaryButton)

        NSLayoutConstraint.activate([
            // 왼쪽
            secondaryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            secondaryButton.topAnchor.constraint(equalTo: topAnchor),
            secondaryButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            secondaryButton.heightAnchor.constraint(equalToConstant: 52),
            secondaryButton.widthAnchor.constraint(equalToConstant: 98),

            // 오른쪽
            primaryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            primaryButton.leadingAnchor.constraint(equalTo: secondaryButton.trailingAnchor, constant: 4),
            primaryButton.topAnchor.constraint(equalTo: topAnchor),
            primaryButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            primaryButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
}
