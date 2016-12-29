//
//  SecondViewController.swift
//  KYPingTransition-Swift
//
//  Created by Kitten Yang on 1/8/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    fileprivate var percentTransition: UIPercentDrivenInteractiveTransition?
    
    // MARK : Lift Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let edgeGes = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(SecondViewController.edgePan(_:)))
        edgeGes.edges = .left
        view.addGestureRecognizer(edgeGes)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK : Gesture Method
    
    @objc fileprivate func edgePan(_ recognizer: UIPanGestureRecognizer) {

        var per = recognizer.translation(in: view).x / view.bounds.size.width
        per = min(1.0, max(0.0, per))
        
        if recognizer.state == .began {
            percentTransition = UIPercentDrivenInteractiveTransition()
            navigationController?.popViewController(animated: true)
        } else if recognizer.state == .changed {
            percentTransition?.update(per)
        } else if recognizer.state == .cancelled || recognizer.state == .ended {
            if per > 0.3 {
                percentTransition?.finish()
            } else {
                percentTransition?.cancel()
            }
            percentTransition = nil
        }
    }
    
    
    @IBAction func didTapBackButton(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
}

extension SecondViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return percentTransition
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            let pingInvert = PingInvertTransition()
            return pingInvert
        } else {
            return nil
        }
    }
}


