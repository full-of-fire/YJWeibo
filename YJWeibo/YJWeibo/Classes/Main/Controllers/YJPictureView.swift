//
//  YJPictureView.swift
//  YJWeibo
//
//  Created by pan on 16/8/30.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit
private let pictureCellReuseID = "pictureCellReuseID"
class YJPictureView: UIView {

    // 图片URL
    var imageURLS:[NSURL]?{
    
        didSet {
        
            // 刷新数据
            collectView.reloadData()
            
            print(imageURLS)
        }
    }
    
   override init(frame: CGRect) {
    
        super.init(frame: frame)
    
        addSubview(collectView)
        collectView.backgroundColor = UIColor.orangeColor()
        collectView.delegate = self
        collectView.dataSource = self
        //注册cell
        collectView.registerClass(YJPictureCell.self, forCellWithReuseIdentifier: pictureCellReuseID)
    
    }
    
    
    // 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectView.frame = CGRectMake(0, 0, bounds.width, bounds.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:懒加载
    private lazy var collectView:UICollectionView = {
    
        let collectView = UICollectionView(frame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height),collectionViewLayout:self.preLayout)
        
        
        return collectView
        
    }()
    
    private lazy var preLayout:UICollectionViewFlowLayout = {
    
       
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        layout.itemSize = CGSizeMake(50, 50)
       
        
        return layout
        
        
    }()
    

}

extension YJPictureView:UICollectionViewDelegate,UICollectionViewDataSource{

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
    
        return imageURLS?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectView.dequeueReusableCellWithReuseIdentifier(pictureCellReuseID, forIndexPath: indexPath) as! YJPictureCell
        
      
        cell.backgroundColor = UIColor.greenColor()
        if  let images = imageURLS {
            
            cell.imageURL = images[indexPath.row]
        }
        return cell
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
            
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
        
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:懒加载
    private lazy var picImageView:UIImageView = UIImageView()
    
    
}

