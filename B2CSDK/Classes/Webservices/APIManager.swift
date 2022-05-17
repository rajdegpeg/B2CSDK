//
//  APIManager.swift
//  Degpeg
//
//  Created by Raj Kadam on 25/04/22.
//

import Foundation
import Alamofire
import ObjectMapper
class NetworkManager {
    
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }

}


class APIClient: NSObject {
    
    //MARK:- APIClient Variable Initialization
    private static let instance = APIClient()
    
    //MARK:- APIClient instace and Initialization methods
    static func getInstance() -> APIClient {
        return instance
    }
    
    let interceptor = Interceptor(
        retriers: [RetryPolicy(retryLimit: 1)]
    )
    
    //MARK:-  Playdate alamofire request method for getting json response
    func requestJson(_ url: String,_ method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, headers: HTTPHeaders? = nil, useBaseUrl: Bool = true, completionHandler: @escaping (_ result: Any?, _ error: ServiceError?, _ refresh: Bool, _ statusCode: Int)-> Void) {
        
        let urlBase: URLConvertible = APIConstants.BaseUrl.apiURL + getRequestUrlWithToken(baseurl: url)
        //Logs.print("Request Url: \(urlBase)")
        //Logs.print("Request Method Type: \(method.rawValue)")
        if let parameters = parameters {
            Logs.print("Request Parameters: \(String(describing: parameters))")
        }
        AF.request(urlBase, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (response) in
            let statusCode = response.response?.statusCode ?? 000
            Logs.print("Response StatusCode: \(statusCode)")
            Logs.print("Response: \(String(describing: response))")
            
            switch response.result {
            case .success(let value):
                switch statusCode {
                case 200, 204:
                    if let arrayResponse = value as? NSArray {
                        completionHandler(arrayResponse, nil, self.checkTokenExpired(result: value), statusCode)
                    } else {
                        completionHandler(value as? [String: Any], nil, self.checkTokenExpired(result: value), statusCode)
                    }
                case 401:
                    if let responseData = value as? [String: Any], let errorObject = responseData["error"] as? [String: Any] {
                        let serviecError = Mapper<ServiceError>().map(JSONObject: errorObject)
                        completionHandler(value as? [String: Any], serviecError, self.checkTokenExpired(result: value), statusCode)
                    }
                    //TODO: Make Forcelogout, because it was loggedin with other device or access token
                    completionHandler(value as? [String: Any], ServiceError(statusCode: statusCode, message: ""), self.checkTokenExpired(result: value), statusCode)
                case 419:
                    completionHandler(nil, nil, self.checkTokenExpired(result: value), statusCode)
                case 503:
                    completionHandler(nil, ServiceError(statusCode: statusCode, message: "Something went wrong"), false, statusCode)
                default:
                    if let responseData = value as? [String: Any], let errorObject = responseData["error"] as? [String: Any] {
                        let serviecError = Mapper<ServiceError>().map(JSONObject: errorObject)
                        completionHandler(value as? [String: Any], serviecError, self.checkTokenExpired(result: value), statusCode)
                    } else {
                        completionHandler(nil, ServiceError(statusCode: statusCode, message: "Response is Empty"), false, statusCode)
                    }
                }
            case . failure(let error):
                if error.responseCode == 503 {
                    completionHandler(nil, ServiceError(statusCode: statusCode, message: "Something went wrong"), false, statusCode)
                } else {
                    completionHandler(nil, ServiceError(statusCode: statusCode, message: error.localizedDescription), false, statusCode)
                }
            }
        }
    }
    
    //MARK:-  Playdate alamofire request method for getting json response
    func requestJsonWithOutBaseURL(_ url: String,_ method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, headers: HTTPHeaders? = nil, useBaseUrl: Bool = true, completionHandler: @escaping (_ result: Any?, _ error: ServiceError?, _ refresh: Bool, _ statusCode: Int)-> Void) {
        
        let urlBase: URLConvertible = url
        Logs.print("Request Url: \(urlBase)")
        Logs.print("Request Method Type: \(method.rawValue)")
        if let parameters = parameters {
            Logs.print("Request Parameters: \(String(describing: parameters))")
        }
        AF.request(urlBase, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (response) in
            let statusCode = response.response?.statusCode ?? 000
            Logs.print("Response StatusCode: \(statusCode)")
            Logs.print("Response: \(String(describing: response))")
            
            switch response.result {
            case .success(let value):
                switch statusCode {
                case 200, 204:
                    if let arrayResponse = value as? NSArray {
                        completionHandler(arrayResponse, nil, self.checkTokenExpired(result: value), statusCode)
                    } else {
                        completionHandler(value as? [String: Any], nil, self.checkTokenExpired(result: value), statusCode)
                    }
                case 401:
                    if let responseData = value as? [String: Any], let errorObject = responseData["error"] as? [String: Any] {
                        let serviecError = Mapper<ServiceError>().map(JSONObject: errorObject)
                        completionHandler(value as? [String: Any], serviecError, self.checkTokenExpired(result: value), statusCode)
                    }
                    //TODO: Make Forcelogout, because it was loggedin with other device or access token
                    completionHandler(value as? [String: Any], ServiceError(statusCode: statusCode, message: ""), self.checkTokenExpired(result: value), statusCode)
                case 419:
                    completionHandler(nil, nil, self.checkTokenExpired(result: value), statusCode)
                case 503:
                    completionHandler(nil, ServiceError(statusCode: statusCode, message: "Something went wrong"), false, statusCode)
                default:
                    if let responseData = value as? [String: Any], let errorObject = responseData["error"] as? [String: Any] {
                        let serviecError = Mapper<ServiceError>().map(JSONObject: errorObject)
                        completionHandler(value as? [String: Any], serviecError, self.checkTokenExpired(result: value), statusCode)
                    } else {
                        completionHandler(nil, ServiceError(statusCode: statusCode, message: "Response is Empty"), false, statusCode)
                    }
                }
            case . failure(let error):
                if error.responseCode == 503 {
                    completionHandler(nil, ServiceError(statusCode: statusCode, message: "Something went wrong"), false, statusCode)
                } else {
                    completionHandler(nil, ServiceError(statusCode: statusCode, message: error.localizedDescription), false, statusCode)
                }
            }
        }
    }
    
