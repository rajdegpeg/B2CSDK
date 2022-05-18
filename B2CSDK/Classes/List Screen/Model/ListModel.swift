//
//  ListModel.swift
//  Degpeg
//
//  Created by Raj Kadam on 25/04/22.
//

import Foundation
import ObjectMapper


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
    var status: String?
    var name: String?
    var date_time: String?
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
    var liveSessionCategory: LiveSessionCategoryData?
    
    init?(map: Map) {}
    mutating func mapping(map: Map) {
        id <- map["id"]
        status <- map["status"]
        name <- map["name"]
        date_time <- map["date_time"]
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
    }
    
    
}

struct LiveSessionCategoryData: Mappable {
    var id: String?
    var description: String?
    var name: String?
    var categoryImageUrl: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        categoryImageUrl <- map["categoryImage_url"]
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
    var roles: [String]?
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
        displayPicture <- map["avatar"]
        roles <- map["roles"]
        contentProviderId <- map["contentProviderId"]
        otp <- map["otp"]
    }
}

// MARK: - Custom List Data Model
struct ListSectionData {
    var sectionName: String
    var sectionData: [RowData]?
}

struct RowData {
    var id: String?
    var videoUrl: String?
    var imageUrl: String?
    var sessionDataId: String?
    var contentProviderId: String?
    var liveSessionCategory: LiveSessionCategoryData?
    var stream_key: String?
    var sessionType: String?
    var session_pass_code: String?
    var name: String?
    var description: String?
    var userName: String?
    var userImage: String?
    var userID: String?
    var userContentProviderId: String?
}
