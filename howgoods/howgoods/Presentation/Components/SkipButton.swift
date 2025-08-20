//
//  SkipButton.swift
//  howgoods
//
//  Created by 양원식 on 8/20/25.
//

import UIKit

class SkipButton: UIButton {
    private let color: UIColor

    init(frame: CGRect, title: String, color: UIColor) {
        self.color = color
        super.init(frame: frame)
        configure(title: title)
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.alpha = isHighlighted ? 0.5 : 1.0
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SkipButton {
    func configure(title: String) {
        let attributes = Typography.attributes(
            for: .captionSemibold12,
            color: color,
            alignment: .center,
            lineBreak: .byTruncatingTail
        )
        
        let attributedString = NSMutableAttributedString(string: title, attributes: attributes)
        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: title.count)
        )
        attributedString.addAttribute(
            .underlineColor,
            value: color,
            range: NSRange(location: 0, length: title.count)
        )
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

