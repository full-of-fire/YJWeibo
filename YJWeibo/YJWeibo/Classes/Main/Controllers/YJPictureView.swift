//
//  YJPictureView.swift
//  YJWeibo
//
//  Created by pan on 16/8/30.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit
import SDWebImage
private let pictureCellReuseID = "pictureCellReuseID"

let YJShowPhotoBrowerNotification = "YJShowPhotoBrowerNotification" //浏览大图的通知
let YJLargeURLSkey = "YJLargeURLSkey" //大图数组的key
let YJIndexKey = "YJIndexKey" // 索引key
class YJPictureView: UICollectionView {

    // 图片URL
    var imageURLS:[NSURL]?{
    
        didSet {
        
            // 刷新数据
           reloadData()
           
        }
    }
    
    // 原始图片的尺寸
    var largeURLs:[NSURL]?{
    
        didSet {
        
            // 刷新数据
            reloadData()
            print(largeURLs)
        }
    }
    
     private var pictureLayout: UICollectionViewFlowLayout =  UICollectionViewFlowLayout()
    init()
    {
        super.init(frame: CGRectZero, collectionViewLayout: pictureLayout)
        
        // 1.注册cell
        registerClass(YJPictureCell.self, forCellWithReuseIdentifier: pictureCellReuseID)
        
        // 2.设置数据源
        dataSource = self
        
        //设置代理
        delegate = self
        
        // 2.设置cell之间的间隙
        pictureLayout.minimumInteritemSpacing = 10
       pictureLayout.minimumLineSpacing = 10
        
        // 3.设置配图的背景颜色
        backgroundColor = UIColor.darkGrayColor()
    }    // 计算图片的图片的布局
    func calPictureSize() -> CGSize {
        
        
        if imageURLS?.count == 0 || imageURLS == nil {
            
            return CGSizeZero
        }
        
        // 如果只有只有一张图片显示原图
        if imageURLS?.count == 1 {
            
           SDWebImageManager.sharedManager().downloadWithURL(imageURLS!.first!, options: .AllowInvalidSSLCertificates, progress: nil, completed: { (image, _, _, _) in
            
            self.pictureLayout.itemSize = image.size
            
           })
            
            return self.pictureLayout.itemSize
        }
        
        let width:CGFloat = 90.0
        let height:CGFloat = 90.0
        let margin:CGFloat = 10.0
        pictureLayout.itemSize = CGSizeMake(width, height)
        
        if imageURLS?.count == 4 {
            
            let viewWidth = 2*width + margin
            
            return CGSizeMake(viewWidth, viewWidth)
        }
        
        // 如果超过四张
        let colomn = 3;
        let row = ((imageURLS?.count)! + colomn - 1)/colomn
        
        let viewWidth = CGFloat(colomn)*width + CGFloat((colomn - 1))*margin
        let viewHeight = CGFloat(row)*height + CGFloat((row - 1))*margin
        
        return CGSizeMake(viewWidth, viewHeight)
        
        
    }
    
    
    
    // 布局
  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
  
}

extension YJPictureView:UICollectionViewDelegate,UICollectionViewDataSource{

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
    
        return imageURLS?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = dequeueReusableCellWithReuseIdentifier(pictureCellReuseID, forIndexPath: indexPath) as! YJPictureCell
        
    
        if  let images = imageURLS {
            
            cell.imageURL = images[indexPath.row]
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
     
        
        print("我是图片我被点击拉")

        //在这里发送通知,info中包含大图数组，和被点击图片所在的索引
        let info:[String:AnyObject] = [YJLargeURLSkey:largeURLs!,YJIndexKey:indexPath]
        NSNotificationCenter.defaultCenter().postNotificationName(YJShowPhotoBrowerNotification, object: nil, userInfo: info)
    }
    
    
}



class YJPictureCell: UICollectionViewCell
{
    
    var imageURL:NSURL?  {
    
        didSet {
        
            guard imageURL != nil else {
            
                return
            }
            
            picImageView.sd_setImageWithURL(imageURL)
            
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(picImageView)
        picImageView.snp_makeConstraints { (make) in
            
            make.center.equalTo(self.contentView)
            make.size.equalTo(self.contentView)
        }
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:懒加载
    private lazy var picImageView:UIImageView = UIImageView()
    
    
}

