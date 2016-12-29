//
//  SlideMenuButton.swift
//  GooeySlideMenuDemo-Swift
//
//  Created by Kitten Yang on 1/3/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

struct MenuButtonOptions {
    var title: String
    var buttonColor: UIColor
    var buttonClickBlock: ()->()
}

class SlideMenuButton: UIView {

    fileprivate var _option: MenuButtonOptions
    
    init(option: MenuButtonOptions) {
        _option = option
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.addRect(rect)
        _option.buttonColor.set()
        context?.fillPath()
        
        let roundedRectanglePath = UIBezierPath(roundedRect: rect.insetBy(dx: 1, dy: 1), cornerRadius: rect.height / 2)
        _option.buttonColor.setFill()
        roundedRectanglePath.fill()
        UIColor.white.setStroke()
        roundedRectanglePath.lineWidth = 1
        roundedRectanglePath.stroke()

        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = .center
        let attr = [NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName: UIFont.systemFont(ofSize: 24.0),NSForegroundColorAttributeName: UIColor.white]
        let size = _option.title.size(attributes: attr)
        
        let r = CGRect(x: rect.origin.x,
            y: rect.origin.y + (rect.size.height - size.height)/2.0,
            width: rect.size.width,
            height: size.height)
        _option.title.draw(in: r, withAttributes: attr)

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let touch = touch {
            let tapCount = touch.tapCount
            switch (tapCount) {
                case 1: _option.buttonClickBlock()
                default: break
            }
        }
    }
}
