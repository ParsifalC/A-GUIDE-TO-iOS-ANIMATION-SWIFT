
//
//  DownloadButton.swift
//  CADemos-Swift
//
//  Created by Kitten Yang on 12/30/15.
//  Copyright © 2015 Kitten Yang. All rights reserved.
//

import UIKit

let kRadiusShrinkAnim = "cornerRadiusShrinkAnim"
let kRadiusExpandAnim = "radiusExpandAnimation"
let kProgressBarAnimation = "progressBarAnimation"
let kCheckAnimation = "checkAnimation"

class DownloadButton: UIView, CAAnimationDelegate {

    var progressBarHeight: CGFloat = 0.0
    var progressBarWidth: CGFloat = 0.0
    fileprivate var originframe: CGRect = CGRect.zero;
    fileprivate var animating: Bool = false;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    
    fileprivate func setUpViews(){
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(DownloadButton.handleButtonDidTapped(_:)))
        addGestureRecognizer(tapGes)
    }
    
    @objc fileprivate func handleButtonDidTapped(_ gesture: UITapGestureRecognizer){
        if animating {
            return
        }
        animating = true
        originframe = frame
        if let subLayers = layer.sublayers{
            for subLayer in subLayers{
                subLayer.removeFromSuperlayer()
            }
        }
        backgroundColor = UIColor(red: 0.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
        layer.cornerRadius = progressBarHeight / 2
        let radiusShrinkAnimation = CABasicAnimation(keyPath: "cornerRadius")
        radiusShrinkAnimation.duration = 0.2
        radiusShrinkAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        radiusShrinkAnimation.fromValue = originframe.height / 2
        radiusShrinkAnimation.delegate = self
        layer.add(radiusShrinkAnimation, forKey: kRadiusShrinkAnim)
    }
    
    fileprivate func progressBarAnimation() {
        let progressLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: progressBarHeight / 2, y: self.frame.height / 2))
        path.addLine(to: CGPoint(x: bounds.size.width - progressBarHeight / 2, y: bounds.size.height / 2))
        
        progressLayer.path = path.cgPath
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.lineWidth = progressBarHeight - 6
        progressLayer.lineCap = kCALineCapRound
        layer.addSublayer(progressLayer)
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 2.0
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathAnimation.delegate = self
        pathAnimation.setValue(kProgressBarAnimation, forKey: "animationName")
        progressLayer.add(pathAnimation, forKey: nil)
    }
    
    fileprivate func checkAnimation() {
        let checkLayer = CAShapeLayer()
        let path = UIBezierPath()
        let rectInCircle = self.bounds.insetBy(dx: self.bounds.size.width*(1-1/sqrt(2.0))/2, dy: self.bounds.size.width*(1-1/sqrt(2.0))/2)
        path.move(to: CGPoint(x: rectInCircle.origin.x + rectInCircle.size.width/9, y: rectInCircle.origin.y + rectInCircle.size.height*2/3))
        path.addLine(to: CGPoint(x: rectInCircle.origin.x + rectInCircle.size.width/3,y: rectInCircle.origin.y + rectInCircle.size.height*9/10))
        path.addLine(to: CGPoint(x: rectInCircle.origin.x + rectInCircle.size.width*8/10, y: rectInCircle.origin.y + rectInCircle.size.height*2/10))
        
        checkLayer.path = path.cgPath
        checkLayer.fillColor = UIColor.clear.cgColor
        checkLayer.strokeColor = UIColor.white.cgColor
        checkLayer.lineWidth = 10.0
        checkLayer.lineCap = kCALineCapRound
        checkLayer.lineJoin = kCALineJoinRound
        self.layer.addSublayer(checkLayer)

        let checkAnimation = CABasicAnimation(keyPath: "strokeEnd")
        checkAnimation.duration = 0.3;
        checkAnimation.fromValue = 0.0
        checkAnimation.toValue = 1.0
        checkAnimation.delegate = self
        checkAnimation.setValue(kCheckAnimation, forKey:"animationName")
        checkLayer.add(checkAnimation,forKey:nil)
    }
}

extension DownloadButton {
    
    // MARK : CAAnimationDelegate
    
    func animationDidStart(_ anim: CAAnimation) {
        if anim.isEqual(self.layer.animation(forKey: kRadiusShrinkAnim)) {
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.bounds = CGRect(x: 0, y: 0, width: self.progressBarWidth, height: self.progressBarHeight)
                }, completion: { (finished) -> Void in
                    self.layer.removeAllAnimations()
                    self.progressBarAnimation()
            })
        }else if anim.isEqual(self.layer.animation(forKey: kRadiusExpandAnim)){
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.bounds = CGRect(x: 0, y: 0, width: self.originframe.width, height: self.originframe.height)
                self.backgroundColor = UIColor(red: 0.1803921568627451, green: 0.8, blue: 0.44313725490196076, alpha: 1.0)
                }, completion: { (finished) -> Void in
                    self.layer.removeAllAnimations()
                    self.checkAnimation()
                    self.animating = false
            })
        }
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let animationName = anim.value(forKey: "animationName"),
            (animationName as AnyObject).isEqual(to: kProgressBarAnimation) {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    if let sublayers = self.layer.sublayers{
                        for subLayer in sublayers {
                            subLayer.opacity = 0.0
                        }
                    }
                    }, completion: { (finished) -> Void in
                        if let sublayers = self.layer.sublayers{
                            for sublayer in sublayers {
                                sublayer.removeFromSuperlayer()
                            }
                        }
                        self.layer.cornerRadius = self.originframe.height / 2
                        let radiusExpandAnimation = CABasicAnimation(keyPath: "cornerRadius")
                        radiusExpandAnimation.duration = 0.2
                        radiusExpandAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                        radiusExpandAnimation.fromValue = self.progressBarHeight / 2
                        radiusExpandAnimation.delegate = self
                        self.layer.add(radiusExpandAnimation, forKey: kRadiusExpandAnim)
                })
        }
    }
}

