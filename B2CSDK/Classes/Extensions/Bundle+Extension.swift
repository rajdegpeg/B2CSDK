//
//  Bundle+Extension.swift
//  B2CFramework
//
//  Created by Raj Kadam on 17/05/22.
//

import Foundation
import UIKit

public extension Bundle {

    static func resourceBundle(for frameworkClass: AnyClass) -> Bundle {
        guard let moduleName = String(reflecting: frameworkClass).components(separatedBy: ".").first else {
            fatalError("Couldn't determine module name from class \(frameworkClass)")
        }
        let frameworkBundle = Bundle(for: frameworkClass)
        guard let resourceBundleURL = frameworkBundle.url(forResource: moduleName, withExtension: "bundle"),
              let resourceBundle = Bundle(url: resourceBundleURL) else {
            fatalError("\(moduleName).bundle not found in \(frameworkBundle)")
        }
        return resourceBundle
    }
}
 


extension UIImage {
    
    static func getPlaceholderImage() -> UIImage? {
        return UIImage(named: ImageConstants.placeholderImage, in: Bundle.resourceBundle(for: ListViewController.self), compatibleWith: nil)
    }
}
