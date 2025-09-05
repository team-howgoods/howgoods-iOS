//
//  UserDefaultsHelper.swift
//  howgoods
//
//  Created by 양원식 on 9/5/25.
//

import Foundation

enum UserDefaultsHelper {
    private static let surveyKey = "hasSeenSurvey"

    static var hasSeenSurvey: Bool {
        get { UserDefaults.standard.bool(forKey: surveyKey) }
        set { UserDefaults.standard.set(newValue, forKey: surveyKey) }
    }
}
