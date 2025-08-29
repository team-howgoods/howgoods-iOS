//
//  SecondaryButton.swift
//  howgoods
//
//  Created by 양원식 on 8/29/25.
//

import UIKit

final class SecondaryButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(title: "다음에 할게요")
    }

    convenience init(title: String) {
        self.init(frame: .zero)
        configure(title: title)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // Public: 패딩 업데이트(네 SolidButton과 동일 인터페이스)
    public func updateInsets(
        top: CGFloat? = nil,
        left: CGFloat? = nil,
        bottom: CGFloat? = nil,
        right: CGFloat? = nil
    ) {
        setInsets(
            top: top ?? 12,
            left: left ?? 0,
            bottom: bottom ?? 12,
            right: right ?? 0
        )
    }
}

private extension SecondaryButton {
    func configure(title: String) {
        setStyle()
        setFont(title: title, style: .label1Semibold20, color: .textAlternative)
        updateInsets() // 기본 패딩
    }

    func setStyle() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .btnAlternative
        config.baseForegroundColor = .lineAlternative
        config.cornerStyle = .medium
        self.configuration = config

        layer.borderWidth = 1
        layer.borderColor = UIColor.lineAlternative.cgColor
        layer.cornerRadius = 6
        clipsToBounds = true
    }

    func setInsets(top: CGFloat = 12, left: CGFloat = 0, bottom: CGFloat = 12, right: CGFloat = 0) {
        guard var config = self.configuration else { return }
        config.contentInsets = NSDirectionalEdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
        self.configuration = config
    }

    func setFont(title: String, style: Typography.Style, color: UIColor) {
        guard var config = self.configuration else { return }
        config.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer(
                Typography.attributes(
                    for: style,
                    color: color,
                    alignment: .center,
                    lineBreak: .byTruncatingTail
                )
            )
        )
        self.configuration = config
    }
}
