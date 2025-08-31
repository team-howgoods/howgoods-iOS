//
//  SkipButton.swift
//  howgoods
//
//  Created by 양원식 on 8/20/25.
//

import UIKit

final class SkipButton: UIButton {
    private let color: UIColor
    private let title: String

    // MARK: - Init
    init(frame: CGRect, title: String, color: UIColor) {
        self.color = color
        self.title = title
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet { self.alpha = isHighlighted ? 0.5 : 1.0 }
    }
}

// MARK: - Private
private extension SkipButton {
    func configure() {
        setStyles()
    }

    func setStyles() {
        let attributes = Typography.attributes(
            for: .label1Semibold20,
            color: color,
            alignment: .center,
            lineBreak: .byTruncatingTail
        )

        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer(attributes)
        )
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        self.configuration = config

        // 밑줄 추가
        let attributedString = NSMutableAttributedString(string: title, attributes: attributes)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count))
        attributedString.addAttribute(.underlineColor,
                                      value: color,
                                      range: NSRange(location: 0, length: title.count))
        setAttributedTitle(attributedString, for: .normal)
    }
}
