//
//  MyCollectionViewController.swift
//  BeautifulPhotos
//
//  Created by ldjhust on 15/9/8.
//  Copyright (c) 2015年 example. All rights reserved.
//

import UIKit
import MJRefresh
import SDWebImage

let reuseIdentifier = "Cell"
let reuseHeaderIdentifier = "header"

class MyCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - properties
    
    var myTitleView: MyTitleView!
    var imageDatas: [MyImageDataModel]? {
        willSet {
            //  获取数据后，刷新collectionView数据
            self.collectionView?.reloadData()
            self.collectionView?.header.endRefreshing()
        }
    }

    // MARK: - Init Method
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.registerClass(MyCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Register header classes
        self.collectionView?.registerClass(MyCollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        
        self.collectionView?.backgroundColor = UIColor(red: 95.0/255, green: 159.0/255, blue: 255.0/255, alpha: 1.0)
        self.collectionView?.contentInset.top = 44 // 避免header遮住标题栏
        myTitleView = MyTitleView()
        
        // Add subviews
        self.view.addSubview(myTitleView)
        
        // 下拉刷新
        collectionView?.header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            // request data from 500px.com，网络不行，有真机时在测试一下
//            MyNetworkOperation.requestDataWithURL(self, url: "https://api.500px.com/v1/photos", parameters: ["feature" : "popular", "image_size": "600", "consumer_key" : "dOx1REBdbyI3WSoXTlNqnnE9jDPV1hxExIjVVpQl"])
            
            // 从百度图片获取图片
            MyNetworkOperation.requestDataWithURL(self, url: "http://image.baidu.com/channel/listjson?pn=0&rn=20&tag1=%E5%A3%81%E7%BA%B8&tag2=%E9%A3%8E%E6%99%AF&flags=%E5%85%A8%E9%83%A8", parameters: nil)
        })
        collectionView?.header.beginRefreshing()
        
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.imageDatas == nil {
            return 0
        } else {
            return self.imageDatas!.count - 1 // 第0张图片我们显示在collectionView的header上面
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MyCollectionViewCell
    
        // Configure the cell
        cell.backgroundImageView!.sd_setImageWithURL(NSURL(string: self.imageDatas![indexPath.row+1].imageURLString)!) //+1是因为第0张图片我们放在了header上面，加个header是因为我觉得会更美观
    
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(1, 0, 1, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
         return 1.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = (view.bounds.width - 2) / 3
        return CGSizeMake(width, width)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width = view.bounds.width
        return CGSizeMake(width, width)
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseHeaderIdentifier, forIndexPath: indexPath) as! MyCollectionHeaderReusableView
        
        // config header view
        if self.imageDatas != nil {
            headerView.backgroundImageView.sd_setImageWithURL(NSURL(string: self.imageDatas![0].imageURLString)!)  // 显示第0张图片在header上面
        }
        
        return headerView
    }
}
