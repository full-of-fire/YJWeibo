//
//  YJStatusCell.swift
//  YJWeibo
//
//  Created by pan on 16/8/30.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit
import SDWebImage

class YJStatusCell: UITableViewCell {

    
    //微博模型
    var status:YJStatus?{
    
        didSet {
        
            //在这里复制
            sourceLabel.text = status?.source
            
            contentLabel.text  = status?.text
            
            crateTimeLabel.text = status?.created_at
            
            userIconImageView.sd_setImageWithURL(status?.user!.iconURL)
            nickNameLabel.text = status?.user?.name
            
            var imageURLs = [NSURL]()
            if let realPics = status?.pic_urls {
                
                for dict  in realPics {
                
                    let thubUrl = dict["thumbnail_pic"]
                    
                    if let urlString = thubUrl {
                    
                        let url = NSURL(string: urlString as! String)
                        
                        print("url = \(url?.absoluteString)")
                        
                        imageURLs.append(url!)
                    }
                    
                }
            }
            
            //给图片赋值
            pictureView.imageURLS = imageURLs
            
            
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        //初始化界面
        setUpUI()
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        userIconImageView.backgroundColor = UIColor.redColor()
        
        nickNameLabel.text = "大杰哥的微博"
        crateTimeLabel.text = "21:45"
        sourceLabel.text = "来自iphone7"
        contentLabel.text = "我他妈的也是醉了了大发利市分解落实经费是发安抚"
        
    }
    
    
    //MARK:布局
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userIconImageView.snp_makeConstraints { (make) in
            
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(10)
            make.size.equalTo(CGSizeMake(60, 60))
        }
        
        nickNameLabel.snp_makeConstraints { (make) in
            
            make.top.equalTo(self.userIconImageView.snp_top)
            make.left.equalTo(self.userIconImageView.snp_right).offset(10)
        }
        
        crateTimeLabel.snp_makeConstraints { (make) in
            
            make.bottom.equalTo(self.userIconImageView.snp_bottom)
            make.left.equalTo(nickNameLabel.snp_left)
            
        }
        
        sourceLabel.snp_makeConstraints { (make) in
            
            make.left.equalTo(self.crateTimeLabel.snp_right).offset(10)
            make.bottom.equalTo(self.crateTimeLabel.snp_bottom)
        }
        
        
        
       
       
        contentLabel.snp_makeConstraints { (make) in
            
            make.top.equalTo(self.userIconImageView.snp_bottom).offset(10)
            make.left.equalTo(self).offset(10)
           
        }
        
        pictureView.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentLabel.snp_bottom).offset(10)
            make.left.equalTo(self).offset(10)
            make.size.equalTo(CGSizeMake(100, 100))
        }
        
        
        bottomToolBar.snp_makeConstraints { (make) in
            
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(pictureView.snp_bottom).offset(10)
            
        }
       
        
       
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:初始化界面
    private func setUpUI () {
    
        
        addSubview(userIconImageView)
        addSubview(nickNameLabel)
        addSubview(crateTimeLabel)
        addSubview(sourceLabel)
        addSubview(contentLabel)
        addSubview(pictureView)
        pictureView.backgroundColor = UIColor.redColor()
        addSubview(bottomToolBar)
        
       
       
    
    }
    
    //懒加载
  private lazy  var userIconImageView:UIImageView = {
    
        let image = UIImageView()
        
        return image
        
    }()
    
   private lazy var nickNameLabel:UILabel = {
    
        let label = UILabel()
        
        return label
    }()
    
    private var crateTimeLabel:UILabel = {
    
       
        let label = UILabel()
        
        return label
    }()
    
    
   private lazy var sourceLabel:UILabel = {
    
        let label = UILabel()
        
        return label
    }()
    
   private lazy var contentLabel:UILabel = {
    
        
        let label = UILabel()
    
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.size.width - 20
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var pictureView:YJPictureView = YJPictureView()
    
    
    private lazy var bottomToolBar:YJStatusBottomToolBar = YJStatusBottomToolBar.statusBottomToolBar()
    
    
    
    
    
    
    
    
   
}
