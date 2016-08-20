//
//  YJMessageVisitorView.swift
//  YJWeibo
//
//  Created by pan on 16/8/20.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit

class YJMessageVisitorView: UIView {

  
    //个人喜欢用闭包
    var loginClickBlock:(()->())? // 登录按钮的封包
    
    var registerClickBlock:(()->())? // 注册按钮闭包
    

    //MARK: 获取messageVisitorView,声明类方法 internal
    internal class func  messageVisitorView() ->(YJMessageVisitorView){
    
        
        return NSBundle.mainBundle().loadNibNamed("YJMessageVisitorView", owner: nil, options: nil).first as! YJMessageVisitorView
    }
    // 自定义xib重写这个方法
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    
    @IBAction func loginAction(sender: UIButton) {
        
        loginClickBlock?()
        
    }
    
    @IBAction func registerAction(sender: UIButton) {
        
        registerClickBlock?()
    }
    override func awakeFromNib() {
        
    }
}
