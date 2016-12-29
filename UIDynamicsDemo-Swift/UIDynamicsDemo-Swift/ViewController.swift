//
//  ViewController.swift
//  UIDynamicsDemo-Swift
//
//  Created by Kitten Yang on 1/16/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var restoreButton: UIButton!
    fileprivate var lockScreenView: UIImageView!
    fileprivate var animator: UIDynamicAnimator!
    fileprivate var gravityBehaviour: UIGravityBehavior!
    fileprivate var pushBehavior: UIPushBehavior!
    fileprivate var attachmentBehaviour: UIAttachmentBehavior!
    fileprivate var itemBehaviour: UIDynamicItemBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lockScreenView = UIImageView(frame: view.bounds)
        lockScreenView.image = UIImage(named: "lockScreen")
        lockScreenView.contentMode = .scaleToFill
        lockScreenView.isUserInteractionEnabled = true
        view.addSubview(lockScreenView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapOnIt(_:)))
        lockScreenView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.panOnIt(_:)))
        lockScreenView.addGestureRecognizer(panGesture)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animator = UIDynamicAnimator(referenceView: view)
        let collisionBehaviour = UICollisionBehavior(items: [lockScreenView])
        collisionBehaviour.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: -lockScreenView.frame.height, left: 0, bottom: 0, right: 0))
        animator.addBehavior(collisionBehaviour)
        
        gravityBehaviour = UIGravityBehavior(items: [lockScreenView])
        gravityBehaviour.gravityDirection = CGVector(dx: 0.0, dy: 1.0)
        gravityBehaviour.magnitude = 2.6
        animator.addBehavior(gravityBehaviour)
        
        pushBehavior = UIPushBehavior(items: [lockScreenView], mode: .instantaneous)
        pushBehavior.magnitude = 2.0
        pushBehavior.angle = CGFloat(M_PI)
        animator.addBehavior(pushBehavior)
        
        itemBehaviour = UIDynamicItemBehavior(items: [lockScreenView])
        itemBehaviour.elasticity = 0.35
        animator.addBehavior(itemBehaviour)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc fileprivate func tapOnIt(_ tapGes: UITapGestureRecognizer) {
        pushBehavior.pushDirection = CGVector(dx: 0.0, dy: -80.0)
        pushBehavior.active = true
    }
    
    @objc fileprivate func panOnIt(_ panGes: UIPanGestureRecognizer) {
        let location = CGPoint(x: lockScreenView.frame.midX, y: panGes.location(in: view).y)
        if panGes.state == .began {
            animator.removeBehavior(gravityBehaviour)
            attachmentBehaviour = UIAttachmentBehavior(item: lockScreenView, attachedToAnchor: location)
            animator.addBehavior(attachmentBehaviour)
        } else if panGes.state == .changed {
            attachmentBehaviour.anchorPoint = location
        } else if panGes.state == .ended {
            let velocity = panGes.velocity(in: lockScreenView)
            animator.removeBehavior(attachmentBehaviour)
            attachmentBehaviour = nil
            if velocity.y < -1300 {
                animator.removeBehavior(gravityBehaviour)
                animator.removeBehavior(itemBehaviour)
                gravityBehaviour = nil
                itemBehaviour = nil

                //gravity
                gravityBehaviour = UIGravityBehavior(items: [lockScreenView])
                gravityBehaviour.gravityDirection = CGVector(dx: 0.0, dy: -1.0)
                gravityBehaviour.magnitude = 2.6
                animator.addBehavior(gravityBehaviour)
                
                //item
                itemBehaviour = UIDynamicItemBehavior(items: [lockScreenView])
                itemBehaviour.elasticity = 0.0
                animator.addBehavior(itemBehaviour)
                
                //push
                pushBehavior.pushDirection = CGVector(dx: 0.0, dy: -200.0)
                pushBehavior.active = true
            } else {
                restore(restoreButton)
            }
        
        }
        
    }
    
    @IBAction func restore(_ sender: AnyObject) {

        animator.removeBehavior(gravityBehaviour)
        animator.removeBehavior(itemBehaviour)
        gravityBehaviour = nil
        itemBehaviour  = nil
    
        //gravity
        gravityBehaviour = UIGravityBehavior(items: [lockScreenView])
        gravityBehaviour.gravityDirection = CGVector(dx: 0.0, dy: 1.0)
        gravityBehaviour.magnitude = 2.6
        
        //item
        itemBehaviour = UIDynamicItemBehavior(items: [lockScreenView])
        itemBehaviour.elasticity = 0.35
        animator.addBehavior(itemBehaviour)
        animator.addBehavior(gravityBehaviour)
        
    }

}
