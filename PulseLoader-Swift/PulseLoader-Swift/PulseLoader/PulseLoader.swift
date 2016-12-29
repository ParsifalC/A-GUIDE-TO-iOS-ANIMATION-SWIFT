//
//  PulseLoader.swift
//  PulseLoader-Swift
//
//  Created by Kitten Yang on 2/2/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class PulseLoader: UIView {
    
    fileprivate let pulseLayer = CAShapeLayer()
    var color: UIColor
    
    init(frame: CGRect, color: UIColor) {
        self.color = color
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUp() {
        pulseLayer.frame = bounds
        pulseLayer.path  = UIBezierPath(ovalIn: pulseLayer.bounds).cgPath
        pulseLayer.fillColor = color.cgColor
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = bounds
        replicatorLayer.instanceDelay = 0.5
        replicatorLayer.instanceCount = 8
        replicatorLayer.addSublayer(pulseLayer)
        pulseLayer.opacity = 0.0
        layer.addSublayer(replicatorLayer)
    }
    
    func startToPluse() {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [alphaAnimation(), scaleAnimation()]
        groupAnimation.duration = 4.0
        groupAnimation.autoreverses = false
        groupAnimation.repeatCount = HUGE
        pulseLayer.add(groupAnimation, forKey: "groupAnimation")
    }
    
    fileprivate func alphaAnimation() -> CABasicAnimation{
        let alphaAnim = CABasicAnimation(keyPath: "opacity")
        alphaAnim.fromValue = NSNumber(value: 1.0 as Float)
        alphaAnim.toValue = NSNumber(value: 0.0 as Float)
        return alphaAnim
    }
    
    fileprivate func scaleAnimation() -> CABasicAnimation{
        let scaleAnim = CABasicAnimation(keyPath: "transform")
        
        let t = CATransform3DIdentity
        let t2 = CATransform3DScale(t, 0.0, 0.0, 0.0)
        scaleAnim.fromValue = NSValue.init(caTransform3D: t2)
        let t3 = CATransform3DScale(t, 1.0, 1.0, 0.0)
        scaleAnim.toValue = NSValue.init(caTransform3D: t3)
        return scaleAnim
    }
    
}
