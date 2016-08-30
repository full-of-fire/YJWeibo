//
//  YJMessageViewController.swift
//  YJWeibo
//
//  Created by pan on 16/8/18.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit

class YJMessageViewController: YJBaseTableViewController {

    
    var account:YJUserAccount? =  YJUserAccount.loadAccount()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let res = account {
            
            
            if res.loginSuccess {
                
                super.loadView()
            }
            else{
                
                visitorView.frame = view.bounds
                view = visitorView
            }
            
        }else{
            
            visitorView.frame = view.bounds
            view = visitorView
            
        }
    }
    
    
    
  

    
    //MARK:懒加载
   lazy  var visitorView:YJMessageVisitorView = {
    
    
        let messageVisitorView = YJMessageVisitorView.messageVisitorView()
    
        messageVisitorView.hidden = false
            messageVisitorView.loginClickBlock = {
            
            print("登录跳转啊")
            let loginVC = YJLoginViewController()
            
        self.navigationController!.pushViewController(loginVC, animated: true)
            
        }
       
        return messageVisitorView
    }()
   

}
