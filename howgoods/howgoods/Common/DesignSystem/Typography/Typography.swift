//
//  Typography.swift
//  howgoods
//
//  Created by 양원식 on 8/10/25.
//

import UIKit

public enum Typography {
    public enum Style {
        // Title
        case title1Semibold, title1Medium          // 32 / 48
        case title2Semibold, title2Medium          // 28 / 38
        
        // Heading
        case headingSemibold22                     // 22 / 30
        case headingSemibold20                     // 20 / 28
        
        // Headline
        case headlineSemibold, headlineMedium      // 18 / 26
        
        // Body
        case body1Semibold, body1Medium, body1Reguler            // 16 / 24
        case body2Semibold, body2Medium, body2Reguler            // 15 / 23
        
        // Label
        case label1Semibold20, label1Medium22      // 14 / 20, 14 / 22
        case label2Semibold                        // 13 / 18
        
        // Caption
        case captionSemibold12, captionSemibold11, captionRagular11  // 12 / 16, 11 / 14
    }
    
    public struct Token {
        public let size: CGFloat             // pt
        public let lineHeight: CGFloat       // 목표 라인 높이(pt≈px)
        public let trackingPercent: CGFloat  // 자간(%)
        public let weight: AppFont.Weight
        public init(size: CGFloat, lineHeight: CGFloat, trackingPercent: CGFloat, weight: AppFont.Weight) {
            self.size = size
            self.lineHeight = lineHeight
            self.trackingPercent = trackingPercent
            self.weight = weight
        }
    }
    
    // 이미지 스펙에 맞춘 토큰 세트
    public static let tokens: [Style: Token] = [
        // Title
        .title1Semibold: .init(size: 32, lineHeight: 48, trackingPercent: -2.0, weight: .semibold),
        .title1Medium:   .init(size: 32, lineHeight: 48, trackingPercent: -2.0, weight: .medium),
        .title2Semibold: .init(size: 28, lineHeight: 38, trackingPercent: -1.0, weight: .semibold),
        .title2Medium:   .init(size: 28, lineHeight: 38, trackingPercent: -1.0, weight: .medium),
        
        // Heading
        .headingSemibold22: .init(size: 22, lineHeight: 30, trackingPercent: -0.02, weight: .semibold),
        .headingSemibold20: .init(size: 20, lineHeight: 28, trackingPercent: -0.2,  weight: .semibold),
        
        // Headline
        .headlineSemibold:  .init(size: 18, lineHeight: 26, trackingPercent: -0.2, weight: .semibold),
        .headlineMedium:    .init(size: 18, lineHeight: 26, trackingPercent: -1.0, weight: .medium),
        
        // Body
        .body1Semibold:     .init(size: 16, lineHeight: 26, trackingPercent: -0.2, weight: .semibold),
        .body1Medium:       .init(size: 16, lineHeight: 16.0 * 1.4, trackingPercent: -0.2, weight: .medium),
        .body1Reguler:      .init(size: 16, lineHeight: 16.0 * 1.4, trackingPercent: -0.2, weight: .regular),
        
        .body2Semibold:     .init(size: 15, lineHeight: 15.0 * 1.4, trackingPercent: 0.2, weight: .semibold),
        .body2Medium:       .init(size: 15, lineHeight: 15.0 * 1.4, trackingPercent: 0.2, weight: .medium),
        .body2Reguler:      .init(size: 15, lineHeight: 15.0 * 1.4, trackingPercent: 0.2, weight: .regular),
        
        // Label
        .label1Semibold20:  .init(size: 14, lineHeight: 14.0 * 1.4, trackingPercent: -0.2, weight: .semibold),
        .label1Medium22:    .init(size: 14, lineHeight: 14.0 * 1.4, trackingPercent: -0.2, weight: .medium),
        
        .label2Semibold:    .init(size: 13, lineHeight: 13.0 * 1.4, trackingPercent:  0.8, weight: .semibold),
        
        // Caption
        .captionSemibold12: .init(size: 12, lineHeight: 12.0 * 1.4, trackingPercent:  1.2, weight: .semibold),
        .captionSemibold11: .init(size: 11, lineHeight: 11.0 * 1.4, trackingPercent:  2.0, weight: .semibold),
        .captionRagular11: .init(size: 11, lineHeight: 11.0 * 1.4, trackingPercent:  2.0, weight: .regular),
    ]
    
    // 공통 속성 생성
    public static func attributes(
        for style: Style,
        color: UIColor? = nil,
        alignment: NSTextAlignment = .natural,
        lineBreak: NSLineBreakMode = .byTruncatingTail
    ) -> [NSAttributedString.Key: Any] {
        let t = tokens[style]!
        let font = AppFont.suit(t.weight, size: t.size)
        
        // 목표 라인 높이 기반 추가 lineSpacing
        let lineSpacing = t.lineHeight - font.lineHeight
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        paragraph.lineBreakMode = lineBreak
        paragraph.lineSpacing = lineSpacing
        
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
    
    public static func font(for style: Style) -> UIFont {
        let t = tokens[style]!
        return AppFont.suit(t.weight, size: t.size)
    }
}
