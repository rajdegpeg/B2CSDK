//
//  UIView+Extension.swift
//  Degpeg
//
//  Created by Raj Kadam on 28/04/22.
//

import Foundation
import UIKit

extension UIView {
    func customRoundCorners(corners: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    func setupShadow(color: UIColor = .darkGray, radius: CGFloat = 5){
        
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        
    }
    
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    open class var primaryColor: UIColor {
        return UIColor.init(r: 214.0, g: 21.0, b: 79.0)
    }
    
    open class var receiverProfileBorder: UIColor {
        return UIColor.init(r: 196, g: 196, b: 196)
    }
    
}