    //MARK:-  Playdate alamofire upload method for getting json response
    func uploadJson(_ url: String,_ method: Alamofire.HTTPMethod, multipartFormData:@escaping (MultipartFormData) -> Void, useBaseUrl: Bool = true, getDetails: Bool = true, completionHandler:@escaping (_ result: [String: Any]?, _ error: ServiceError?, _ refresh: Bool)-> Void) {
        let urlBase: URLConvertible = APIConstants.BaseUrl.apiURL + getRequestUrlWithToken(baseurl: url)
        Logs.print("Request Url: \(urlBase)")
        Logs.print("Request Method Type: \(method.rawValue)")
        
        AF.upload(multipartFormData: multipartFormData,to: urlBase, headers: getAccessTokenHeader()).responseJSON { (response) in
            let statusCode = response.response?.statusCode ?? 000
            Logs.print("Response StatusCode: \(statusCode)")
            Logs.print("Response: \(String(describing: response))")
            
            switch response.result {
            case .success(let value):
                switch statusCode {
                case 200:
                    completionHandler(value as? [String: Any], nil, self.checkTokenExpired(result: value))
                case 401:
                    var message = ""
                    if let responseData = value as? [String: Any], let errorMessage = responseData["message"] as? String {
                        message = errorMessage
                    }
                    //TODO: Make Forcelogout, because it was loggedin with other device or access token
                case 419:
                    completionHandler(nil, nil, self.checkTokenExpired(result: value))
                case 503:
                    completionHandler(nil, ServiceError(statusCode: statusCode, message: "Something went wrong"), false)
                default:
                    if let responseData = value as? [String: Any], let error = responseData["message"] as? String {
                        completionHandler(nil, ServiceError(statusCode: statusCode, message: error) , false)
                    } else {
                        completionHandler(nil, ServiceError(statusCode: statusCode, message: "Response is Empty"), false)
                    }
                }
            case . failure(let error):
                completionHandler(nil, ServiceError(statusCode: statusCode, message: error.localizedDescription), false)
            }
        }
    }
    
    func getRequestUrlWithToken(baseurl: String) -> String {
        if let accessToken = B2CUserDefaults.getAccessToken(), !accessToken.isEmpty {
            return baseurl + "?token=" + accessToken
        } else if !BASE_ACCESS_TOKEN.isEmpty {
            return baseurl + "?token=" + BASE_ACCESS_TOKEN
        }
        return baseurl
    }
    
    //Get access token header
    private func getAccessTokenHeader(accessToken: String? = nil) -> HTTPHeaders {
        var header = HTTPHeaders()
        header.add(HTTPHeader(name: "x-access-token", value: ""))
        return header
    }
    
    //    private func getBaseTokenHeader() -> HTTPHeaders {
    //        var header = HTTPHeaders()
    //        header.add(HTTPHeader(name: "x-access-token", value: BASE_ACCESS_TOKEN))
    //        return header
    //    }
    
    //Get access token header
    private func getMogiTokenHeader(appKey: String, appId: String) -> HTTPHeaders {
        var header = HTTPHeaders()
        header.add(HTTPHeader(name: "app-key", value: appKey))
        header.add(HTTPHeader(name: "app-id", value: appId))
        return header
    }
    
    func checkTokenExpired(result: Any) -> Bool {
        if let resultDict = result as? [String: Any] {
            if let details = resultDict["details"] as? [String: Any], let isExpire = details["tokenExpired"] as? Bool {
                return isExpire
            }
        }
        return false
    }
    
    //MARK:- Get new token
    private func getRefershAccesToken(completionHandler: @escaping (ServiceError?) -> Void) {
        requestJson(APIConstants.AccessToken, .get, headers: getAccessTokenHeader()) { (result, error, isExpire, code)  in
            if let error = error {
                completionHandler(error)
            }
            //            else if let result = result, let accesToken = result["newToken"] as? String {
            //                B2BUserDefault.setAccessToken(token: accesToken)
            //                completionHandler(nil)
            //            }
        }
    }
    
}


struct ServiceError: Mappable {
    var statusCode: Int?
    var message: String = ""
    var name: String?
    
    init(statusCode: Int, message: String) {
        self.statusCode = statusCode
        self.message = message
    }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        message <- map["message"]
        statusCode <- map["statusCode"]
        name <- map["name"]
    }
}

enum ErrorCode {
    static let conflictError = 409
}

enum ResponseCode {
    static let success = 204
}
