//
//  Logs.swift
//  Alamofire
//
//  Created by Raj Kadam on 17/05/22.
//

import Foundation
class Logs {
    
    static func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        let output = items.map { "\($0)" }.joined(separator: separator)
        Swift.print(output, terminator: terminator)
    #else
        Swift.print("RELEASE MODE")
    #endif
    }
    
}
