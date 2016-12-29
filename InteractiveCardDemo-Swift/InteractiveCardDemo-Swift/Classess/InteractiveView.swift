//
//  InteractiveView.swift
//  InteractiveCardDemo-Swift
//
//  Created by Kitten Yang on 1/6/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

let SCREENWIDTH  = UIScreen.main.bounds.width
let SCREENHEIGHT = UIScreen.main.bounds.height
//let ANIMATEDURATION = 0.5
//let ANIMATEDAMPING = 0.7
//let SCROLLDISTANCE = 200.0

struct InteractiveOptions {
    var duration: TimeInterval = 0.3
    var damping: CGFloat = 0.6
    var scrollDistance: CGFloat = 100.0
}

class InteractiveView: UIImageView {

    var _option: InteractiveOptions
    var initialPoint: CGPoint = CGPoint.zero
    var dimmingView: UIView?
    var gestureView: UIView? {
        didSet{
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(InteractiveView.panGestureRecognized(_:)))
            gestureView?.addGestureRecognizer(panGesture)
        }
    }
    
    init(image: UIImage?, option: InteractiveOptions) {
        _option = option
        super.init(image: image)
        contentMode = .scaleAspectFill
        layer.cornerRadius = 7.0
        layer.masksToBounds = true
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        initialPoint = center
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc fileprivate func panGestureRecognized(_ pan: UIPanGestureRecognizer) {
        
        var factorOfAngle: CGFloat = 0.0
        var factorOfScale: CGFloat = 0.0
        let transition = pan.translation(in: superview)
        
        if pan.state == .began {
            
        } else if pan.state == .changed {
            center = CGPoint(x: initialPoint.x, y: initialPoint.y + transition.y)
            let Y = min(CGFloat(_option.scrollDistance), max(0, abs(transition.y)))
            //一个开口向下,顶点(SCROLLDISTANCE/2,1),过(0,0),(SCROLLDISTANCE,0)的二次函数
            factorOfAngle = max(0.0,-4.0/(CGFloat(_option.scrollDistance)*CGFloat(_option.scrollDistance))*Y*(Y-CGFloat(_option.scrollDistance)));
            //一个开口向下,顶点(SCROLLDISTANCE,1),过(0,0),(2*SCROLLDISTANCE,0)的二次函数
            factorOfScale = max(0,-1/(CGFloat(_option.scrollDistance)*CGFloat(_option.scrollDistance))*Y*(Y-2*CGFloat(_option.scrollDistance)));
            var t = CATransform3DIdentity
            t.m34 = -1.0/1000
            t = CATransform3DRotate(t,factorOfAngle*(CGFloat(M_PI/5)), transition.y>0 ? -1 : 1, 0, 0)
            t = CATransform3DScale(t, 1-factorOfScale*0.2, 1-factorOfScale*0.2, 0)
            layer.transform = t
            dimmingView?.alpha = 1.0 - Y / _option.scrollDistance
            
        } else if pan.state == .ended || pan.state == .cancelled {
            UIView.animate(withDuration: _option.duration, delay: 0.0, usingSpringWithDamping: _option.damping, initialSpringVelocity: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                    self.layer.transform = CATransform3DIdentity
                    self.center = self.initialPoint
                    self.dimmingView?.alpha = 1.0
                }, completion: nil)
        }
    }

}
