//
//  tvOSCardView.swift
//  tvOSCardAnimation-Swift
//
//  Created by Kitten Yang on 1/15/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class tvOSCardView: UIView {

    fileprivate var cardImageView: UIImageView!
    fileprivate var cardParallaxView: UIImageView!
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        setUpViews()
    }
    
    fileprivate func setUpViews() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0.3
        
        cardImageView = UIImageView(frame: bounds)
        cardImageView.image = UIImage(named: "poster")
        cardImageView.layer.cornerRadius = 5.0
        cardImageView.clipsToBounds = true
        addSubview(cardImageView)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(tvOSCardView.panInCard(_:)))
        addGestureRecognizer(panGesture)

        cardParallaxView = UIImageView(frame: cardImageView.frame)
        cardParallaxView.image = UIImage(named: "5")
        cardParallaxView.layer.transform = CATransform3DTranslate(cardParallaxView.layer.transform, 0, 0, 200)
        insertSubview(cardParallaxView, aboveSubview: cardImageView)
        
    }
    
    @objc fileprivate func panInCard(_ panGes: UIPanGestureRecognizer) {
        let touchPoint = panGes.location(in: self)
        
        if panGes.state == .changed {
            let xFactor = min(1.0, max(-1, (touchPoint.x - (self.bounds.size.width/2)) / (self.bounds.size.width/2)))
            let yFactor = min(1.0, max(-1, (touchPoint.y - (self.bounds.size.height/2)) / (self.bounds.size.height/2)))
            cardImageView.layer.transform = transformWithM34(CGFloat(-1.0/500), xf: xFactor, yf: yFactor)
            
            cardParallaxView.layer.transform = transformWithM34(CGFloat(-1.0/250), xf: xFactor, yf: yFactor)
            
        } else if panGes.state == .ended {
            UIView.animate(withDuration: 0.3, animations: { [weak self] () -> Void in
                if let strongSelf = self {
                    strongSelf.cardImageView.layer.transform = CATransform3DIdentity
                    strongSelf.cardParallaxView.layer.transform = CATransform3DIdentity
                }
            })
        }
    }
    
}

// MARK : Helper Method

extension tvOSCardView {
    fileprivate func transformWithM34(_ m34: CGFloat, xf: CGFloat, yf: CGFloat) -> CATransform3D {
        var t = CATransform3DIdentity
        t.m34  = m34
        t = CATransform3DRotate(t, CGFloat(M_PI / 9) * yf, -1, 0, 0)
        t = CATransform3DRotate(t, CGFloat(M_PI / 9) * xf, 0, 1, 0)
        return t;
    }
}
