//
//  CuteView.swift
//  CuteView-Swift
//
//  Created by Kitten Yang on 1/19/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

struct BubbleOptions {
    var text: String = ""
    var bubbleWidth: CGFloat = 0.0
    var viscosity: CGFloat = 0.0
    var bubbleColor: UIColor = UIColor.white
}

class CuteView: UIView {
    
    var frontView: UIView?
    var bubbleOptions: BubbleOptions!{
        didSet{
            bubbleLabel.text = bubbleOptions.text
        }
    }
    fileprivate var bubbleLabel: UILabel!
    fileprivate var containerView: UIView!
    fileprivate var cutePath: UIBezierPath!
    fileprivate var fillColorForCute: UIColor!
    fileprivate var animator: UIDynamicAnimator!
    fileprivate var snap: UISnapBehavior!
    fileprivate var backView: UIView!
    fileprivate var shapeLayer: CAShapeLayer!
    
    fileprivate var r1: CGFloat = 0.0
    fileprivate var r2: CGFloat = 0.0
    fileprivate var x1: CGFloat = 0.0
    fileprivate var y1: CGFloat = 0.0
    fileprivate var x2: CGFloat = 0.0
    fileprivate var y2: CGFloat = 0.0
    fileprivate var centerDistance: CGFloat = 0.0
    fileprivate var cosDigree: CGFloat = 0.0
    fileprivate var sinDigree: CGFloat = 0.0
    
    fileprivate var pointA = CGPoint.zero
    fileprivate var pointB = CGPoint.zero
    fileprivate var pointC = CGPoint.zero
    fileprivate var pointD = CGPoint.zero
    fileprivate var pointO = CGPoint.zero
    fileprivate var pointP = CGPoint.zero
    
    fileprivate var initialPoint: CGPoint = CGPoint.zero
    fileprivate var oldBackViewFrame: CGRect = CGRect.zero
    fileprivate var oldBackViewCenter: CGPoint = CGPoint.zero

    
    init(point: CGPoint, superView: UIView, options: BubbleOptions) {
        super.init(frame: CGRect(x: point.x, y: point.y, width: options.bubbleWidth, height: options.bubbleWidth))
        bubbleOptions = options
        initialPoint = point
        containerView = superView
        containerView.addSubview(self)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func drawRect() {
        guard let frontView = frontView else{
            return
        }
        x1 = backView.center.x
        y1 = backView.center.y
        x2 = frontView.center.x
        y2 = frontView.center.y
        
        let xtimesx = (x2-x1)*(x2-x1)
        centerDistance = sqrt(xtimesx + (y2-y1)*(y2-y1))
        if centerDistance == 0 {
            cosDigree = 1
            sinDigree = 0
        }else{
            cosDigree = (y2-y1)/centerDistance
            sinDigree = (x2-x1)/centerDistance
        }
        
        r1 = oldBackViewFrame.size.width / 2 - centerDistance/bubbleOptions.viscosity
        
        pointA = CGPoint(x: x1-r1*cosDigree, y: y1+r1*sinDigree) // A
        pointB = CGPoint(x: x1+r1*cosDigree, y: y1-r1*sinDigree) // B
        pointD = CGPoint(x: x2-r2*cosDigree, y: y2+r2*sinDigree) // D
        pointC = CGPoint(x: x2+r2*cosDigree, y: y2-r2*sinDigree) // C
        pointO = CGPoint(x: pointA.x + (centerDistance / 2)*sinDigree, y: pointA.y + (centerDistance / 2)*cosDigree)
        pointP = CGPoint(x: pointB.x + (centerDistance / 2)*sinDigree, y: pointB.y + (centerDistance / 2)*cosDigree)
        
        backView.center = oldBackViewCenter;
        backView.bounds = CGRect(x: 0, y: 0, width: r1*2, height: r1*2);
        backView.layer.cornerRadius = r1;
        
        cutePath = UIBezierPath()
        cutePath.move(to: pointA)
        cutePath.addQuadCurve(to: pointD, controlPoint: pointO)
        cutePath.addLine(to: pointC)
        cutePath.addQuadCurve(to: pointB, controlPoint: pointP)
        cutePath.move(to: pointA)
        
        if backView.isHidden == false {
            shapeLayer.path = cutePath.cgPath
            shapeLayer.fillColor = fillColorForCute.cgColor
            containerView.layer.insertSublayer(shapeLayer, below: frontView.layer)
        }

    }
    
    fileprivate func setUp() {
        shapeLayer = CAShapeLayer()
        backgroundColor = UIColor.clear
        frontView = UIView(frame: CGRect(x: initialPoint.x, y: initialPoint.y, width: bubbleOptions.bubbleWidth, height: bubbleOptions.bubbleWidth))
        guard let frontView = frontView else {
            print("frontView is nil")
            return
        }
        r2 = frontView.bounds.size.width / 2.0
        frontView.layer.cornerRadius = r2
        frontView.backgroundColor = bubbleOptions.bubbleColor
        
        backView = UIView(frame: frontView.frame)
        r1 = backView.bounds.size.width / 2
        backView.layer.cornerRadius = r1
        backView.backgroundColor = bubbleOptions.bubbleColor
        
        bubbleLabel = UILabel()
        bubbleLabel.frame = CGRect(x: 0, y: 0, width: frontView.bounds.width, height: frontView.bounds.height)
        bubbleLabel.textColor = UIColor.white
        bubbleLabel.textAlignment = .center
        bubbleLabel.text = bubbleOptions.text
        
        frontView.insertSubview(bubbleLabel, at: 0)
        containerView.addSubview(backView)
        containerView.addSubview(frontView)
        
        x1 = backView.center.x
        y1 = backView.center.y
        x2 = frontView.center.x
        y2 = frontView.center.y
        
        pointA = CGPoint(x: x1-r1,y: y1);   // A
        pointB = CGPoint(x: x1+r1, y: y1);  // B
        pointD = CGPoint(x: x2-r2, y: y2);  // D
        pointC = CGPoint(x: x2+r2, y: y2);  // C
        pointO = CGPoint(x: x1-r1,y: y1);   // O
        pointP = CGPoint(x: x2+r2, y: y2);  // P
        
        oldBackViewFrame = backView.frame
        oldBackViewCenter = backView.center
        
        backView.isHidden = true //为了看到frontView的气泡晃动效果，需要暂时隐藏backView
        addAniamtionLikeGameCenterBubble()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(CuteView.handleDragGesture(_:)))
        frontView.addGestureRecognizer(panGesture)
    }
    
