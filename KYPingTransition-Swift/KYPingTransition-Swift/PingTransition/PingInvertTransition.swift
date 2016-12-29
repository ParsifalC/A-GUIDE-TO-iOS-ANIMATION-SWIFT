//
//  PingInvertTransition.swift
//  KYPingTransition-Swift
//
//  Created by Kitten Yang on 1/14/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class PingInvertTransition: NSObject,UIViewControllerAnimatedTransitioning , CAAnimationDelegate {

    fileprivate var _transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        _transitionContext = transitionContext
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! SecondViewController
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! ViewController
        let containerView = transitionContext.containerView
        let button = toVC.button
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        let finalPath = UIBezierPath(ovalIn: (button?.frame)!)
        var finalPoint = CGPoint()
        
        if (button?.frame.origin.x)! > toVC.view.bounds.size.width / 2 {
            if (button?.frame.origin.y)! < toVC.view.bounds.size.height / 2 {
                //NO.1
                finalPoint = CGPoint(x: (button?.center.x)! - 0, y: (button?.center.y)! - toVC.view.bounds.maxY+30)
            } else {
                //NO.4
                finalPoint = CGPoint(x: (button?.center.x)! - 0, y: (button?.center.y)! - 0)
            }
        } else {
            if (button?.frame.origin.y)! < toVC.view.bounds.size.height / 2 {
                //NO.2
                finalPoint = CGPoint(x: (button?.center.x)! - toVC.view.bounds.maxX, y: (button?.center.y)! - toVC.view.bounds.maxY+30)
            } else {
                //NO.3
                finalPoint = CGPoint(x: (button?.center.x)! - toVC.view.bounds.maxX, y: (button?.center.y)! - 0)
            }
        }
        
        let radius = sqrt(finalPoint.x * finalPoint.x + finalPoint.y * finalPoint.y)
        let startPath = UIBezierPath(ovalIn: (button?.frame.insetBy(dx: -radius, dy: -radius))!)
        let maskLayer = CAShapeLayer()
        maskLayer.path = finalPath.cgPath
        fromVC.view.layer.mask = maskLayer
    
        let pingAnimation = CABasicAnimation(keyPath: "path")
        pingAnimation.fromValue = startPath.cgPath
        pingAnimation.toValue =  finalPath.cgPath
        pingAnimation.duration = transitionDuration(using: transitionContext)
        pingAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pingAnimation.delegate = self
        maskLayer.add(pingAnimation, forKey: "pingInvert")
        
    }
    
}

extension PingInvertTransition {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let transitionContext = _transitionContext {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view.layer.mask = nil
            transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view.layer.mask = nil
        }
    }
    
}
