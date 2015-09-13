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
    
    class func requestDataWithURL(owner: MyCollectionViewController, url: URLStringConvertible, parameters: [String: AnyObject]?, action: String) {
        
        // 网络请求
        Alamofire.request(Alamofire.Method.GET, url, parameters: parameters).responseJSON(options: NSJSONReadingOptions.MutableContainers) { (_, _, json: AnyObject?, error: NSError?) -> Void in
            if error != nil {
                
                // 网络访问有错误
                NSLog ("\(error)")
            } else {
                // 获取数据放在高优先级全局队列完成
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    let json = JSON(json!)  // 利用SwiftyJSON解析json
                    
                    var photos = json["imgs"].array // 从json中取出我们关心的部分
                    
                    photos?.removeAtIndex(photos!.count-1)  // 从JSONEditorOnline解析情况发现最后总有一个空的，所以去掉
                    
                    // 最后获取json中需要的图片url数据，放在主队列中完成
                    dispatch_async(dispatch_get_main_queue()) {
                        // 下拉刷新
                        if action == "pullDwon" {
                            // 如果imageDatas本身就有值则将新的值放在前面，否则直接赋值
                            if owner.imageDatas != nil {
                                owner.imageDatas = photos!.filter({
                                    // 利用id过滤掉哪些之前就已经回来了的数据
                                    for i in 0 ..< owner.imageDatas!.count {
                                        if $0["pictureId"].string! == owner.imageDatas![i].imageId {
                                            // 这个要去掉，因为已经有了
                                            return false
                                        }
                                    }
                                    
                                    // 这个数据是新的
                                    return true
                                }).map {
                                    MyImageDataModel(URLString: $0["imageUrl"].string!, id: $0["pictureId"].string!)
                                    } + owner.imageDatas!
                            } else {
                                owner.imageDatas = photos?.map {
                                    MyImageDataModel(URLString: $0["imageUrl"].string!, id: $0["pictureId"].string!)
                                }
                            }
                        } else {
                            // 上拉加载更多
                            owner.imageDatas = owner.imageDatas! + photos!.map {
                                MyImageDataModel(URLString: $0["imageUrl"].string!, id: $0["pictureId"].string!)
                            }
                        }
                    }
                }
            }
        }
    }
}
