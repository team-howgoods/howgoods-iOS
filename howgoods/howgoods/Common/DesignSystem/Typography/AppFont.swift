//
//  AppFont.swift
//  howgoods
//
//  Created by 양원식 on 8/10/25.
//

import UIKit

public enum AppFont {
    public enum Weight {
        case medium, semibold
    }
    
    /// 프로젝트 전역 폰트 이름
    private static func suitName(for weight: Weight) -> String {
        switch weight {
        case .medium:   return "SUIT-Medium"
        case .semibold: return "SUIT-SemiBold"
        }
    }
    /// 필수: SUIT-Mediumr 로드 (없으면 시스템 폰트로 폴백)
    public static func suit(_ weight: Weight, size: CGFloat) -> UIFont {
        let name = suitName(for: weight)
        if let f = UIFont(name: name, size: size) {
            return f
        } else {
            assertionFailure("'\(name)' not found. Check Info.plist UIAppFonts & file name.")
            let sysWeight: UIFont.Weight = {
                switch weight {
                case .medium:   return .medium
                case .semibold: return .semibold
                }
            }()
            return .systemFont(ofSize: size, weight: sysWeight)
        }
    }
}