    @objc fileprivate func handleDragGesture(_ ges: UIPanGestureRecognizer) {
        let dragPoint = ges.location(in: containerView)
        if ges.state == .began {
            // 不给r1赋初始值的话，如果第一次拖动使得r1少于6，第二次拖动就直接隐藏绘制路径了
            r1 = oldBackViewFrame.width / 2
            backView.isHidden = false
            fillColorForCute = bubbleOptions.bubbleColor
            removeAniamtionLikeGameCenterBubble()
        } else if ges.state == .changed {
            frontView?.center = dragPoint
            if r1 <= 6 {
                fillColorForCute = UIColor.clear
                backView.isHidden = true
                shapeLayer.removeFromSuperlayer()
            }
            drawRect()
        } else if ges.state == .ended || ges.state == .cancelled || ges.state == .failed {
            backView.isHidden = true
            fillColorForCute = UIColor.clear
            shapeLayer.removeFromSuperlayer()
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: UIViewAnimationOptions(), animations: { [weak self] () -> Void in
                if let strongsSelf = self {
                    strongsSelf.frontView?.center = strongsSelf.oldBackViewCenter
                }
                }, completion: { [weak self] (finished) -> Void in
                    if let strongsSelf = self {
                        strongsSelf.addAniamtionLikeGameCenterBubble()
                    }
            })
        }
    }
    
}

// MARK : GameCenter Bubble Animation

extension CuteView {
    fileprivate func addAniamtionLikeGameCenterBubble() {
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.calculationMode = kCAAnimationPaced

        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.isRemovedOnCompletion = false
        pathAnimation.repeatCount = Float.infinity
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        pathAnimation.duration = 5.0
        
        let curvedPath = CGMutablePath()
        guard let frontView = frontView else {
            print("frontView is nil!")
            return
        }
        let circleContainer = frontView.frame.insetBy(dx: frontView.bounds.width / 2 - 3, dy: frontView.bounds.size.width / 2 - 3)
        curvedPath.addEllipse(in: circleContainer)
        pathAnimation.path = curvedPath
        frontView.layer.add(pathAnimation, forKey: "circleAnimation")
        
        let scaleX = CAKeyframeAnimation(keyPath: "transform.scale.x")
        scaleX.duration = 1.0
        scaleX.values = [NSNumber(value: 1.0 as Double),NSNumber(value: 1.1 as Double),NSNumber(value: 1.0 as Double)]
        scaleX.keyTimes = [NSNumber(value: 0.0 as Double), NSNumber(value: 0.5 as Double), NSNumber(value: 1.0 as Double)]
        scaleX.repeatCount = Float.infinity
        scaleX.autoreverses = true
        
        scaleX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        frontView.layer.add(scaleX, forKey: "scaleXAnimation")
        
        let scaleY = CAKeyframeAnimation(keyPath: "transform.scale.y")
        scaleY.duration = 1.5
        scaleY.values = [NSNumber(value: 1.0 as Double),NSNumber(value: 1.1 as Double),NSNumber(value: 1.0 as Double)]
        scaleY.keyTimes = [NSNumber(value: 0.0 as Double), NSNumber(value: 0.5 as Double), NSNumber(value: 1.0 as Double)]
        scaleY.repeatCount = Float.infinity
        scaleY.autoreverses = true
        scaleY.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        frontView.layer.add(scaleY, forKey: "scaleYAnimation")

    }

    fileprivate func removeAniamtionLikeGameCenterBubble() {
        if let frontView = frontView {
            frontView.layer.removeAllAnimations()
        }
    }
    
}
