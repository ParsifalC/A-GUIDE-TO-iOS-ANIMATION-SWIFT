//
//  GooeySlideMenu.swift
//  GooeySlideMenuDemo-Swift
//
//  Created by Kitten Yang on 1/3/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

typealias MenuButtonClickedBlock = (_ index: Int, _ title: String, _ titleCounts: Int)->()

struct MenuOptions {
    var titles: [String]
    var buttonHeight: CGFloat
    var menuColor: UIColor
    var blurStyle: UIBlurEffectStyle
    var buttonSpace: CGFloat
    var menuBlankWidth: CGFloat
    var menuClickBlock: MenuButtonClickedBlock
}

class GooeySlideMenu: UIView {
    
    fileprivate var _option: MenuOptions
    fileprivate var keyWindow: UIWindow?
    fileprivate var blurView: UIVisualEffectView!
    fileprivate var helperSideView: UIView!
    fileprivate var helperCenterView: UIView!
    
    fileprivate var diff: CGFloat = 0.0
    fileprivate var triggered: Bool = false
    fileprivate var displayLink: CADisplayLink?
    fileprivate var animationCount: Int = 0
    
    init(options: MenuOptions) {
        _option = options
        if let kWindow = UIApplication.shared.keyWindow{
            keyWindow = kWindow
            let frame = CGRect(
                x: -kWindow.frame.size.width/2 - options.menuBlankWidth,
                y: 0,
                width: kWindow.frame.size.width/2 + options.menuBlankWidth,
                height: kWindow.frame.size.height)
            super.init(frame:frame)
        } else {
            super.init(frame:CGRect.zero)
        }
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: frame.width-_option.menuBlankWidth, y: 0))
        path.addQuadCurve(to: CGPoint(x: frame.width-_option.menuBlankWidth, y: frame.height), controlPoint: CGPoint(x: frame.width-_option.menuBlankWidth+diff, y: frame.height/2))
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        path.close()
        
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(path.cgPath)
        _option.menuColor.set()
        context?.fillPath()
    }
    
    func trigger() {
        if !triggered {
            if let keyWindow = keyWindow {
                keyWindow.insertSubview(blurView, belowSubview: self)
                UIView.animate(withDuration: 0.3, animations: { [weak self] () -> Void in
                    self?.frame = CGRect(
                        x: 0,
                        y: 0,
                        width: keyWindow.frame.size.width/2 + (self?._option.menuBlankWidth)!,
                        height: keyWindow.frame.size.height)
                })
                
                beforeAnimation()
                UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: [.beginFromCurrentState,.allowUserInteraction], animations: { [weak self] () -> Void in
                    self?.helperSideView.center = CGPoint(x: keyWindow.center.x, y: (self?.helperSideView.frame.size.height)!/2);
                    }, completion: { [weak self] (finish) -> Void in
                        self?.finishAnimation()
                })
                
                UIView.animate(withDuration: 0.3, animations: { [weak self] () -> Void in
                    self?.blurView.alpha = 1.0
                })
                
                beforeAnimation()
                UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: [.beginFromCurrentState,.allowUserInteraction], animations: { [weak self] () -> Void in
                    self?.helperCenterView.center = keyWindow.center
                    }, completion: { [weak self] (finished) -> Void in
                        if finished {
                            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GooeySlideMenu.tapToUntrigger))
                            self?.blurView.addGestureRecognizer(tapGesture)
                            self?.finishAnimation()
                        }
                })
                animateButtons()
                triggered = true
            }
        } else {
            tapToUntrigger()
        }
    }
    
}

extension GooeySlideMenu {
    
    fileprivate func setUpViews() {
        if let keyWindow = keyWindow {
            blurView = UIVisualEffectView(effect: UIBlurEffect(style: _option.blurStyle))
            blurView.frame = keyWindow.frame
            blurView.alpha = 0.0
            
            helperSideView = UIView(frame: CGRect(x: -40, y: 0, width: 40, height: 40))
            helperSideView.backgroundColor = UIColor.red
            helperSideView.isHidden = true
            keyWindow.addSubview(helperSideView)
            
            helperCenterView = UIView(frame: CGRect(x: -40, y: keyWindow.frame.height/2 - 20, width: 40, height: 40))
            helperCenterView.backgroundColor = UIColor.yellow
            helperCenterView.isHidden = true
            keyWindow.addSubview(helperCenterView)
            
            backgroundColor = UIColor.clear
            keyWindow.insertSubview(self, belowSubview: helperSideView)
            addButton()
        }
    }
    
