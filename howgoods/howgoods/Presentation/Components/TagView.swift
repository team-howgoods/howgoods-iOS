//
//  Tag.swift
//  howgoods
//
//  Created by 양원식 on 8/19/25.
//

import UIKit

class TagView: UIView {
    
    private let text: String
    private let textColor: UIColor
    
    private let labelView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(frame: CGRect, text: String, textColor: UIColor, backgroundColor: UIColor) {
        self.text = text
        self.textColor = textColor
        super.init(frame: frame)
        
        configure(text: text, textColor: textColor, backgroundColor: backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension TagView {
    func configure(text: String, textColor: UIColor, backgroundColor: UIColor) {
        setLabel(text: text, textColor: textColor)
        setStyle(backgroundColor: backgroundColor)
    }
    
    func setLabel(text: String, textColor: UIColor) {
        labelView.setText(text, style: .captionSemibold11, color: textColor)
        
        addSubview(labelView)
        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            labelView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            labelView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            labelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    func setStyle(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 4
        clipsToBounds = true
    }
}
