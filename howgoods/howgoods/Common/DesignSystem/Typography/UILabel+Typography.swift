//
//  UILabel+Typography.swift
//  howgoods
//
//  Created by 양원식 on 8/10/25.
//

import UIKit

public extension UILabel {
    /// 멀티/싱글라인 공통: 행간 + 자간 + 폰트 웨이트 적용
    func setText(_ text: String?, style: Typography.Style, color: UIColor? = nil) {
        let attrs = Typography.attributes(
            for: style,
            color: color ?? self.textColor,
            alignment: self.textAlignment,
            lineBreak: self.lineBreakMode
        )
        self.attributedText = NSAttributedString(string: text ?? "", attributes: attrs)
    }

    /// 한 줄용: 자간만(행간 미적용)
    func applyInline(style: Typography.Style, color: UIColor? = nil) {
        let t = Typography.tokens[style]!
        let font = AppFont.suit(t.weight, size: t.size)
        let kern = t.size * (t.trackingPercent / 100.0)
        self.font = font
        self.textColor = color ?? self.textColor
        if let text = self.text {
            self.attributedText = NSAttributedString(string: text, attributes: [.font: font, .kern: kern])
        }
    }
}

