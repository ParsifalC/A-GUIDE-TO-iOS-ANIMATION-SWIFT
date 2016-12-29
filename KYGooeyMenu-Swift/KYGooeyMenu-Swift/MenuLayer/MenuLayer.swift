//
//  MenuLayer.swift
//  KYGooeyMenu-Swift
//
//  Created by Kitten Yang on 1/7/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

enum STATE {
    case state1
    case state2
    case state3
}

let OFF: CGFloat = 30.0

class MenuLayer: CALayer {
    var showDebug: Bool = false
    var animationState: STATE = .state1
    var xAxisPercent: CGFloat = 0.0
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        if let lastLayer = layer as? MenuLayer {
            showDebug = lastLayer.showDebug
            xAxisPercent = lastLayer.xAxisPercent
            animationState = lastLayer.animationState
        }
    }

    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "xAxisPercent" {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    override func draw(in ctx: CGContext) {
        print("acting")
        let real_rect = self.frame.insetBy(dx: OFF,dy: OFF)
        let offset = real_rect.size.width / 3.6
        let center = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        var moveDistance_1: CGFloat
        var moveDistance_2: CGFloat
        var top_left: CGPoint
        var top_center: CGPoint
        var top_right: CGPoint
        
        switch animationState {
        case .state1:
            moveDistance_1 = xAxisPercent*(real_rect.size.width/2 - offset)/2
            top_left   =  CGPoint(x: center.x-offset-moveDistance_1*2, y: OFF)
            top_center =  CGPoint(x: center.x-moveDistance_1, y: OFF)
            top_right  =  CGPoint(x: center.x+offset, y: OFF)
        case .state2:
            var hightFactor: CGFloat
            if (xAxisPercent >= 0.2) {
                hightFactor = 1-xAxisPercent;
            }else{
                hightFactor = xAxisPercent;
            }
            moveDistance_1 = (real_rect.size.width/2 - offset)/2
            moveDistance_2 = xAxisPercent*(real_rect.size.width/3)
            top_left   =  CGPoint(x: center.x-offset-moveDistance_1*2 + moveDistance_2, y: OFF)
            top_center =  CGPoint(x: center.x-moveDistance_1 + moveDistance_2, y: OFF)
            top_right  =  CGPoint(x: center.x+offset+moveDistance_2, y: OFF)
        case .state3:
            moveDistance_1 = (real_rect.size.width/2 - offset)/2
            moveDistance_2 = (real_rect.size.width/3)
            let gooeyDis_1 = xAxisPercent*(center.x-offset-moveDistance_1*2 + moveDistance_2-(center.x-offset))
            let gooeyDis_2 = xAxisPercent*(center.x-moveDistance_1 + moveDistance_2-(center.x))
            let gooeyDis_3 = xAxisPercent*(center.x+offset+moveDistance_2-(center.x+offset))
            
            top_left   =  CGPoint(x: center.x-offset-moveDistance_1*2 + moveDistance_2 - gooeyDis_1, y: OFF)
            top_center =  CGPoint(x: center.x-moveDistance_1 + moveDistance_2 - gooeyDis_2, y: OFF)
            top_right  =  CGPoint(x: center.x+offset+moveDistance_2 - gooeyDis_3, y: OFF)
        }
        
        let right_top    =  CGPoint(x: real_rect.maxX, y: center.y-offset)
        let right_center =  CGPoint(x: real_rect.maxX, y: center.y)
        let right_bottom =  CGPoint(x: real_rect.maxX, y: center.y+offset)
        
        let bottom_left   =  CGPoint(x: center.x-offset, y: real_rect.maxY)
        let bottom_center =  CGPoint(x: center.x, y: real_rect.maxY)
        let bottom_right  =  CGPoint(x: center.x+offset, y: real_rect.maxY)
        
        let left_top    =  CGPoint(x: OFF, y: center.y-offset)
        let left_center =  CGPoint(x: OFF, y: center.y)
        let left_bottom =  CGPoint(x: OFF, y: center.y+offset)
        
        let circlePath = UIBezierPath()
        circlePath.move(to: top_center)
        circlePath.addCurve(to: right_center, controlPoint1: top_right, controlPoint2: right_top)
        circlePath.addCurve(to: bottom_center, controlPoint1: right_bottom, controlPoint2: bottom_right)
        circlePath.addCurve(to: left_center, controlPoint1: bottom_left, controlPoint2: left_bottom)
        circlePath.addCurve(to: top_center, controlPoint1: left_top, controlPoint2: top_left)
        circlePath.close()
        
        ctx.addPath(circlePath.cgPath)
        ctx.setFillColor(UIColor(red: 29.0/255.0, green: 163.0/255.0, blue: 1.0, alpha: 1.0).cgColor)
        ctx.fillPath()

        if showDebug {
            ctx.setFillColor(UIColor.blue.cgColor)
            
            showPoint(top_left, context: ctx)
            showPoint(top_center, context: ctx)
            showPoint(top_right, context: ctx)

            showPoint(right_top, context: ctx)
            showPoint(right_center, context: ctx)
            showPoint(right_bottom, context: ctx)

            showPoint(bottom_left, context: ctx)
            showPoint(bottom_center, context: ctx)
            showPoint(bottom_right, context: ctx)
            
            showPoint(left_top, context: ctx)
            showPoint(left_center, context: ctx)
            showPoint(left_bottom, context: ctx)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func showPoint(_ point: CGPoint, context: CGContext) {
        let rect = CGRect(x: point.x-1, y: point.y-1, width: 2, height: 2)
        context.fill(rect)
    }
    
}
