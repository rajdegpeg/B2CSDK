//
//  ListModel.swift
//  Degpeg
//
//  Created by Raj Kadam on 25/04/22.
//

import Foundation
import ObjectMapper
struct ContentProviderDetailsModel: Mappable {
    
    var id: String?
    var status: String?
    var name: String?
    var date_time: String?
    var duration: String?
    var videoUrl: String?
    var banner_url: String?
    var sessionDataId: String?
    var contentProviderId: String?
    var liveSessionCategoryId: String?
    var stream_key: String?
    var channelIds: [String]?
    var description: String?
    var sessionType: String?
    var session_pass_code: String?
    var liveSessionCategory: LiveSessionCategoryData?
    
    init?(map: Map) {}
    mutating func mapping(map: Map) {
        
        videoUrl <- map["url"]
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
