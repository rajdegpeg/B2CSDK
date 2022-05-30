//
//  Date.swift
//  B2CSDK
//
//  Created by Raj Kadam on 19/05/22.
//

import Foundation
import UIKit
import SwiftUI


extension Date {
    
    func dateToString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "MMM d, EEEE @ h:mm a"
        let stringDate = dateFormatter.string(from: self)
        return stringDate
    }
    
    func serverRequestDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let stringDate = dateFormatter.string(from: self)
        return stringDate
    }
    
}

struct B2CFonts {
    /*
     Nunito-Regular
     == Nunito-Medium
     == Nunito-SemiBold
     == Nunito-Bold
     == Nunito-ExtraBold
     */
    static func semiBoldFont(size: CGFloat) -> UIFont? {
        return UIFont.init(name: "Nunito-SemiBold", size: size)
    }
    
    static func boldFont(size: CGFloat) -> UIFont? {
        return UIFont.init(name: "Nunito-Bold", size: size)
    }
    
    
    static func mediumFont(size: CGFloat) -> UIFont? {
        return UIFont.init(name: "Nunito-Medium", size: size)
    }
    
    static func extraBoldFont(size: CGFloat) -> UIFont? {
        return UIFont.init(name: "Nunito-ExtraBold", size: size)
    }
    
    
    static func regularFont(size: CGFloat) -> UIFont? {
        return UIFont.init(name: "Nunito-Regular", size: size)
    }
    
}
