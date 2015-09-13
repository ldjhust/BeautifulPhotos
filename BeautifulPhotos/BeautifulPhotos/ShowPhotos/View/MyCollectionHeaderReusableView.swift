//
//  MyCollectionHeaderReusableView.swift
//  BeautifulPhotos
//
//  Created by ldjhust on 15/9/9.
//  Copyright (c) 2015年 example. All rights reserved.
//

import UIKit

class MyCollectionHeaderReusableView: UICollectionReusableView {
    var backgroundImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if backgroundImageView == nil {
            self.backgroundImageView = UIImageView()
            self.backgroundImageView.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
            self.backgroundImageView.bounds.size = bounds.size
            
            self.addSubview(self.backgroundImageView)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
