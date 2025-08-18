//
//  SolidButton.swift
//  howgoods
//
//  Created by 양원식 on 8/18/25.
//

import UIKit

class SolidButton: UIButton {
    
    private let color: UIColor
    
    init(frame: CGRect, title: String, color: UIColor) {
        self.color = color
        super.init(frame: frame)
        configure(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateInsets(
        top: CGFloat? = nil,
        left: CGFloat? = nil,
        bottom: CGFloat? = nil,
        right: CGFloat? = nil
    ) {
        setInsets(
            top: top ?? 14,
            left: left ?? 28,
            bottom: bottom ?? 14,
            right: right ?? 28
        )
    }
    
}

private extension SolidButton {
    
    func configure(title: String) {
        setStyle(title: title)
        setFont(title: title, style: .body2Semibold, color: .white)
    }
    
    func setStyle(title: String) {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = color
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        self.configuration = config
        
        layer.cornerRadius = 8
        clipsToBounds = true
    }

    
    func setInsets(top: CGFloat = 14, left: CGFloat = 28, bottom: CGFloat = 14, right: CGFloat = 28) {
        guard var config = self.configuration else { return }
        config.contentInsets = NSDirectionalEdgeInsets(
            top: top, leading: left, bottom: bottom, trailing: right
        )
        self.configuration = config
    }

    func setFont(title: String, style: Typography.Style, color: UIColor? = nil) {
        guard var config = self.configuration else { return }
        config.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer(
                Typography.attributes(
                    for: style,
                    color: color ?? .white,
                    alignment: .center,
                    lineBreak: .byTruncatingTail
                )
            )
        )
        self.configuration = config
    }
}
