//
//  UIBarButtonItem+YJAdd.swift
//  YJWeibo
//
//  Created by pan on 16/8/21.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit

// 类似于OC中的分类
extension UIBarButtonItem{

    
    // 添加一个类方法用于创建Item
    internal class func yj_createBarButtonItem(normalImage norImgName:String!,hightlightedImage hightlightedImgName:String!,target:AnyObject?, selector:Selector) ->UIBarButtonItem {
    
        
        let btn = UIButton()
        btn.setImage(UIImage(named: norImgName), forState: .Normal)
        btn.setImage(UIImage(named: hightlightedImgName), forState: .Highlighted)
        
        btn.sizeToFit()
        
        btn.addTarget(target, action: selector, forControlEvents: .TouchUpInside)
        
        return UIBarButtonItem.init(customView: btn)
        
    }
    
}