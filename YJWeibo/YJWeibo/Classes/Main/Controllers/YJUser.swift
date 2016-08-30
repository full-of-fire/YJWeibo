//
//  YJUser.swift
//  YJWeibo
//
//  Created by pan on 16/8/30.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit

class YJUser: NSObject {

    
    /// 用户ID
    var id: Int = 0
    /// 友好显示名称
    var name: String?
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?{
    
    
        didSet {
        
            if let url = profile_image_url{
            
                iconURL = NSURL(string: url)
            }
        }
    }
    
    var iconURL:NSURL?
    
    
    init(dict: [String :AnyObject]) {
        
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
