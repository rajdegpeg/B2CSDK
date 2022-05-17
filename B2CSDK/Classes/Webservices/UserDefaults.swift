//
//  UserDefaults.swift
//  B2CFramework
//
//  Created by Raj Kadam on 17/05/22.
//

import Foundation

struct UserDefaultsKeys {
    
    static let access_token = "accessToken"
}


class B2CUserDefaults: NSObject {
 
    // MARK: Access Token
    static func setAccessToken(token: String?) {
        if let accessToken = token, !accessToken.isEmpty {
            UserDefaults.standard.set(accessToken, forKey: UserDefaultsKeys.access_token)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.access_token)
    }
    
}
