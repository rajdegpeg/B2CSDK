//
//  Date.swift
//  B2CSDK
//
//  Created by Raj Kadam on 19/05/22.
//

import Foundation
import UIKit

extension String {
    
    func stringToDate() -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        //let date = dateFormatter.date(from: "2017-01-09T11:00:00.000Z")
       
        let date = dateFormatter.date(from: self)
        print("date: \(date)")
        return date
    }
    
    func getformatedDateString() {
        
    }
    
}
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
