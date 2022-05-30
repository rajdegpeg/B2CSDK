//
//  AnimationView.swift
//  B2CSDK
//
//  Created by Raj Kadam on 30/05/22.
//

import Foundation
import UIKit

class EmojiAnimationView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    func animate(icon: UIImage) {
        let imageView = UIImageView(image: icon)
        let dimension = 30 + drand48() * 10
        imageView.frame = CGRect(x: -350, y: 0, width: dimension, height: dimension)
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 1.0
        pulse.toValue = 1.12
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.initialVelocity = 0.5
        pulse.damping = 0.8
        imageView.layer.add(pulse, forKey: nil)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        
        animation.path = customPath().cgPath
        animation.duration = 2 + drand48() * 3
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        imageView.layer.add(animation, forKey: nil)
        addSubview(imageView)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { time in
            imageView.removeFromSuperview()
        }
    }
    
    func customPath() ->UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: CGFloat.random(in: 0...frame.width) , y: frame.height))
        let endPoint = CGPoint(x: CGFloat.random(in: 0...frame.width), y: 0)
        
        let cp1 = CGPoint(x: CGFloat.random(in: 0...100), y: (frame.height - 100))
        let cp2 = CGPoint(x: 0, y: frame.height - 200)
        path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        return path
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
