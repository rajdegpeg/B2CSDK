//
//  APIConstants.swift
//  B2CFramework
//
//  Created by Raj Kadam on 17/05/22.
//

import Foundation

enum BaseURL {
    case dev
    case staging
    case live
    
    var apiURL: String {
        switch self {
        case .dev:
            return "https://dev.api.degpeg.com/" //"https://dev.degpeg.live/"//
        case .staging:
            return "https://staging.api.degpeg.com/"
        case .live:
            return "https://prod.api.degpeg.com/"
        }
    }
}
let BASE_ACCESS_TOKEN = ""
struct APIConstants {
    
    static let BaseUrl: BaseURL = .dev

    static let AccessToken = "accessToken"
    
    struct Registration {
        static let SignUp = "users/signup"
        static let Login = "users/login"
        static let Influencer = "influencers"
    }
    static let UserDetail = "users"
}
