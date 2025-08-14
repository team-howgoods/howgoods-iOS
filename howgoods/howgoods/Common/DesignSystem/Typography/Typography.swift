//
//  Typography.swift
//  howgoods
//
//  Created by 양원식 on 8/10/25.
//

import UIKit

public enum Typography {
    public enum Style {
        case title1, title2,
             heading1, heading2,
             headline1, headline2,
             body1Normal, body1Reading, body2Reading,
             label1Normal, label1Reading, label2,
             caption1, caption2
    }

    public struct Token {
        public let size: CGFloat          // 폰트 크기(pt)
        public let lineHeight: CGFloat    // 표의 '행간'(=목표 라인 높이, px≈pt)
        public let trackingPercent: CGFloat // 자간(%)
    }

    // 표의 값 그대로 매핑
    public static let tokens: [Style: Token] = [
        .title1:        .init(size: 32, lineHeight: 48, trackingPercent: -2),
        .title2:        .init(size: 28, lineHeight: 38, trackingPercent: -1),
        .heading1:      .init(size: 22, lineHeight: 30, trackingPercent: -0.02),
        .heading2:      .init(size: 20, lineHeight: 28, trackingPercent: -0.2),
        .headline1:     .init(size: 18, lineHeight: 26, trackingPercent: -0.2),
        .headline2:     .init(size: 17, lineHeight: 24, trackingPercent:  1),
        .body1Normal:   .init(size: 16, lineHeight: 24, trackingPercent: -0.2),
        .body1Reading:  .init(size: 16, lineHeight: 26, trackingPercent: -0.2),
        .body2Reading:  .init(size: 15, lineHeight: 24, trackingPercent:  0.2),
        .label1Normal:  .init(size: 14, lineHeight: 20, trackingPercent: -0.2),
        .label1Reading: .init(size: 14, lineHeight: 22, trackingPercent: -0.2),
        .label2:        .init(size: 13, lineHeight: 18, trackingPercent:  0.8),
        .caption1:      .init(size: 12, lineHeight: 16, trackingPercent:  1.2),
        .caption2:      .init(size: 11, lineHeight: 14, trackingPercent:  2),
    ]

    /// 행간(lineSpacing) + 자간(kern)만 적용한 속성
    public static func attributes(
        for style: Style,
        color: UIColor? = nil,
        alignment: NSTextAlignment = .natural,
        lineBreak: NSLineBreakMode = .byTruncatingTail
    ) -> [NSAttributedString.Key: Any] {
        let t = tokens[style]!
        let font = AppFont.suit(t.size)

        // 목표 라인 높이 - 실제 폰트 라인 높이 = 추가 lineSpacing
        let lineSpacing = t.lineHeight - font.lineHeight

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        paragraph.lineBreakMode = lineBreak
        paragraph.lineSpacing = lineSpacing   // ← 행간만

        // 자간(% → pt)
        let kern = t.size * (t.trackingPercent / 100.0)

        var attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraph,
            .kern: kern
        ]
        if let color { attrs[.foregroundColor] = color }
        return attrs
    }

    public static func styled(_ text: String, as style: Style, color: UIColor? = nil) -> NSAttributedString {
        NSAttributedString(string: text, attributes: attributes(for: style, color: color))
    }
}
