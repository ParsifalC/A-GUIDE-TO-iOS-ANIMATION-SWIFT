//
//  DynamicView.swift
//  DynamicActionBlockDemo-Swift
//
//  Created by Kitten Yang on 1/2/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class DynamicView: UIView {
    
    fileprivate var panView: UIView?
    fileprivate var ballImageView: UIImageView?
    fileprivate var topView: UIView?
    fileprivate var middleView: UIView?
    fileprivate var bottomView: UIView?
    fileprivate var animator: UIDynamicAnimator?
    fileprivate var panGravity: UIGravityBehavior?
    fileprivate var viewsGravity: UIGravityBehavior?
    fileprivate var shapeLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpViews(){
        panView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height/2))
        panView?.alpha = 0.5
        addSubview(panView!)
        
        panView?.layer.shadowOffset = CGSize(width: -1, height: 2)
        panView?.layer.shadowOpacity = 0.5
        panView?.layer.shadowRadius = 5.0
        panView?.layer.shadowColor = UIColor.black.cgColor
        panView?.layer.masksToBounds = false
        panView?.layer.shadowPath = UIBezierPath(rect: (panView?.bounds)!).cgPath
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(DynamicView.handlePanGesture(_:)))
        panView?.addGestureRecognizer(pan)
        
        let grd = CAGradientLayer()
        grd.frame = (panView?.frame)!
        grd.colors = [UIColor(red: 0.0, green: 191/255.0, blue: 255/255.0, alpha: 1.0).cgColor,UIColor.white.cgColor]
        panView?.layer.addSublayer(grd)
        
        ballImageView = UIImageView(frame: CGRect(x: bounds.width/2 - 30, y: bounds.height/1.5, width: 60, height: 60))
        ballImageView?.image = UIImage(named: "ball")
        addSubview(ballImageView!)
        ballImageView?.layer.shadowOffset = CGSize(width: -4, height: 4)
        ballImageView?.layer.shadowOpacity = 0.5
        ballImageView?.layer.shadowRadius = 5.0
        ballImageView?.layer.shadowColor = UIColor.black.cgColor
        ballImageView?.layer.masksToBounds = false
        
        // middleView
        middleView = UIView(frame: CGRect(x: (ballImageView?.center.x)!-15, y: 200, width: 30, height: 30))
        middleView?.backgroundColor = UIColor.gray
        addSubview(middleView!)
        middleView?.center = CGPoint(x: (middleView?.center.x)!, y: (ballImageView?.center.y)! - (panView?.center.y)! + 15)

        // topView
        topView = UIView(frame: CGRect(x: (ballImageView?.center.x)! - 15, y: 200, width: 30, height: 30))
        topView?.backgroundColor = UIColor.gray
        addSubview(topView!)
        topView?.center = CGPoint(x: (topView?.center.x)!, y: (middleView?.center.y)! - (panView?.center.y)! + (panView?.center.y)!/2)
        
        // bottomView
        bottomView = UIView(frame: CGRect(x: (ballImageView?.center.x)! - 15, y: 200, width: 30, height: 30))
        bottomView?.backgroundColor = UIColor.gray
        addSubview(bottomView!)
        bottomView?.center = CGPoint(x: (bottomView?.center.x)!, y: (middleView?.center.y)! - (panView?.center.y)! + (panView?.center.y)! * 1.5)

        setUpBehaviors()
    }
    
    fileprivate func setUpBehaviors(){
        animator = UIDynamicAnimator(referenceView: self)
        panGravity = UIGravityBehavior(items: [panView!])
        animator?.addBehavior(panGravity!)
        
        viewsGravity = UIGravityBehavior(items: [ballImageView!,topView!,bottomView!])
        animator?.addBehavior(viewsGravity!)
        
        viewsGravity?.action = { [weak self] () in
            print("Acton!")
            if let strongSelf = self{
                let path = UIBezierPath()
                path.move(to: (strongSelf.panView?.center)!)
                path.addCurve(to: (strongSelf.ballImageView?.center)!, controlPoint1: (strongSelf.topView?.center)!, controlPoint2: (strongSelf.bottomView?.center)!)
                
                if strongSelf.shapeLayer == nil{
                    strongSelf.shapeLayer = CAShapeLayer()
                    strongSelf.shapeLayer?.fillColor = UIColor.clear.cgColor
                    strongSelf.shapeLayer?.strokeColor = UIColor(red: 224.0/255.0, green: 0.0, blue: 35.0/255.0, alpha: 1.0).cgColor
                    strongSelf.shapeLayer?.lineWidth = 5.0
                    
                    strongSelf.shapeLayer?.shadowOffset = CGSize(width: -1, height: 2)
                    strongSelf.shapeLayer?.shadowOpacity = 0.5
                    strongSelf.shapeLayer?.shadowRadius = 5.0
                    strongSelf.shapeLayer?.shadowColor = UIColor.black.cgColor
                    strongSelf.shapeLayer?.masksToBounds = false
                    strongSelf.layer.insertSublayer(strongSelf.shapeLayer!, below: strongSelf.ballImageView?.layer)
                }
                strongSelf.shapeLayer?.path = path.cgPath
            }
        }
        
        // MARK : UICollisionBehavior
        
        let collision = UICollisionBehavior(items: [panView!])
        collision.addBoundary(withIdentifier: "Left" as NSCopying, from: CGPoint(x: -1, y: 0), to: CGPoint(x: -1, y: bounds.size.height))
        collision.addBoundary(withIdentifier: "Right" as NSCopying, from: CGPoint(x: bounds.width+1, y: 0), to:CGPoint(x: bounds.width+1, y: bounds.height))
        collision.addBoundary(withIdentifier: "Middle" as NSCopying, from: CGPoint(x: 0, y: bounds.height/2), to: CGPoint(x: bounds.width, y: bounds.height/2))
        animator?.addBehavior(collision)
        
        // MARK : UIAttachmentBehaviors
        
        let attach1 = UIAttachmentBehavior(item: panView!, attachedTo: topView!)
        animator?.addBehavior(attach1)
        
        let attach2 = UIAttachmentBehavior(item: topView!, attachedTo: bottomView!)
        animator?.addBehavior(attach2)
        
        let attach3 = UIAttachmentBehavior(item: bottomView!, offsetFromCenter: UIOffset(horizontal: 0, vertical: 0), attachedTo: ballImageView!, offsetFromCenter: UIOffset(horizontal: 0, vertical: -ballImageView!.bounds.height/2))
        animator?.addBehavior(attach3)

        // MARK : UIDynamicItemBehavior
        
        let panItem = UIDynamicItemBehavior(items: [panView!,topView!,bottomView!,ballImageView!])
        panItem.elasticity = 0.5
        animator?.addBehavior(panItem)
    }
    
    @objc fileprivate func handlePanGesture(_ gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: gesture.view)
        if !((gesture.view?.center.y)! + translation.y > bounds.height/2 - (gesture.view?.bounds.height)!/2){
            gesture.view?.center = CGPoint(x: (gesture.view?.center.x)!, y: (gesture.view?.center.y)! + translation.y)
            gesture.setTranslation(CGPoint(x:0, y:0), in: gesture.view)
        }
        
        if let animator = animator{
            switch gesture.state {
            case .began: animator.removeBehavior(panGravity!)
            case .changed:break;
            case .ended: animator.addBehavior(panGravity!)
            default:break
            }
            animator.updateItem(usingCurrentState: gesture.view!)
        }
    }
    
}
