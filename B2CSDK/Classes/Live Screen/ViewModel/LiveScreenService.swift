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
    
}
