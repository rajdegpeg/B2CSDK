//
//  LiveScreenModel.swift
//  B2CSDK
//
//  Created by Raj Kadam on 22/05/22.
//

import Foundation
import ObjectMapper
struct ViewCountFilter {
    
    var sessionID = ""
    
    mutating func createFilter(id: String) -> [String: Any]{
        
        sessionID = id
        
        return filter
    }
    
    var filter: [String: Any] {
       return [
           "filter" : filterSessionId,
       ]
   }
   
    var filterSessionId: [String: Any] {
       return [
           "where": sessionIdFilter
       ]
   }
    
    var sessionIdFilter: [String: Any] {
        return [
            "liveSessionId": sessionID
        ]
    }
}

struct ViewCountModel: Mappable {
    var count: Int?
    
    init() {}
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        count <- map["count"]
    }
}

struct Session: Mappable {
    
    var banner_url: String?
    var channelIds: [String]?
    var contentProviderId: String?
    var createdAt: String?
    var date_time: String?
    var description: String?
    var duration: Double?
    var id: String?
    var liveSessionCategoryId: String?
    var name: String?
    var sessionDataId: String?
    var sessionType: String?
    var session_pass_code: String?
    var status: SessionStatus?
    var stream_key: String?
    var url: String?
    var web_banner_url: String?
    var web_video_url: String?
   // var channelDetails: [Channel]?
    var products: [String]?
    var productList: [Product]?
    var instagramStreamingKey: String?
    var facebookStreamingKey: String?
    var youtubeBroadcastId: String?
    var youtubeChatId: String?
    var facebookLiveVideoId: String?
    var bannerHeading: String?
    var bannerSubHeading: String?
    var isEmptySession: Bool = false
    var goLiveNow: Bool = false
    var isEdited: Bool = false
    var isShowSkeleton = false
    
    init() {}
    
    init(isEmptySession: Bool) {
        self.isEmptySession = isEmptySession
    }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        description <- map["description"]
        id <- map["id"]
        channelIds <- map["channelIds"]
        contentProviderId <- map["contentProviderId"]
        createdAt <- map["createdAt"]
        date_time <- map["date_time"]
        duration <- map["duration"]
        liveSessionCategoryId <- map["liveSessionCategoryId"]
        name <- map["name"]
        sessionDataId <- map["sessionDataId"]
        sessionType <- map["sessionType"]
        session_pass_code <- map["session_pass_code"]
        status <- map["status"]
        stream_key <- map["stream_key"]
        url <- map["url"]
        banner_url <- map["banner_url"]
        web_banner_url <- map["web_banner_url"]
        web_video_url <- map["web_video_url"]
        products <- map["products"]
        facebookStreamingKey <- map["facebookStreamingKey"]
        instagramStreamingKey <- map["instagramStreamingKey"]
        youtubeBroadcastId <- map["youtubeBroadcastId"]
        youtubeChatId <- map["youtubeChatId"]
        facebookLiveVideoId <- map["facebookLiveVideoId"]
        bannerHeading <- map["bannerHeading"]
        bannerSubHeading <- map["bannerSubHeading"]
    }

}
    struct Product: Mappable {
        var contentProviderId: String?
        var currency: String?
        var description: String?
        var discount: String?
        var id: String?
        var image_url: String?
        var name: String?
        var price: String?
        var purchase_link: String?
        var quantity: Int?
        var isSelected: Bool = false
        
        init(price: String ) {
            self.price = price
        }
        
        init?(map: Map) { }
        
        mutating func mapping(map: Map) {
            contentProviderId <- map["contentProviderId"]
            currency <- map["currency"]
            description <- map["description"]
            discount <- map["discount"]
            id <- map["id"]
            image_url <- map["image_url"]
            name <- map["name"]
            price <- map["price"]
            purchase_link <- map["purchase_link"]
            quantity <- map["quantity"]
        }
    }

enum SessionStatus: String {
    case planned
    case completed
    case live
    case deleted
    case scheduled
    
    var status: String {
        switch self {
        case .planned:
            return SessionStatusString.plan.rawValue
        case .completed:
            return SessionStatusString.completed.rawValue
        case .live:
            return SessionStatusString.live.rawValue
        case .deleted:
            return SessionStatusString.live.rawValue
        case .scheduled:
            return SessionStatusString.scheduled.rawValue
        }
    }
    
    
}
