//
//  UIView+.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
