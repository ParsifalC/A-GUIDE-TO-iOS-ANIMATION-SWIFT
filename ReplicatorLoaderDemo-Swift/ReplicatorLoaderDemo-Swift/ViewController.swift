//
//  ViewController.swift
//  ReplicatorLoaderDemo-Swift
//
//  Created by Kitten Yang on 2/3/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pulseLoader = ReplicatorLoader(frame: CGRect(origin: view.center, size: CGSize(width: 100, height: 100)), type: .pulse(option: Options(color: UIColor.red, alpha: 0.3)))
        pulseLoader.center = view.center
        view.addSubview(pulseLoader)
        
        let dotsFlipLoader = ReplicatorLoader(frame: CGRect(origin: view.center, size: CGSize(width: 100, height: 100)), type: .dotsFlip(option: Options(color: UIColor.red, alpha: 0.3)))
        dotsFlipLoader.center = CGPoint(x: pulseLoader.center.x, y: pulseLoader.center.y - CGFloat(120.0))
        view.addSubview(dotsFlipLoader)
        
        let gridScaleLoader = ReplicatorLoader(frame: CGRect(origin: view.center, size: CGSize(width: 100, height: 100)), type: .gridScale(option: Options(color: UIColor.red, alpha: 0.3)))
        gridScaleLoader.center = CGPoint(x: pulseLoader.center.x, y: pulseLoader.center.y + CGFloat(120.0))
        view.addSubview(gridScaleLoader)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}

