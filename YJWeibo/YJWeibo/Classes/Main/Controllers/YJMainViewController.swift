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
    
    //MARK:viewLife
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置导航条
        setUpNavi()
        
        
    }
    

    
    
    //MARK:YJMainVisitorViewDelegate
    func attentioButtonClick() {
        
        print("我点击关注按钮了")
    }
    
    //MARK:响应事件方法
    func leftItemAction() {
        
        print("左边响应")
        
    }
    
    func rightItemAction() {
    
        print("右边响应")
        let scannerBoard = UIStoryboard.init(name: "YJQCRScannerViewController", bundle: nil)
        
        let vc = scannerBoard.instantiateInitialViewController()
        
        presentViewController(vc!, animated: true, completion: nil)
        
        
        
    }
    
    func centerClick(btn:UIButton){
    
        btn.selected = !btn.selected
        
        
    }

    
    //MARK:私有方法
    private func setUpNavi () {
    
        // 设置左边的item
        navigationItem.leftBarButtonItem = UIBarButtonItem.yj_createBarButtonItem(normalImage: "navigationbar_friendattention", hightlightedImage: "navigationbar_friendattention_highlighted", target: self, selector: #selector(YJMainViewController.leftItemAction))
        
        // 设置右边的item
        navigationItem.rightBarButtonItem = UIBarButtonItem.yj_createBarButtonItem(normalImage: "navigationbar_pop", hightlightedImage: "navigationbar_pop_highlighted", target: self, selector: #selector(YJMainViewController.rightItemAction))
        
        // 设置中间标题
        let centerBtn = YJTitleButton()
        
        centerBtn.setImage(UIImage(named: "navigationbar_arrow_down"), forState: .Normal)
        centerBtn.setImage(UIImage(named: "navigationbar_arrow_up"), forState: .Selected)
        centerBtn.addTarget(self, action: #selector(YJMainViewController.centerClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        centerBtn.setTitle("大杰哥的微博 ", forState: .Normal)
        centerBtn.sizeToFit()
        centerBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        navigationItem.titleView = centerBtn
        
        
        
        
    }
   
}
