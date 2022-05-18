//
//  APIConstants.swift
//  B2CFramework
//
//  Created by Raj Kadam on 17/05/22.
//

import Foundation

let DEFAULT_ContentPublisherId = "6007cf41f2895e2eabcc2ac2"

enum Channels {
    case dev
    case staging
    case live
    var StreamToWebsiteID: String {
        switch self {
        case .dev:
            return "61d974e3cb6b7dc065bd0017"
        case .staging:
            return "61d974e3cb6b7dc065bd0017"
        case .live:
            return "61d974e3cb6b7dc065bd0017"
        }
    }
}


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
    
    static let channels: Channels = .dev
    static let BaseUrl: BaseURL = .dev
    static let AccessToken = "accessToken"
    
    static let ContentPublisher = "content-publishers/"
    static let ContentProviders = "content-providers/"
    static let Channels = "channels/"
    static let CategoriesList = "live-session-categories/"
    
    static let UserDetail = "users"
}
