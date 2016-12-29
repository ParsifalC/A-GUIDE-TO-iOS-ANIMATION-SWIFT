//
//  Menu.swift
//  KYGooeyMenu-Swift
//
//  Created by Kitten Yang on 1/8/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class Menu: UIView , CAAnimationDelegate{
    var animationQueue: [CAKeyframeAnimation]
    var menuLayer: MenuLayer
    
    override init(frame: CGRect) {
        let real_frame = frame.insetBy(dx: -30, dy: -30)
        animationQueue = [CAKeyframeAnimation]()
        menuLayer = MenuLayer()
        super.init(frame: real_frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        menuLayer.frame = bounds
        menuLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(menuLayer)
        menuLayer.setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            switch touch.tapCount {
            case 1:
                openAnimation()
                break;
            default:
                break;
            }
        }
    }
    
    fileprivate func openAnimation() {
        let openAnimation_1 = SpringLayerAnimation.sharedAnimation.createBasicAnimation("xAxisPercent", duration: 0.3, fromValue: 0.0 as AnyObject, toValue: 1.0 as AnyObject)
        let openAnimation_2 = SpringLayerAnimation.sharedAnimation.createBasicAnimation("xAxisPercent", duration: 0.3, fromValue: 0.0 as AnyObject, toValue: 1.0 as AnyObject)
        let openAnimation_3 = SpringLayerAnimation.sharedAnimation.createSpringAnima("xAxisPercent", duration: 1.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3.0, fromValue: 0.0 as AnyObject, toValue: 1.0 as AnyObject)
        
        openAnimation_1.delegate = self
        openAnimation_2.delegate = self
        openAnimation_3.delegate = self
        
        animationQueue.append(openAnimation_1)
        animationQueue.append(openAnimation_2)
        animationQueue.append(openAnimation_3)
        
        menuLayer.add(openAnimation_1, forKey: "openAnimation_1")
        isUserInteractionEnabled = false
        menuLayer.animationState = .state1
    }
}

extension Menu {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            if anim == menuLayer.animation(forKey: "openAnimation_1") {
                menuLayer.removeAllAnimations()
                menuLayer.add(animationQueue[1], forKey: "openAnimation_2")
                menuLayer.animationState = .state2
            } else if anim == menuLayer.animation(forKey: "openAnimation_2") {
                menuLayer.removeAllAnimations()
                menuLayer.add(animationQueue[2], forKey: "openAnimation_3")
                menuLayer.animationState = .state3
            } else if anim == menuLayer.animation(forKey: "openAnimation_3") {
                menuLayer.xAxisPercent = 1.0
                menuLayer.removeAllAnimations()
                isUserInteractionEnabled = true
            }
        }
    }
    
}
