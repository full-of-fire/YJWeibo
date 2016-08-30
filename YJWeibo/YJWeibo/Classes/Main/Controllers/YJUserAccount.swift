//
//  YJUserAccount.swift
//  YJWeibo
//
//  Created by pan on 16/8/24.
//  Copyright © 2016年 yj. All rights reserved.
// 用户对象

import UIKit

class YJUserAccount: NSObject,NSCoding{

   
    
    var access_token:String?  // 令牌
    var expires_in:NSNumber?  //  过期时间戳
    var uid: NSNumber? // 用户ID
    var loginSuccess:Bool = false // 是否登录成功
   
    
    
    init(dict: [String:AnyObject]) {
        
        
        super.init()
        
        self.setValuesForKeysWithDictionary(dict)
    }
    
    

    
    //为了不让其崩溃，重写该方法
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    // 归档
    internal func savaAccount()   {
    
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last
        
        if let savePath = path {
        
            let archievePath = savePath.stringByAppendingString("/account.plist")
            
            print(archievePath)
            
           if  NSKeyedArchiver.archiveRootObject(self, toFile: archievePath)
           {
            
            print("归档成功")
            }
            
        }
        
        
      
    }
    
    // 解档
    internal class func loadAccount() -> YJUserAccount? {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last
        
    
        let archievePath = path!.stringByAppendingString("/account.plist")
            
        let userAccoutn = NSKeyedUnarchiver.unarchiveObjectWithFile(archievePath) as? YJUserAccount
        return userAccoutn
        
        }
    
    
    
    //MARK:NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        
        /*  var access_token:String?  // 令牌
         var expires_in:NSNumber?  //  过期时间戳
         var uid: NSNumber? // 用户ID
         var loginSuccess:Bool = false // 是否登录成功*/
        
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeBool(loginSuccess, forKey: "loginSuccess")
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
       access_token = aDecoder.decodeObjectForKey("access_token") as? String
       expires_in =  aDecoder.decodeObjectForKey("expires_in") as? NSNumber
       uid =  aDecoder.decodeObjectForKey("uid") as? NSNumber
       loginSuccess =  aDecoder.decodeBoolForKey("loginSuccess")
        
    }
    
    
    
    
}


