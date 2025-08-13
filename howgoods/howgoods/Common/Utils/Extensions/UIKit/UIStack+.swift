//
//  UIStack+.swift
//  howgoods
//
//  Created by 양원식 on 8/14/25.
//

import UIKit

extension UIStackView {
    /// 여러 개의 서브뷰를 arrangedSubview로 한 번에 추가합니다.
    ///
    /// ```swift
    /// stackView.addArrangedSubviews(label, button, imageView)
    /// ```
    ///
    /// - Parameter views: StackView에 추가할 서브뷰들 (가변 파라미터)
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
