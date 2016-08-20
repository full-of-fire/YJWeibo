//
//  YJMainVisitorView.swift
//  YJWeibo
//
//  Created by pan on 16/8/20.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit
import SnapKit

//申明协议
protocol YJMainVisitorViewDelegate:NSObjectProtocol {

    // 关注按钮点击
    func attentioButtonClick()
}

class YJMainVisitorView: UIView {

   
    // 申明代理
    weak var delegate:YJMainVisitorViewDelegate?
    
    
    // 定义一个闭包
    var attentClickBlock:(()->())?
    
    
    // 主页的访客视图
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubview(rorationView)
        
        addSubview(hourseView)
        
        addSubview(introduceLabel)
        
        addSubview(attentionButton)
        
    
       
    }
    
    
    //MARK: 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 在这里写布局相关的代码
        weak var weakSelf = self
    
        //旋转视图
        rorationView.snp_makeConstraints { (make) in
            
            make.size.equalTo(CGSizeMake(200, 200))
            make.center.equalTo(weakSelf!)
        }
        
        // 房子视图
        hourseView.snp_makeConstraints { (make) in
            
            make.size.equalTo(CGSizeMake(100, 100))
            make.center.equalTo(weakSelf!)
        }
        
        // 介绍label
        introduceLabel.snp_makeConstraints { (make) in
            
            make.top.equalTo(rorationView.snp_bottom).offset(10)
            make.left.equalTo(weakSelf!.snp_left).offset(10)
            make.right.equalTo(weakSelf!.snp_right).offset(10)
            make.height.equalTo(44)
        }
        
        //关注按钮
        attentionButton.snp_makeConstraints { (make) in
            
            make.top.equalTo(introduceLabel.snp_bottom).offset(10)
            make.size.equalTo(CGSizeMake(100, 44))
            make.centerX.equalTo(introduceLabel.snp_centerX)
        }
        
        
        
    }
    
    
    
    
    //MARK: 按钮点击事件
    func attentionClick()  {
        
        // 感觉这个写法要比OC简单
       delegate?.attentioButtonClick()
        
        
        // 
        attentClickBlock?()
    }
    
    
    // 如果是自定义xib view必须实现这个方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 懒加载
    //背景图
    private lazy var rorationView:UIImageView = {
    
        let rorationView = UIImageView()
        rorationView.image = UIImage(named: "visitordiscover_feed_image_smallicon")
       
        return rorationView
    }()
    
    //房子图
    private lazy var hourseView:UIImageView = {
    
       let houresView = UIImageView()
        
        houresView.image = UIImage(named: "visitordiscover_feed_image_house")
        
        return houresView
    }()
    
    //介绍labael
    private lazy var introduceLabel:UILabel = {
    
       let label = UILabel()
        label.text = "关注一些人，回这里看看有什么惊喜"
        label.textColor = UIColor.grayColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    
    // 关注按钮
    private lazy var attentionButton:UIButton = {
    
        let btn = UIButton()
        
        btn.setTitle("去关注", forState: .Normal)
       
        // 添加点击事件
        
//        btn.addTarget(self , action: "attentionClick", forControlEvents: .TouchUpInside)
        
        btn.addTarget(self , action: #selector(YJMainVisitorView.attentionClick), forControlEvents: .TouchUpInside)
        btn.backgroundColor = UIColor.grayColor()
        

        return btn
    }()
    

}
