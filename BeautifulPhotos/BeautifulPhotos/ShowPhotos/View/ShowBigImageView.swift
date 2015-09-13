//
//  ShowBigImageView.swift
//  BeautifulPhotos
//
//  Created by ldjhust on 15/9/10.
//  Copyright (c) 2015年 example. All rights reserved.
//

import UIKit

class ShowBigImageView: NSObject {
    
    // MARK: - static properties
    
    static var backgroundView: UIView!
    static var imageView: UIImageView!
    static var imageOldCenter: CGPoint!
    static var imageOldSize: CGSize!
    static var lastScale: CGFloat = 1.0
    static var lastPanX: CGFloat = 0.0
    static var lastPanY: CGFloat = 0.0
    static var imageOrignalFrame: CGRect!
    static var canImageViewPan: Bool = false
    
    // MARK: - class methods
    
    class func showImageView(targetImageView: UIImageView, startCenter: CGPoint) {
        let window = UIApplication.sharedApplication().keyWindow!
        
        imageOldCenter = startCenter  // 设置
        imageOldSize = targetImageView.frame.size
        imageView = UIImageView()
        imageView.frame.size = imageOldSize
        imageView.center = imageOldCenter
        imageView.image = targetImageView.image
        
        backgroundView = UIView(frame: UIScreen.mainScreen().bounds)
        backgroundView.backgroundColor = UIColor.blackColor()
        backgroundView.alpha = 0
        
        // 点击后返回
        var tap = UITapGestureRecognizer(target: self, action: "hideImage:")
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        
        // 双指缩放
        var pinch = UIPinchGestureRecognizer(target: self, action: "pinchImage:")
        
        // 图片放大时可以拖动图片
        var pan = UIPanGestureRecognizer(target: self, action: "panImage:")
        
        backgroundView.addGestureRecognizer(tap)
        backgroundView.addGestureRecognizer(pinch)
        backgroundView.addGestureRecognizer(pan)
        backgroundView.addSubview(imageView)
        window.addSubview(backgroundView)
        
        UIView.animateWithDuration(0.3) {
            
            self.backgroundView.alpha = 1
            let width = UIScreen.mainScreen().bounds.width
            let height = self.imageOldSize.height * width / self.imageOldSize.width
            self.imageView.frame = CGRectMake(0, (UIScreen.mainScreen().bounds.height - height)/2, width, height)
            self.imageOrignalFrame = self.imageView.frame  // 保存原来的frame方便恢复
        }
    }
    
    // MARK: - Event Response
    
    class func hideImage(gesture: UITapGestureRecognizer) {
        
        let view = gesture.view
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.imageView.frame.size = self.imageOldSize
            self.imageView.center = self.imageOldCenter
            self.imageView.alpha = 0
            view?.alpha = 0
        }) { (finished) in
            // 返回后，移除backview
            view?.removeFromSuperview()
        }
    }
    
    class func pinchImage(gesture: UIPinchGestureRecognizer) {
        
        // 缩放倍数不设下限，设置上限为原尺寸的3倍
        if self.imageView.frame.size.width / self.imageOrignalFrame.size.width > 3 && gesture.scale > 1 {
            // 超过3倍并且依然做放大的手势不处理，直接返回
            lastScale = 1.0 // 恢复缩放倍数
            self.canImageViewPan = true // 放大情况下，图片可以被移动
            return
        }
        
        if gesture.state == UIGestureRecognizerState.Ended {
            lastScale = 1.0  // 恢复缩放倍数
            if self.imageView.frame.size.width < self.imageOrignalFrame.size.width {
                // 放小的，结束后自动回到原来的大小
                UIView.animateWithDuration(0.3) {
                    
                    self.imageView.frame = self.imageOrignalFrame
                }
                
                // 这种场景图片不能被拖动，因为没有必要
                self.canImageViewPan = false
            } else {
                // 图片在放大的场景下可以被拖动
                self.canImageViewPan = true
            }
            
            return
        }
        
        gesture.scale = gesture.scale - lastScale + 1 // 每次放缩都是基于最开始的图片的尺寸，不然缩放速度不对
        imageView.transform = CGAffineTransformScale(imageView.transform, gesture.scale, gesture.scale)
        lastScale = gesture.scale
    }
    
    class func panImage(gesture: UIPanGestureRecognizer) {
        
        if !self.canImageViewPan {
            // 不能拖动，不处理，恢复设置直接返回
            self.lastPanX = 0.0
            self.lastPanY = 0.0
            return
        }
        
        if gesture.state == UIGestureRecognizerState.Ended {
            // 恢复设置
            self.lastPanX = 0.0
            self.lastPanY = 0.0
            return
        }
        
        // 相对位移
        var x = gesture.translationInView(self.imageView).x - self.lastPanX
        var y = gesture.translationInView(self.imageView).y - self.lastPanY
        
        // 图片移动到边缘时是就能再继续往后面移动了
        if (self.imageView.frame.origin.x >= 0 && x > 0)
            || (self.imageView.frame.origin.x + self.imageView.frame.size.width <= self.backgroundView.bounds.width && x < 0) {
            // 图片左边缘出来了，还要往右边移动就不行了 或者图片右边缘出来了，还要往左边移动就不行了
            NSLog ("他执行了")
            x = 0 // 设置不移动
        }
        
        if (self.imageView.frame.origin.y >= 0 && y > 0
            || (self.imageView.frame.origin.y + self.imageView.frame.size.height <= self.backgroundView.bounds.height && y < 0)) {
            y = 0
        }
        
        self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, x, y)
        
        // 保存上一次的位移
        self.lastPanX = gesture.translationInView(self.imageView).x
        self.lastPanY = gesture.translationInView(self.imageView).y
    }
}