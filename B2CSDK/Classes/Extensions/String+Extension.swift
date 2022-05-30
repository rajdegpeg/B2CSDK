//
//  String+Extension.swift
//  B2CSDK
//
//  Created by Raj Kadam on 30/05/22.
//

import Foundation
import UIKit
extension String {
    
    func stringToDate() -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: self)
        print("date: \(date)")
        return date
    }
    
    func emailToName() -> String{
        if let name = self.components(separatedBy: "@").first {
            return name.replacingOccurrences(of: ".", with: " ").capitalized
        }else {
            return ""
        }
    }
    
    func nameToInitials() -> String{
        let nameArray = self.components(separatedBy: " ")
        var initials = ""
        if let firstName = nameArray.first {
            initials = String(firstName.prefix(1)).capitalized
        }
        if nameArray.count > 1 {
        if let lastName = nameArray.last {
            initials = initials+String(lastName.prefix(1)).capitalized
        }
        }
        return initials
    }
    
    func emojiToImage() -> UIImage? {
        let nsString = (self as NSString)
        let font = UIFont.systemFont(ofSize: 1024) // you can change your font size here
        let stringAttributes = [NSAttributedString.Key.font: font]
        let imageSize = nsString.size(withAttributes: stringAttributes)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0) //  begin image context
        UIColor.clear.set() // clear background
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize)) // set rect size
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes) // draw text within rect
        let image = UIGraphicsGetImageFromCurrentImageContext() // create image from context
        UIGraphicsEndImageContext() //  end image context
        
        return image
    }
    
}
