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

        
        // 解析本地json
        let jsonPath = NSBundle.mainBundle().pathForResource("localSettings.json", ofType: nil)
        
        if let resultPath = jsonPath {
            
            print(resultPath)
            
             //转为data
            let fileData = NSData.init(contentsOfFile: resultPath)
            
            if let realData = fileData  {
                
                //在这里序列化，序列化可能会出现，抛异常
                
                do {
                
                    // 这里正常解析
                    let jsonArr = try NSJSONSerialization.JSONObjectWithData(realData, options: .MutableContainers)
                    
                    //遍历数组,这里需要注意因为json返回的是Anyobject对象，需要将其转为数组
                    for dict in jsonArr as![[String:String]] {
                    
                        addChildViewController(dict["vcName"]!, title: dict["title"]!, imageName: dict["imageName"]!)
                    }
                    
                    print("解析成功")
                 
                    
                }
                catch {
                
                    print(error)
                    // 异常处理,如果解析json失败，就自己创建
                    //创建首页
                    addChildViewController("YJMainViewController", title: "首页", imageName:"tabbar_home")
                    
                    //消息
                    addChildViewController("YJMessageViewController", title: "消息", imageName:"tabbar_message_center")
                    
                    //发现
                    addChildViewController("YJAttentionViewController", title: "发现", imageName:"tabbar_discover")
                    
                    //我的
                    addChildViewController("YJMineViewController", title: "我的", imageName:"tabbar_profile")
                }
                
                
            }
            
        }
        
        
        
        
        
        //设置tabbar
        tabBar.tintColor = UIColor.orangeColor()
     
       

        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // 在这里添加按钮
        let buttonW = UIScreen.mainScreen().bounds.width / CGFloat(childViewControllers.count)
        
        composeButton.frame = CGRectMake(2*buttonW, 0, buttonW, 49)
        
        tabBar.addSubview(composeButton)
        
        
        
        
    }
    
    //MARK: 按钮点击事件
    func composeClick() {
        
        
        print("我被点击了")
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
    
    
    
    //MARK: 懒加载一个按钮
    private lazy var composeButton:UIButton = {
    
       let btn = UIButton()

        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: .Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: .Selected)
        
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: .Selected)
        
        
//         btn.addTarget(self, action: "composeClick", forControlEvents: .TouchUpInside)
        btn.addTarget(self, action: #selector(YJBaseTabBarViewController.composeClick), forControlEvents: .TouchUpInside)
        

        
        return btn
        
    }()
    
   
    

    
}
