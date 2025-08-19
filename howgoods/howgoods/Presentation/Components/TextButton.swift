//
//  TextButton.swift
//  howgoods
//
//  Created by 양원식 on 8/19/25.
//

import UIKit

class TextButton: UIButton {
    
    private let color: UIColor
    
    init(frame: CGRect, title: String, color: UIColor) {
        self.color = color
        super.init(frame: frame)
        
        configure(title: title, color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

private extension TextButton {
    
    func configure(title: String, color: UIColor) {
        setStyle(title: title)
        setFont(title: title, style: .label1Semibold20, color: color)
    }
    
    func setStyle(title: String) {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = color
        config.title = title
        config.image = UIImage(named: "chevronRight")
        config.imagePlacement = .trailing
        config.imagePadding = 7.5
        
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
