//
//  Bundle+.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import Foundation

extension Bundle {
    
    /// Info.plist에서 BASE_API_URL을 읽어오는 컴퓨티드 프로퍼티
    var baseAPIURL: URL {
        guard let urlString = object(forInfoDictionaryKey: "BASE_API_URL") as? String,
              let url = URL(string: "https://\(urlString)") else {
            fatalError("BASE_API_URL이 Info.plist에 설정되어 있지 않거나 잘못된 형식입니다.")
        }
        return url
    }
}
