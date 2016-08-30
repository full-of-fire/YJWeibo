//
//  YJStatus.swift
//  YJWeibo
//
//  Created by pan on 16/8/30.
//  Copyright © 2016年 yj. All rights reserved.
// 微博模型

import UIKit

class YJStatus: NSObject {

    //微博的创建时间
    var created_at: String? {
    
        didSet {
        
            //在这里处理时间
            //先把时间处理为NSDate
            let formatter = NSDateFormatter()
            
            //设置时间的格式
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
            // 设置时间的区域
            formatter.locale = NSLocale(localeIdentifier: "en")
            
            // 转化为NSDate
            let cratedDate = formatter.dateFromString(created_at!)
            
            if let realDate = cratedDate {
            
                //在这里与当前时间比较
                //获取当前日历
                let currentCalendar = NSCalendar.currentCalendar()
                
                if currentCalendar.isDateInToday(realDate) {
                    
                    //如果在今天之内
                    //计算当前时间和系统时间之差
                    let interval = Int(NSDate().timeIntervalSinceDate(realDate))
                    
                    if interval<60 {
                        created_at = "刚刚"
                    }
                    if interval<60*60 {
                        
                        created_at = "\(interval/60)分钟前"
                    }
                    
                    created_at = "\(interval/60/60)小时前"
                }
                
                // 2.判断是否是昨天
                var formatterStr = "HH:mm"
                if currentCalendar.isDateInYesterday(realDate) {
                    
                    formatterStr = "昨天:" + formatterStr
                }
                else {
                
                    //处理一年以内
                    formatterStr = "MM-dd " + formatterStr
                    
                    //获取年份
                    let comps = currentCalendar.components(NSCalendarUnit.Year, fromDate: realDate, toDate: NSDate(), options:  NSCalendarOptions(rawValue: 0))
                    
                    if comps.year >= 1 {
                        
                        formatterStr = "yyyy-" + formatterStr
                    }
                    
                }
                
                
                //设置格式化
                formatter.dateFormat = formatterStr
                created_at = formatter.stringFromDate(realDate)
                
            }
            
            
        }
    }
    
    /// 微博ID
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    
    /// 微博来源
    var source: String? {
    
        didSet{
            // 1.截取字符串
            if let str = source
            {
                if str == ""
                {
                    return
                }
                
                // 1.1获取开始截取的位置
                let startLocation = (str as NSString).rangeOfString(">").location + 1
                // 1.2获取截取的长度
                let length = (str as NSString).rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startLocation
                // 1.3截取字符串
                source = "来自:" + (str as NSString).substringWithRange(NSMakeRange(startLocation, length))
            }
        }

    }
    
    /// 配图数组
    var pic_urls: [[String: AnyObject]]?
    
    /// 用户信息
    var user: YJUser?
    
    
    init(dict: [String:AnyObject]) {
        
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        
        if key == "user" {
            
            user = YJUser(dict: value as![String:AnyObject])
            return
        }
        super.setValue(value, forKey: key)
    }
    
    
    
    //重写该方法是为不崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    
}
