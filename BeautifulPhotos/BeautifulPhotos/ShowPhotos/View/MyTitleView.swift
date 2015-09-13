//
//  MyTitleView.swift
//  BeautifulPhotos
//
//  Created by ldjhust on 15/9/8.
//  Copyright (c) 2015年 example. All rights reserved.
//

import UIKit

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
        
        menuButton = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 60, 10, 50, 30))
        menuButton.setTitle("分类", forState: UIControlState.Normal)
        menuButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        menuButton.layer.borderColor = UIColor.blueColor().CGColor
        menuButton.layer.borderWidth = 1
        
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
        
    }
    
    func pushMenuItem(sender: AnyObject) {
        
        NSLog("\(sender)")
    }
}
