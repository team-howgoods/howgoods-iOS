//
//  TokenStorage.swift
//  howgoods
//
//  Created by 양원식 on 9/5/25.
//
import Foundation

/// 토큰과 로그인 타입을 안전하게 보관하는 스토리지
enum TokenStorage {
    private static let tokenKey = "authTokens"
    private static let loginTypeKey = "loginType"

    // MARK: - Save
    static func save(token: AuthToken, loginType: LoginType) {
        if let data = try? JSONEncoder().encode(token),
           let jsonString = String(data: data, encoding: .utf8) {
            KeychainHelper.saveToken(jsonString, for: tokenKey)
            print("[TokenStorage] 토큰 저장 완료")
            print("   AccessToken: \(token.accessToken)")
            print("   RefreshToken: \(token.refreshToken)")
        } else {
            print("[TokenStorage] 토큰 저장 실패 (인코딩 오류)")
        }
        UserDefaults.standard.set(loginType.rawValue, forKey: loginTypeKey)
        print("[TokenStorage] 로그인 타입 저장 완료 → \(loginType.rawValue)")
    }

    // MARK: - Load
    static func loadToken() -> AuthToken? {
        guard let raw = KeychainHelper.loadToken(for: tokenKey),
              let data = raw.data(using: .utf8),
              let token = try? JSONDecoder().decode(AuthToken.self, from: data) else {
            print("[TokenStorage] 저장된 토큰 없음")
            return nil
        }
        print("[TokenStorage] 토큰 로드 성공")
        print("   AccessToken: \(token.accessToken)")
        print("   RefreshToken: \(token.refreshToken)")
        return token
    }

    static func loadLoginType() -> LoginType? {
        guard let raw = UserDefaults.standard.string(forKey: loginTypeKey),
              let loginType = LoginType(rawValue: raw) else {
            print("[TokenStorage] 저장된 로그인 타입 없음")
            return nil
        }
        print("[TokenStorage] 로그인 타입 로드 성공 → \(loginType.rawValue)")
        return loginType
    }

    // MARK: - Clear
    static func clear() {
        KeychainHelper.deleteToken(for: tokenKey)
        UserDefaults.standard.removeObject(forKey: loginTypeKey)
        print("[TokenStorage] 토큰 및 로그인 타입 삭제 완료")
    }
}
