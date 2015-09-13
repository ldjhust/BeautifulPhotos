//
//  MyTitleView.swift
//  BeautifulPhotos
//
//  Created by ldjhust on 15/9/8.
//  Copyright (c) 2015年 example. All rights reserved.
//

import UIKit
import KxMenu

class MyTitleView: UIView {
    // MARK: - properties
    
    var titleLabelLeft: UILabel!
    var titleLabelRight: UILabel!
    var titleImageView: UIImageView!
    var menuButton: UIButton!
    var bgImageView: UIImageView!
    
    init() {
        super.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44))
        
        titleLabelLeft = UILabel(frame: CGRectMake(0, 10, bounds.width/2 - 16, 37))
        titleLabelLeft.font = UIFont.boldSystemFontOfSize(20)
        titleLabelLeft.text = "Bai"
        titleLabelLeft.textAlignment = NSTextAlignment.Right
        titleLabelLeft.textColor = UIColor.redColor()
        
        
        titleImageView = UIImageView(frame: CGRectMake((bounds.width-30)/2, 7, 30, 30))
        let imagePathString = NSBundle.mainBundle().pathForResource("baidu_logo", ofType: "png")!
        titleImageView.image = UIImage(contentsOfFile: imagePathString)
        
        titleLabelRight = UILabel(frame: CGRectMake(bounds.width/2 + 16, 10, bounds.width/2 - 16, 37))
        titleLabelRight.font = UIFont.boldSystemFontOfSize(20)
        titleLabelRight.text = "图片"
        titleLabelRight.textAlignment = NSTextAlignment.Left
        titleLabelRight.textColor = UIColor.redColor()
        
        menuButton = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 105, 10, 100, 30))
        menuButton.setTitle("分类", forState: UIControlState.Normal)
        menuButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        menuButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        menuButton.layer.borderColor = UIColor.blueColor().CGColor
        menuButton.layer.borderWidth = 1
        menuButton.addTarget(self, action: "showMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        
        bgImageView = UIImageView(frame: frame)
        let bgImagePath = NSBundle.mainBundle().pathForResource("titile_bg", ofType: "png")
        bgImageView.image = UIImage(named: bgImagePath!)
    
        self.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(bgImageView)
        self.addSubview(titleLabelLeft)
        self.addSubview(titleImageView)
        self.addSubview(titleLabelRight)
        self.addSubview(menuButton)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Event Response
    
    func showMenu(sender: UIButton) {
//        convenience init!(_ title: String!, image: UIImage!, target: AnyObject!, action: Selector)
        KxMenu.showMenuInView(self.superview, fromRect: sender.frame, menuItems: [KxMenuItem("明星", image: nil, target: self, action: "pushMenuItem:"),
            KxMenuItem("美女", image: nil, target: self, action: "pushMenuItem:"),
            KxMenuItem("壁纸", image: nil, target: self, action: "pushMenuItem:"),
            KxMenuItem("动漫", image: nil, target: self, action: "pushMenuItem:"),
            KxMenuItem("摄影", image: nil, target: self, action: "pushMenuItem:"),
            KxMenuItem("设计", image: nil, target: self, action: "pushMenuItem:"),
            KxMenuItem("宠物", image: nil, target: self, action: "pushMenuItem:"),
            KxMenuItem("汽车", image: nil, target: self, action: "pushMenuItem:")])
    }
    
    func pushMenuItem(sender: KxMenuItem) {
        
        // 改变类别
        (UIApplication.sharedApplication().keyWindow?.rootViewController as? MyCollectionViewController)?.kingImageString = sender.title
    }
}