    fileprivate func addButton() {
        let titles = _option.titles
        if titles.count % 2 == 0 {
            var index_down = titles.count / 2
            var index_up = -1
            for i in 0..<titles.count {
                let title = titles[i]
                let buttonOption = MenuButtonOptions(title:title, buttonColor:_option.menuColor, buttonClickBlock:{ [weak self] () -> () in
                    self?.tapToUntrigger()
                    self?._option.menuClickBlock(i,title,titles.count)
                })
                let home_button = SlideMenuButton(option: buttonOption)
                home_button.bounds = CGRect(x: 0, y: 0, width: frame.width - _option.menuBlankWidth - 20*2, height: _option.buttonHeight);
                addSubview(home_button)
                if (i >= titles.count / 2) {
                    index_up += 1
                    let y = frame.height/2 + _option.buttonHeight*CGFloat(index_up) + _option.buttonSpace*CGFloat(index_up)
                    home_button.center = CGPoint(x: (frame.width - _option.menuBlankWidth)/2, y: y+_option.buttonSpace/2 + _option.buttonHeight/2)
                } else {
                    index_down -= 1
                    let y = frame.height/2 - _option.buttonHeight*CGFloat(index_down) - _option.buttonSpace*CGFloat(index_down)
                    home_button.center = CGPoint(x: (frame.width - _option.menuBlankWidth)/2, y: y - _option.buttonSpace/2 - _option.buttonHeight/2)
                }
            }
        } else {
            var index = (titles.count-1) / 2 + 1
            for i in 0..<titles.count {
                index -= 1
                let title = titles[i]
                let buttonOption = MenuButtonOptions(title: title, buttonColor: _option.menuColor, buttonClickBlock: { [weak self] () -> () in
                    self?.tapToUntrigger()
                    self?._option.menuClickBlock(i, title, titles.count)
                })
                let home_button = SlideMenuButton(option: buttonOption)
                home_button.bounds = CGRect(x: 0, y: 0, width: frame.width - _option.menuBlankWidth - 20*2, height: _option.buttonHeight)
                home_button.center = CGPoint(x: (frame.width - _option.menuBlankWidth)/2, y: frame.height/2 - _option.buttonHeight*CGFloat(index) - 20*CGFloat(index))
                addSubview(home_button)
            }
        }
    }
    
    fileprivate func animateButtons() {
        for i in 0..<subviews.count {
            let menuButton = subviews[i]
            menuButton.transform = CGAffineTransform(translationX: -90, y: 0)
            UIView.animate(withDuration: 0.7, delay: Double(i)*(0.3/Double(subviews.count)), usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [.beginFromCurrentState,.allowUserInteraction], animations: { () -> Void in
                menuButton.transform =  CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    @objc fileprivate func tapToUntrigger() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] () -> Void in
            let size = (self?.keyWindow!.frame.size) ?? CGSize.zero;
            let menuWidth = (self?._option.menuBlankWidth) ?? 0;
            self?.frame = CGRect(x:-size.width/2 - menuWidth,
                                 y:0,
                                 width:size.width/2 + menuWidth,
                                 height:size.height);
        })
        
        beforeAnimation()
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.9, options: [.beginFromCurrentState,.allowUserInteraction], animations: { () -> Void in
            self.helperSideView.center = CGPoint(x: -self.helperSideView.frame.height/2, y: self.helperSideView.frame.height/2)
        }) { [weak self] (finish) -> Void in
            self?.finishAnimation()
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.blurView.alpha = 0.0
        })
        
        beforeAnimation()
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: [.beginFromCurrentState,.allowUserInteraction], animations: { () -> Void in
            self.helperCenterView.center = CGPoint(x: -self.helperSideView.frame.size.height/2, y: self.frame.height/2)
        }) { (finish) -> Void in
            self.finishAnimation()
        }
        triggered = false
    }
    
    fileprivate func beforeAnimation() {
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(GooeySlideMenu.handleDisplayLinkAction(_:)))
            displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        }
        animationCount += 1
    }
    
    fileprivate func finishAnimation() {
        animationCount -= 1
        if animationCount == 0 {
            displayLink?.invalidate()
            displayLink = nil
        }
    }
    
    @objc fileprivate func handleDisplayLinkAction(_ displaylink: CADisplayLink) {
        let sideHelperPresentationLayer = helperSideView.layer.presentation()!
        let centerHelperPresentationLayer = helperCenterView.layer.presentation()!
        
        let centerRect = (centerHelperPresentationLayer.value(forKeyPath: "frame") as? NSValue)?.cgRectValue
        let sideRect   = (sideHelperPresentationLayer.value(forKeyPath: "frame") as? NSValue)?.cgRectValue
        
        if let centerRect = centerRect, let sideRect = sideRect {
            diff = sideRect.origin.x - centerRect.origin.x
        }
        setNeedsDisplay()
    }
}


