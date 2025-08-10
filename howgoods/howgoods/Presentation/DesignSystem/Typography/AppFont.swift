//
//  AppFont.swift
//  howgoods
//
//  Created by 양원식 on 8/10/25.
//

import UIKit

public enum AppFont {
    /// 프로젝트 전역 폰트 이름
    public static let suitRegularName = "SUIT-Regular"

    /// 필수: SUIT-Regular 로드 (없으면 시스템 폰트로 폴백)
    public static func suit(_ size: CGFloat) -> UIFont {
        if let f = UIFont(name: suitRegularName, size: size) {
            return f
        } else {
            assertionFailure("'\(suitRegularName)' not found. Check Info.plist UIAppFonts & file name.")
            return .systemFont(ofSize: size)
        }
    }
}
