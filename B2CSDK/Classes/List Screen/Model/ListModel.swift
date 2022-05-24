//
//  ListModel.swift
//  Degpeg
//
//  Created by Raj Kadam on 25/04/22.
//

import Foundation
import ObjectMapper

struct ChannelData: Mappable
{
    var id: String?
    var name: String?
    var description: String?
    var contentProviderId: [String]?
    
     var isWebToStream: Bool {
        
        if name == "Stream To Website" {
            return true
        }
        else {
            return false
        }
    }
    init?(map: Map) {}
    mutating func mapping(map: Map) {
        id <- map["id"]
        description <- map["status"]
        name <- map["name"]
        contentProviderId <- map["contentProviders"]
        
    }
}
struct ContentPublishersDetails: Mappable {
    var id: String?
    var status: String?
    var name: String?
    var email: String?
    var contentProviders: [String]?
    init?(map: Map) {}
    mutating func mapping(map: Map) {
        id <- map["id"]
        status <- map["status"]
        name <- map["name"]
        email <- map["email"]
        contentProviders <- map["contentProviders"]
        
    }
}

struct ContentProviderDetailsModel: Mappable {
    
    var id: String?
    //var status: String?
    var status: SessionStatus?
    var name: String?
    var dateTime: String?
    var duration: String?
    var videoUrl: String?
    var bannerUrl: String?
    var sessionDataId: String?
    var contentProviderId: String?
    var liveSessionCategoryId: String?
    var streamKey: String?
    var channelIds: [String]?
    var description: String?
    var sessionType: String?
    var sessionPassCode: String?
    var products: [String]?
    var liveSessionCategory: CategoryData?
    var webVideoUrl: String?
    
    init?(map: Map) {}
    mutating func mapping(map: Map) {
        id <- map["id"]
        status <- map["status"]
        name <- map["name"]
        dateTime <- map["date_time"]
        duration <- map["duration"]
        videoUrl <- map["url"]
        bannerUrl <- map["banner_url"]
        sessionDataId <- map["sessionDataId"]
        contentProviderId <- map["contentProviderId"]
        liveSessionCategoryId <- map["liveSessionCategoryId"]
        streamKey <- map["stream_key"]
        channelIds <- map["channelIds"]
        description <- map["description"]
        sessionType <- map["sessionType"]
        sessionPassCode <- map["session_pass_code"]
        liveSessionCategory <- map["liveSessionCategory"]
        products <- map["products"]
        webVideoUrl <- map["web_video_url"]
    }
    
    
}

struct CategoryData: Mappable {
    var id: String?
    var description: String?
    var name: String?
    var categoryImageUrl: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        categoryImageUrl <- map["categoryImage_url"]
        name <- map["name"]
        description <- map["description"]
        id <- map["id"]
    }
    
    
}

// MARK: User Model

struct UserDetails: Mappable {
    
    var address: String?
    var email: String?
    var password: String?
    var firstName: String?
    var fullName: String?
    var displayPicture: String?
    var id: String?
    var influencerId: String?
    var contentProviderId: String?
    var mobile: String?
    var otp: String?
    //var roles: [String]?
    var status: String?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        address <- map["address"]
        email <- map["email"]
        firstName <- map["firstName"]
        fullName <- map["name"]
        id <- map["id"]
        influencerId <- map["influencerId"]
        mobile <- map["mobile"]
        displayPicture <- map["displayPicture"]
        //roles <- map["roles"]
        contentProviderId <- map["contentProviderId"]
        otp <- map["otp"]
        status <- map["status"]
    }
}

// MARK: - Custom List Data Model
struct ListSectionData {
    var sectionName: HomeSections
    var sectionData: [RowData]?
}

enum HomeSections {
    case live
    case trending
    case category
    case upcoming
    case brand
}
struct RowData {
    var id: String?
    var products: [String]?
    var sessionDate: Date
    var videoUrl: String?
    var status: SessionStatus?
    var imageUrl: String?
    var sessionDataId: String?
    var contentProviderId: String?
    var liveSessionCategory: CategoryData?
    var streamKey: String?
    var sessionType: String?
    var sessionPassCode: String?
    var name: String?
    var description: String?
    var userName: String?
    var userImage: String?
    var userID: String?
    var userContentProviderId: String?
    
}

struct UserFilter {
    
     var providerID = ""
    mutating func createUserFilter(id: String) -> [String: Any]{
        
        providerID = id
        
        return filter
    }
     var filter: [String: Any] {
        return [
            "filter" : filterProviderId,
        ]
    }
    
     var filterProviderId: [String: Any] {
        return [
            "where": providerIdFilter
        ]
    }
    
     var providerIdFilter: [String: Any] {
        return [
            "contentProviderId": providerID
        ]
    }
}
