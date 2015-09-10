//
//  MyImageDataModel.swift
//  BeautifulPhotos
//
//  Created by ldjhust on 15/9/9.
//  Copyright (c) 2015年 example. All rights reserved.
//

import UIKit

class MyImageDataModel {
    var imageURLString: String
    
    init(URLString: String) {
        self.imageURLString = URLString  // 目前我们只对图片感兴趣，对其他信息不感冒
    }
}
