//
//  HomeServices.swift
//  B2CSDK
//
//  Created by Raj Kadam on 18/05/22.
//

import Foundation
import ObjectMapper
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
        let neqDict = ["neq": "deleted"]
        let whereParam = ["status": neqDict]
        let includeObject = ["relation": "liveSessionCategory"]
        let includeAr = [includeObject]
        let filterParam = ["include": includeAr, "where": whereParam] as [String : Any]
        let param = ["filter": filterParam]
        APIClient.getInstance().requestJson( endPoint, .get, parameters: nil) { (result, error, isExpire, code) in
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
}
