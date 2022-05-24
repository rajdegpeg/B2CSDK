//
//  DegpegManager.swift
//  Degpeg
//
//  Created by Raj Kadam on 25/04/22.
//

import Foundation
import UIKit
public class DegpegManager {
    
    private var authKey: String
    private var authorized: Bool
    
    public init(key: String, userId: String, userName: String, influencerID: String) {
        authKey = key
        authorized = Approved.keys.contains(key) ? true : false
        B2CUserDefaults.setUserId(id: userId)
        B2CUserDefaults.setInfluencerID(id: influencerID)
        B2CUserDefaults.setUserName(name: userName)
    }
 
    public func getRootViewController() -> UINavigationController? {
        // MARK:- TODO
        // Call API to check Auth key is valid
        // if not return  nil
        if !authorized { return nil}
        let bundle = Bundle(for: type(of: self))
        let b = Bundle.init(for: DegpegManager.self)
        let path = b.path(forResource: "B2CSDK", ofType: "bundle")
        let r_bundle = Bundle(url: URL.init(fileURLWithPath: path!))
       
        let storyboard = UIStoryboard.init(name: Storyboards.DEGPEG_STORYBOARD, bundle: r_bundle)
        if #available(iOS 13.0, *) {
            let nav = storyboard.instantiateViewController(identifier: StoryboardID.ROOT_NAVIGATION) as! UINavigationController
            return nav
        } else {
            // Fallback on earlier versions
            let nav = storyboard.instantiateViewController(withIdentifier: StoryboardID.ROOT_NAVIGATION) as! UINavigationController
            
            return nav
         }
    }
    
    
}

private struct Approved {
    static let keys = ["1234", "abcd"]
}
