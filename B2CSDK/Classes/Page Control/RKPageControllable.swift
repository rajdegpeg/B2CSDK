//
//  RKPageControllable.swift
//  Degpeg
//
//  Created by Raj Kadam on 26/04/22.
//

import Foundation
import CoreGraphics
import UIKit

protocol RKPageControllable: AnyObject {
    var numberOfPages: Int { get set }
    var currentPage: Int { get }
    var progress: Double { get set }
    var hidesForSinglePage: Bool { get set }
    var borderWidth: CGFloat { get set }

    func set(progress: Int, animated: Bool)
}


extension RKPageControllable {
    internal func blend(color1: UIColor, color2: UIColor, progress: CGFloat) -> UIColor {
        let l1 = 1 - progress
        let l2 = progress
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return UIColor(red: l1*r1 + l2*r2, green: l1*g1 + l2*g2, blue: l1*b1 + l2*b2, alpha: l1*a1 + l2*a2)
    }
}
