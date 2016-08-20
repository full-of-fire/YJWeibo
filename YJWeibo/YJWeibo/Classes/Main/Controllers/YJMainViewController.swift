//
//  YJMainViewController.swift
//  YJWeibo
//
//  Created by pan on 16/8/18.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit

class YJMainViewController: YJBaseTableViewController,YJMainVisitorViewDelegate {

    // 是否登录
    var login = false
    
    override func loadView() {
         super.loadView()
        
        if !login {
            let visitorView = YJMainVisitorView()
            
            visitorView.delegate = self
            
            visitorView.attentClickBlock = {
            
                print("我闭过包来的")
            }
            
            visitorView.backgroundColor = UIColor.whiteColor()
            visitorView.bounds = view.bounds
            
            view = visitorView
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    //MARK:YJMainVisitorViewDelegate
    func attentioButtonClick() {
        
        print("我点击关注按钮了")
    }

   
}
