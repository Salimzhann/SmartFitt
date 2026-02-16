//
//  TokenStorage.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 15.02.2026.
//

import Security
import Foundation

final class TokenStorage {
    
    static let shared = TokenStorage()
    
    private init() {}
    
    private let accessKey = "access_token"
    private let refreshKey = "refresh_token"
    
    func save(accessToken: String, refreshToken: String) {
        saveToKeychain(key: accessKey, value: accessToken)
        saveToKeychain(key: refreshKey, value: refreshToken)
    }
    
    func getAccessToken() -> String? {
        getFromKeychain(key: accessKey)
    }
    
    func getRefreshToken() -> String? {
        getFromKeychain(key: refreshKey)
    }
    
    func clear() {
        deleteFromKeychain(key: accessKey)
        deleteFromKeychain(key: refreshKey)
    }
    
    // MARK: - Keychain Helpers
    
    private func saveToKeychain(key: String, value: String) {
        if let data = value.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            
            SecItemDelete(query as CFDictionary) // Delete old value if exists
            let status = SecItemAdd(query as CFDictionary, nil)
            
            if status != errSecSuccess {
                print("Keychain save failed: \(status)")
            }
        }
    }
    
    private func getFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }
    
    private func deleteFromKeychain(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
