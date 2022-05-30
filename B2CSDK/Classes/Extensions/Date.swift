//
//  Date.swift
//  B2CSDK
//
//  Created by Raj Kadam on 19/05/22.
//

import Foundation
import UIKit


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
