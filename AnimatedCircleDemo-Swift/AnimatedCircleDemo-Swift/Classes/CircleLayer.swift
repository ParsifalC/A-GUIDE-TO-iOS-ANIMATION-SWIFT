//
//  CircleLayer.swift
//  AnimatedCircleDemo-Swift
//
//  Created by Kitten Yang on 1/18/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

enum MovingPoint {
    case point_D
    case point_B
}

let outsideRectSize: CGFloat = 90

class CircleLayer: CALayer {

    var progress: CGFloat = 0.0 {
        didSet{
            //外接矩形在左侧，则改变B点；在右边，改变D点
            if progress <= 0.5 {
                movePoint = .point_B;
                print("B点动")
            }else{
                movePoint = .point_D;
                print("D点动")
            }
            
            self.lastProgress = progress
            let buff = (progress - 0.5)*(frame.size.width - outsideRectSize)
            let origin_x = position.x - outsideRectSize/2 + buff
            let origin_y = position.y - outsideRectSize/2;
            
            outsideRect = CGRect(x: origin_x, y: origin_y, width: outsideRectSize, height: outsideRectSize);
            setNeedsDisplay()
        }
    }
    
    fileprivate var outsideRect: CGRect!
    fileprivate var lastProgress: CGFloat = 0.5
    fileprivate var movePoint: MovingPoint!
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? CircleLayer {
            progress    = layer.progress
            outsideRect = layer.outsideRect
            lastProgress = layer.lastProgress
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in ctx: CGContext) {
        let offset = outsideRect.size.width / 3.6
        let movedDistance = (outsideRect.size.width * 1 / 6) * fabs(self.progress-0.5)*2
        let rectCenter = CGPoint(x: outsideRect.origin.x + outsideRect.size.width/2 , y: outsideRect.origin.y + outsideRect.size.height/2)
        
        let pointA = CGPoint(x: rectCenter.x ,y: outsideRect.origin.y + movedDistance)
        let pointB = CGPoint(x: movePoint == .point_D ? rectCenter.x + outsideRect.size.width/2 : rectCenter.x + outsideRect.size.width/2 + movedDistance*2 ,y: rectCenter.y)
        let pointC = CGPoint(x: rectCenter.x ,y: rectCenter.y + outsideRect.size.height/2 - movedDistance)
        let pointD = CGPoint(x: movePoint == .point_D ? outsideRect.origin.x - movedDistance*2 : outsideRect.origin.x, y: rectCenter.y)
        
        let c1 = CGPoint(x: pointA.x + offset, y: pointA.y)
        let c2 = CGPoint(x: pointB.x, y: self.movePoint == .point_D ? pointB.y - offset : pointB.y - offset + movedDistance)
        
        let c3 = CGPoint(x: pointB.x, y: self.movePoint == .point_D ? pointB.y + offset : pointB.y + offset - movedDistance)
        let c4 = CGPoint(x: pointC.x + offset, y: pointC.y)
        
        let c5 = CGPoint(x: pointC.x - offset, y: pointC.y)
        let c6 = CGPoint(x: pointD.x, y: self.movePoint == .point_D ? pointD.y + offset - movedDistance : pointD.y + offset)
        
        let c7 = CGPoint(x: pointD.x, y: self.movePoint == .point_D ? pointD.y - offset + movedDistance : pointD.y - offset)
        let c8 = CGPoint(x: pointA.x - offset, y: pointA.y)
        
        //外接虚线矩形
        let rectPath = UIBezierPath(rect: outsideRect)
        ctx.addPath(rectPath.cgPath)
        ctx.setStrokeColor(UIColor.black.cgColor)
        ctx.setLineWidth(1.0)
        let dash = [CGFloat(5.0), CGFloat(5.0)]
        ctx.setLineDash(phase: 0.0, lengths: dash)
        
        ctx.strokePath()
        
        //圆的边界
        let ovalPath = UIBezierPath()
        ovalPath.move(to: pointA)
        ovalPath.addCurve(to: pointB, controlPoint1: c1, controlPoint2: c2)
        ovalPath.addCurve(to: pointC, controlPoint1: c3, controlPoint2: c4)
        ovalPath.addCurve(to: pointD, controlPoint1: c5, controlPoint2: c6)
        ovalPath.addCurve(to: pointA, controlPoint1: c7, controlPoint2: c8)
        ovalPath.close()
        
        ctx.addPath(ovalPath.cgPath)
        ctx.setStrokeColor(UIColor.black.cgColor)
        ctx.setFillColor(UIColor.red.cgColor)
        ctx.setLineDash(phase: 0, lengths: [])
        ctx.drawPath(using: .fillStroke)//同时给线条和线条包围的内部区域填充颜色
        
        //标记出每个点并连线，方便观察，给所有关键点染色 -- 白色,辅助线颜色 -- 白色
        ctx.setFillColor(UIColor.yellow.cgColor)
        ctx.setStrokeColor(UIColor.black.cgColor)
        let points = [NSValue(cgPoint: pointA), NSValue(cgPoint: pointB), NSValue(cgPoint: pointC), NSValue(cgPoint: pointD), NSValue(cgPoint: c1), NSValue(cgPoint: c2), NSValue(cgPoint: c3), NSValue(cgPoint: c4), NSValue(cgPoint: c5), NSValue(cgPoint: c6), NSValue(cgPoint: c7), NSValue(cgPoint: c8)]
        drawPoint(points, ctx: ctx)
        
        //连接辅助线
        let helperline = UIBezierPath()
        helperline.move(to: pointA)
        helperline.addLine(to: c1)
        helperline.addLine(to: c2)
        helperline.addLine(to: pointB)
        helperline.addLine(to: c3)
        helperline.addLine(to: c4)
        helperline.addLine(to: pointC)
        helperline.addLine(to: c5)
        helperline.addLine(to: c6)
        helperline.addLine(to: pointD)
        helperline.addLine(to: c7)
        helperline.addLine(to: c8)
        helperline.close()
        
        ctx.addPath(helperline.cgPath)
        let dash2 = [CGFloat(2.0), CGFloat(2.0)]
        ctx.setLineDash(phase: 0, lengths: dash2)
        ctx.strokePath()

    }
    
    fileprivate func drawPoint(_ points: [NSValue], ctx: CGContext) {
        for pointValue in points {
            let point = pointValue.cgPointValue
            ctx.fill(CGRect(x: point.x - 2,y: point.y - 2,width: 4,height: 4))
        }
    }
    
}
