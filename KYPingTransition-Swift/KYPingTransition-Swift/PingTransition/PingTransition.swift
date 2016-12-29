//
//  PingTransition.swift
//  KYPingTransition-Swift
//
//  Created by Kitten Yang on 1/8/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class PingTransition: NSObject,UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    
    fileprivate var _transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        _transitionContext = transitionContext
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! ViewController
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! SecondViewController
        let contentView = transitionContext.containerView
        
        let button = fromVC.button
        
        let maskStartPath = UIBezierPath(ovalIn: (button?.frame)!)
        contentView.addSubview(fromVC.view)
        contentView.addSubview(toVC.view)
        
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
        
        let radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y))
        let maskFinalPath = UIBezierPath(ovalIn: (button?.frame.insetBy(dx: -radius, dy: -radius))!)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskFinalPath.cgPath
        toVC.view.layer.mask = maskLayer
        
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = maskStartPath.cgPath
        maskLayerAnimation.toValue  = maskFinalPath.cgPath
        maskLayerAnimation.duration = transitionDuration(using: transitionContext)
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        maskLayerAnimation.delegate = self
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }
    
}

extension PingTransition {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let transitionContext = _transitionContext{
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view.layer.mask = nil
            transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view.layer.mask = nil
        }
    }
}
