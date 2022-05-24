//
//  UserDefaults.swift
//  B2CFramework
//
//  Created by Raj Kadam on 17/05/22.
//

import Foundation

struct UserDefaultsKeys {
    
    static let access_token = "B2CSDK_AccessToken"
    static let user_id = "B2CSDK_UserID"
    static let user_name = "B2CSDK_UserName"
    static let influencerID = "B2CSDK_influencerId"
    static let contentProviderID = "B2CSDK_contentProviderId"
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
    
    // MARK: Influencer Id
    static func setInfluencerID(id: String?) {
        if let influencerID = id, !influencerID.isEmpty {
            UserDefaults.standard.set(influencerID, forKey: UserDefaultsKeys.influencerID)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getInfluencerID() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.influencerID)
    }
    
    
    // MARK: User ID
    static func setUserId(id: String?) {
        if let userId = id, !userId.isEmpty {
            UserDefaults.standard.set(userId, forKey: UserDefaultsKeys.user_id)
            UserDefaults.standard.synchronize()
        }
    }
    static func getUserId() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.user_id)
    }
    
    // MARK: User Name
    static func setUserName(name: String?) {
        if let name = name, !name.isEmpty {
            UserDefaults.standard.set(name, forKey: UserDefaultsKeys.user_name)
            UserDefaults.standard.synchronize()
        }
    }
    static func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.user_name)
    }
    
}
