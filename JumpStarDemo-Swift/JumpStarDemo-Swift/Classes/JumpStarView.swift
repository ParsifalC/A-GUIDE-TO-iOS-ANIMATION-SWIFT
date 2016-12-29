//
//  JumpStarView.swift
//  JumpStarDemo-Swift
//
//  Created by Kitten Yang on 1/6/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

enum SelectState {
    case notMarked;
    case marked
}

struct JumpStarOptions {
    var markedImage: UIImage
    var notMarkedImage: UIImage
    var jumpDuration: TimeInterval
    var downDuration: TimeInterval
}

class JumpStarView: UIView, CAAnimationDelegate {
    
    var option: JumpStarOptions?
    
    var state: SelectState = .notMarked {
        didSet{
            starView.image = state == .marked ? option?.markedImage : option?.notMarkedImage
        }
    }
    
    fileprivate var starView: UIImageView!
    fileprivate var shadowView: UIImageView!
    fileprivate var animating: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.clear
        if starView == nil {
            starView = UIImageView(frame: CGRect(x: bounds.width/2 - (bounds.width-6)/2, y: 0, width: bounds.width-6, height: bounds.height-6))
            starView.contentMode = .scaleToFill
            addSubview(starView)
        }
        
        if shadowView == nil {
            shadowView = UIImageView(frame: CGRect(x: bounds.width/2 - 10/2, y: bounds.height - 3, width: 10, height: 3))
            shadowView.alpha = 0.4
            shadowView.image = UIImage(named: "shadow_new")
            addSubview(shadowView)
        }
    }
    
    func animate() {
        if animating {
            return
        }
        
        animating = true
        let transformAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        transformAnimation.fromValue = 0.0
        transformAnimation.toValue   = M_PI_2
        transformAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let positionAnimation = CABasicAnimation(keyPath: "position.y")
        positionAnimation.fromValue = starView.center.y
        positionAnimation.toValue   = starView.center.y - 14.0
        positionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let animationGroup = CAAnimationGroup()
        if let duration = option?.jumpDuration {
            animationGroup.duration = duration
        }
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.isRemovedOnCompletion = false
        animationGroup.delegate = self
        animationGroup.animations = [transformAnimation, positionAnimation]
        
        starView.layer.add(animationGroup, forKey: "jumpUp")
    }
    
}

// MARK : CAAnimationDelegate

extension JumpStarView {
    func animationDidStart(_ anim: CAAnimation) {
        guard let _ = option else {
            return
        }
        
        if anim == starView.layer.animation(forKey: "jumpUp") {
            UIView.animate(withDuration: option!.jumpDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.shadowView.alpha = 0.2
                self.shadowView.bounds = CGRect(x: 0, y: 0, width: self.shadowView.bounds.width*1.6, height: self.shadowView.bounds.height)
                }, completion: nil)
        } else if anim == starView.layer.animation(forKey: "jumpDown") {
            UIView.animate(withDuration: option!.jumpDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.shadowView.alpha = 0.4
                self.shadowView.bounds = CGRect(x: 0, y: 0, width: self.shadowView.bounds.width/1.6, height: self.shadowView.bounds.height)
                }, completion: nil)
            
        }
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim == starView.layer.animation(forKey: "jumpUp") {
            state = state == .marked ? .notMarked : .marked
            
            let transformAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
            transformAnimation.fromValue = M_PI_2
            transformAnimation.toValue = M_PI
            transformAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            let positionAnimation = CABasicAnimation(keyPath: "position.y")
            positionAnimation.fromValue = starView.center.y - 14
            positionAnimation.toValue = starView.center.y
            positionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            
            let animationGroup = CAAnimationGroup()
            if let duration = option?.downDuration {
                animationGroup.duration = duration
            }
            animationGroup.fillMode = kCAFillModeForwards
            animationGroup.isRemovedOnCompletion = false
            animationGroup.delegate = self
            animationGroup.animations = [transformAnimation, positionAnimation]
            
            starView.layer.add(animationGroup, forKey: "jumpDown")
        } else if anim == starView.layer.animation(forKey: "jumpDown") {
            starView.layer.removeAllAnimations()
            animating = false
        }
    }
    
}





