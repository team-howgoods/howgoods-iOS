//
//  UIView+.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import UIKit

/// 여러 개의 서브뷰를 한 번에 추가할 수 있도록 도와주는 UIView 확장입니다.
///
/// 반복적인 `addSubview(_:)` 호출을 줄여 코드 가독성을 높이고, 뷰 계층 구성 시 효율적인 작성을 도와줍니다.
extension UIView {
    
    /// 전달된 여러 개의 UIView 인스턴스를 한 번에 현재 뷰에 추가합니다.
    ///
    /// ```swift
    /// view.addSubviews(label, button, imageView)
    /// ```
    ///
    /// - Parameter views: 현재 뷰에 추가할 서브뷰들 (가변 파라미터)
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
