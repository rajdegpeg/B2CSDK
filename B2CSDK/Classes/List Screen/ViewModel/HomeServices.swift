//
//  HomeServices.swift
//  B2CSDK
//
//  Created by Raj Kadam on 18/05/22.
//

import Foundation
import ObjectMapper
import Alamofire
import AVFAudio
struct HomeService {
    
    func getContentPublisherDetails(contentPublisherId: String, completionHandler: @escaping (ContentPublishersDetails?, ServiceError?) -> Void) {
      
        let endPoint = "\(APIConstants.ContentPublisher)/\(contentPublisherId)"
        APIClient.getInstance().requestJson( endPoint, .get, parameters: nil) { (result, error, isExpire, code) in
            if isExpire {
                //UIUtils.showDefaultAlertView(title: AlertTitles.Error, message: "Token exp")
                completionHandler(nil, ServiceError.init(statusCode: 0, message: ""))
            } else {
                 if let error = error {
                    completionHandler(nil, error)
                }else if let result = result {
                    let details = Mapper<ContentPublishersDetails>().map(JSONObject: result)
                    completionHandler(details, nil)
                }
            }
        }
    }
    
    
    func getContentProviderVideos(contentProviderId: String, completionHandler: @escaping ([ContentProviderDetailsModel]?, ServiceError?) -> Void) {
      
//        let fil = "https://dev.api.degpeg.com/content-providers/${id}/live-sessions?filter={"include":[{"relation":"liveSessionCategory"}],"where":{"status":{"neq":"deleted"}}}"
        
        let endPoint = "\(APIConstants.ContentProviders)/\(contentProviderId)/live-sessions"

        let neqDict = ["neq":"deleted"]
        let whereParam = ["status":neqDict]
        let includeObject = ["relation":"liveSessionCategory"]
        let includeAr = [includeObject]
        let filterParam = ["include":includeAr, "where":whereParam] as [String : Any]
        let param = ["filter":filterParam]
        APIClient.getInstance().requestJson( endPoint, .get, parameters: param, encoding:  URLEncoding.default) { (result, error, isExpire, code) in
            if isExpire {
                
                completionHandler(nil, ServiceError.init(statusCode: 0, message: ""))
            } else {
                 if let error = error {
                    completionHandler(nil, error)
                }else if let result = result as? NSArray{
                    let videoList = Mapper<ContentProviderDetailsModel>().mapArray(JSONArray: result as! [[String : Any]])
                    
                    completionHandler(videoList, nil)
                }
            }
        }
    }
    
    // MARK: - Get Channel Details
    func getChannelDetails(for channelID: String, completionHandler: @escaping (ChannelData?, ServiceError?) -> Void) {
        let endPoint = "\(APIConstants.Channels)/\(channelID)"
        APIClient.getInstance().requestJson(endPoint, .get) { result, error, refresh, code in
            if let result = result {
                let session = Mapper<ChannelData>().map(JSONObject: result as! [String: Any])
                completionHandler(session, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    // MARK: - Get Categories
    func getAllCategories(completionHandler: @escaping ([CategoryData]?, ServiceError?) -> Void) {
        let endPoint = "\(APIConstants.CategoriesList)"
        APIClient.getInstance().requestJson( endPoint, .get, parameters: nil, encoding: URLEncoding.default) { (result, error, isExpire, code) in
            if isExpire {
                completionHandler(nil, ServiceError.init(statusCode: 0, message: "Token exp"))
            } else {
                 if let error = error {
                    completionHandler(nil, error)
                }else if let result = result {
                    let categories = Mapper<CategoryData>().mapArray(JSONArray: result as! [[String : Any]])
                    completionHandler(categories, nil)
                }
            }
        }
    }
}

extension HomeService {
    // MARK: - User Details
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
}
