//
//  UIButton+Typography.swift
//  howgoods
//
//  Created by 양원식 on 9/5/25.
//

import UIKit

public extension UIButton {
    /// 버튼의 titleLabel에 Typography 스타일 적용
    func setText(_ text: String?, style: Typography.Style, color: UIColor? = nil, for state: UIControl.State = .normal) {
        // UILabel.setText와 동일한 attributes 가져오기
        let attrs = Typography.attributes(
            for: style,
            color: color ?? self.titleLabel?.textColor ?? .black,
            alignment: self.titleLabel?.textAlignment ?? .center,
            lineBreak: self.titleLabel?.lineBreakMode ?? .byTruncatingTail
        )
        let attributedTitle = NSAttributedString(string: text ?? "", attributes: attrs)
        self.setAttributedTitle(attributedTitle, for: state)
    }
}
