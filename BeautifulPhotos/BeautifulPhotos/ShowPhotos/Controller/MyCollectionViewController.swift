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
    
    var isRefreshing = false
    var myTitleView: MyTitleView!
    var kingImageString: String = "壁纸"
    var currentPage: Int = 1
    var imageDatas: [MyImageDataModel]? {
        didSet {
            //  获取数据后，刷新collectionView数据
            self.collectionView?.reloadData()
            self.collectionView?.header.endRefreshing()
            self.collectionView?.footer.endRefreshing()
            self.isRefreshing = false
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
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        self.collectionView?.contentInset.top = 44 // 避免header遮住标题栏
        myTitleView = MyTitleView()
        
        // Add subviews
        self.view.addSubview(myTitleView)
        
        // 设置下拉刷新
        collectionView?.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "pullDownToRefresh")
        // 设置上拉加载更多
        collectionView?.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "pullUpToRefresh")
        
        // 程序一开始需先自动进入刷新从网络获取数据
        collectionView?.header.beginRefreshing()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Event Response
    
    func pullDownToRefresh() {
        if !isRefreshing {
            isRefreshing = true  // 设置collectionView正在刷新
            
            // request data from 500px.com，网络不行，有真机时在测试一下
            //            MyNetworkOperation.requestDataWithURL(self, url: "https://api.500px.com/v1/photos", parameters: ["feature" : "popular", "image_size": "600", "consumer_key" : "dOx1REBdbyI3WSoXTlNqnnE9jDPV1hxExIjVVpQl"])
            
            // 从百度图片获取图片, 刷新永远从第一页开始取
            MyNetworkOperation.requestDataWithURL(self, url: self.makeURLString(self.kingImageString, pageNumber: 1), parameters: nil, action: "pullDwon")
        }
    }
    
    func pullUpToRefresh() {
        if !isRefreshing {
            isRefreshing = true // 设置collectionView正在刷新
            self.currentPage++  // 获取下一页
            self.collectionView?.footer.beginRefreshing()
            
            
            MyNetworkOperation.requestDataWithURL(self, url: self.makeURLString(self.kingImageString, pageNumber: self.currentPage), parameters: nil, action: "pullUp")
        }
    }
    
    // MARK: - private methods
    func makeURLString(kindImageString: String, pageNumber: Int) -> String {
        return "http://image.baidu.com/data/imgs?col=\(kindImageString)&tag=全部&pn=\(pageNumber)&p=channel&rn=30&from=1".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    }

    // MARK: - UICollectionViewDataSource

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
        cell.backgroundColor = UIColor.darkGrayColor()
        cell.backgroundImageView!.sd_setImageWithURL(NSURL(string: self.imageDatas![indexPath.row+1].imageURLString)!) //+1是因为第0张图片我们放在了header上面，加个header是因为我觉得会更美观
    
        return cell
    }
    
    // MARK: - UICollectionView Delegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
 
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MyCollectionViewCell
        let locationTap = CGPointMake(cell.center.x, cell.center.y - collectionView.contentOffset.y) // 随着滚动cell的垂直坐标一直在增加，所以要获取准确相对于屏幕上方的y值，需减去滚动的距离
        
        ShowBigImageView.showImageView(cell.backgroundImageView!, startCenter: locationTap)
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
