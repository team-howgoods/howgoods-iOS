//
//  Bundle+.swift
//  howgoods
//
//  Created by 양원식 on 8/3/25.
//

import Foundation

/// Info.plist에 정의된 환경 설정 값을 읽기 위한 Bundle 확장입니다.
///
/// API URL, Kakao Native App Key 등의 민감한 정보를 안전하게 관리하고 접근할 수 있도록 도와줍니다.
/// - 주로 네트워크 설정 및 SDK 초기화 시 사용됩니다.
extension Bundle {
    
    /// Info.plist에서 `BASE_API_URL` 키를 읽어와 `URL`로 반환합니다.
    ///
    /// - Returns: "https://example.com" 형식의 URL
    /// - Note: Info.plist에 `BASE_API_URL` 항목이 반드시 존재해야 하며, `String` 타입이어야 합니다.
    /// - Warning: 설정이 누락되었거나 잘못된 형식일 경우 `fatalError`를 발생시킵니다.
    var baseAPIURL: URL {
        guard let urlString = object(forInfoDictionaryKey: "BASE_API_URL") as? String,
              let url = URL(string: "https://\(urlString)") else {
            fatalError("BASE_API_URL이 Info.plist에 설정되어 있지 않거나 잘못된 형식입니다.")
        }
        return url
    }
    
    /// Info.plist에서 Kakao SDK용 `NATIVE_APP_KEY` 값을 읽어옵니다.
    ///
    /// - Returns: Kakao SDK의 앱 키 (`String`)
    /// - Note: Info.plist에 `NATIVE_APP_KEY` 항목이 반드시 존재해야 하며, `String` 타입이어야 합니다.
    /// - Warning: 설정이 누락되었을 경우 `fatalError`를 발생시킵니다.
    var kakaoNativeAppKey: String {
        guard let key = object(forInfoDictionaryKey: "NATIVE_APP_KEY") as? String else {
            fatalError("NATIVE_APP_KEY가 Info.plist에 설정되어 있지 않습니다.")
        }
        return key
    }
}
