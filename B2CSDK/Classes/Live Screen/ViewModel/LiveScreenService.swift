//
//  LiveScreenService.swift
//  B2CSDK
//
//  Created by Raj Kadam on 19/05/22.
//

import Foundation
import ObjectMapper
import Alamofire
struct LiveScreenService {
    
    func getUserDetails(param: [String: Any], completionHandler: @escaping ([UserDetails]?, ServiceError?) -> Void) {
      
        let endPoint = "\(APIConstants.UserDetail)"
        APIClient.getInstance().requestJson( endPoint, .get, parameters: param, encoding: URLEncoding.default) { (result, error, isExpire, code) in
            if isExpire {
                completionHandler(nil, ServiceError.init(statusCode: 0, message: "Token exp"))
            } else {
                 if let error = error {
                    completionHandler(nil, error)
                }else if let result = result {
                    let details = Mapper<UserDetails>().mapArray(JSONArray: result as! [[String : Any]])
                    completionHandler(details, nil)
                }
            }
        }
    }
    
    // MARK: - Get Session Details
    func getSessionDetails(for sessionId: String, completionHandler: @escaping (Session?, ServiceError?) -> Void) {
        let endPoint = "\(APIConstants.LiveSessions)/\(sessionId)"
        APIClient.getInstance().requestJson(endPoint, .get) { result, error, refresh, code in
            if let result = result {
                let session = Mapper<Session>().map(JSONObject: result as! [String: Any])
                completionHandler(session, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    func getAllComments(param: [String: Any], completionHandler: @escaping ([CommentsModel]?, ServiceError?) -> Void) {
      
        let endPoint = "\(APIConstants.LiveSessionComments)"
        APIClient.getInstance().requestJson( endPoint, .get, parameters: param, encoding: URLEncoding.default) { (result, error, isExpire, code) in
            if isExpire {
                completionHandler(nil, ServiceError.init(statusCode: 0, message: "Token exp"))
            } else {
                 if let error = error {
                    completionHandler(nil, error)
                }else if let result = result {
                    let details = Mapper<CommentsModel>().mapArray(JSONArray: result as! [[String : Any]])
                    completionHandler(details, nil)
                }
            }
        }
    }
    
    func sendMessage(param: [String: Any], completionHandler: @escaping ([CommentsModel]?, ServiceError?) -> Void) {
        
    }
    
    
    func fetchViewCount(param: [String: Any], completionHandler: @escaping (ViewCountModel?, ServiceError?) -> Void) {
        
        APIClient.getInstance().requestJson("\(APIConstants.ViewCount)", .get, parameters: param, encoding: URLEncoding.default) { result, error, refresh, code in
            if let result = result {
                let viewCount = Mapper<ViewCountModel>().map(JSONObject: result as! [String: Any])
                completionHandler(viewCount, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    func postComment(param: [String: Any], completionHandler: @escaping (Any?, ServiceError?) -> Void) {
        APIClient.getInstance().requestJson("\(APIConstants.LiveSessionComments)", .post, parameters: param) { result, error, refresh, code in
            if let result = result {
                completionHandler(result, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    
    func fetchProduct(by productId: String, completionHandler: @escaping (Product?, ServiceError?) -> Void) {
        let endPoint = "\(APIConstants.Product)/\(productId)"
        APIClient.getInstance().requestJson(endPoint, .get, encoding: URLEncoding.default) { result, error, refresh, code in
            if let result = result {
                let productList = Mapper<Product>().map(JSONObject: result)
                completionHandler(productList, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
        
}
