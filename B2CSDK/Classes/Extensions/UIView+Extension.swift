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
}
