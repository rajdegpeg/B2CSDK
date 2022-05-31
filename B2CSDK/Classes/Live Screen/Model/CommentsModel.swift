//
//  CommentsModel.swift
//  B2CSDK
//
//  Created by Raj Kadam on 20/05/22.
//

import Foundation
import ObjectMapper

struct SocketViewCount: Mappable {
    
    var count: Int?
    var session_id: String?
    
    init() {}
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        count <- map["message"]
        session_id <- map["session_id"]
    }
    
}

struct ChatMessage: Mappable {
    
    var message: String?
    var userName: String?
    var messageTime: String?
    var liveSessionId: String?
    var userId: String?
    var id: String?
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        messageTime <- map["time_stamp"]
        message <- map["message"]
        userName <- map["userName"]
        liveSessionId <- map["liveSessionId"]
        id <- map["id"]
        userId <- map["userId"]
    }
}


struct CommentsFilter {
    //filter={"where":{"liveSessionId":"61e109112e1a0aac459fc5e6"}}
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
