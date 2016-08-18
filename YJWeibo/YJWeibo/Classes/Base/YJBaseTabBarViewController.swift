//
//  YJBaseTabBarViewController.swift
//  YJWeibo
//
//  Created by pan on 16/8/18.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit

class YJBaseTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置tabbar
        tabBar.tintColor = UIColor.orangeColor()
        //创建首页
       addChildViewController("YJMainViewController", title: "首页", imageName:"tabbar_home")
        
        //消息
        addChildViewController("YJMessageViewController", title: "消息", imageName:"tabbar_message_center")
        
        //发现
         addChildViewController("YJAttentionViewController", title: "发现", imageName:"tabbar_discover")
        
        //我的
         addChildViewController("YJMainViewController", title: "我的", imageName:"tabbar_profile")
       

        
    }
    
    // MARK: 添加子控制
    private func  addChildViewController(childController: UIViewController ,title:String, imageName:String) {
        
        let main = childController
        
        main.title = title;
        main.tabBarItem.image = UIImage(named: imageName)
        main.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        //创建一个nav
        let navi = YJBaseNaviViewController()
        navi.addChildViewController(main)
        addChildViewController(navi)
        
        
    }
    
    // MARK: 通过字符串动态加载控制
    
    private func addChildViewController(childControllerName: String,title:String, imageName:String) {
        
        
        //在swift中有动态命名空间的概念，默认未工程名字
        let prodouctName = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        
        //获取类名
        let className:AnyClass? = NSClassFromString(prodouctName + "." + childControllerName)
        
        // 将类名转化为指定的类型
        let vcCls = className as! UIViewController.Type
        
        // 调用初始化方法
        let childVC = vcCls.init()
        
        
        addChildViewController(childVC, title: title, imageName: imageName)
        
        
        
        
    }

    
}
