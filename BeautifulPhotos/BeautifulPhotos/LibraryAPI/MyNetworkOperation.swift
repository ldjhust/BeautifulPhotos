//
//  MyNetworkOperation.swift
//  BeautifulPhotos
//
//  Created by ldjhust on 15/9/9.
//  Copyright (c) 2015年 example. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyNetworkOperation {
    class func requestDataWithURL(owner: MyCollectionViewController, url: URLStringConvertible, parameters: [String: AnyObject]?) {
        
        // 网络请求
        Alamofire.request(Alamofire.Method.GET, url, parameters: parameters).responseJSON(options: NSJSONReadingOptions.AllowFragments) { (_, _, json: AnyObject?, error: NSError?) -> Void in
            if error != nil {
                // 网络访问有错误
                NSLog ("\(error)")
            } else {
                let json = JSON(json!)  // 利用SwiftyJSON解析json
                var photos = json["data"].array // 从json中取出我们关心的部分
//                photos = photos?.filter {  // 百度图片没有此参数
//                    $0["nsfw"].bool == false // 过滤没有版权纠纷的图片
//                }
                photos?.removeAtIndex(photos!.count-1)  // 从JSONEditorOnline解析情况发现最后总有一个空的，所以去掉
                
                // 最后获取json中需要的图片url数据
                owner.imageDatas = photos?.map {
                    MyImageDataModel(URLString: $0["image_url"].string!)
                }
            }
        }
    }
}
