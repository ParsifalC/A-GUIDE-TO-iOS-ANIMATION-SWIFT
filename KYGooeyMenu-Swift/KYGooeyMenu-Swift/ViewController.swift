//
//  ViewController.swift
//  KYGooeyMenu-Swift
//
//  Created by Kitten Yang on 1/7/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var menu: Menu?
    @IBOutlet weak var debugSwitcher: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu = Menu(frame: CGRect(x: view.center.x-50, y: view.frame.size.height - 200, width: 100, height: 100))
        view.addSubview(menu!)
        debugSwitcher.addTarget(self, action: #selector(ViewController.showDedug(_:)), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc fileprivate func showDedug(_ sender: UISwitch) {
        if sender.isOn {
            menu?.menuLayer.showDebug = true
        } else {
            menu?.menuLayer.showDebug = false
        }
        menu?.menuLayer.setNeedsDisplay()
    }

}

