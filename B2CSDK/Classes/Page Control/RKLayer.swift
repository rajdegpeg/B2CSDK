//
//  RKLayer.swift
//  Degpeg
//
//  Created by Raj Kadam on 26/04/22.
//

import Foundation
import QuartzCore

class RKLayer: CAShapeLayer {


    override init() {
        super.init()
        self.actions = [
            "bounds": NSNull(),
            "frame": NSNull(),
            "position": NSNull()
        ]
    }
    
    override public init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
