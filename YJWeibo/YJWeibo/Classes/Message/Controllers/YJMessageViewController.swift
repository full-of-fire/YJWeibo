//
//  YJMessageViewController.swift
//  YJWeibo
//
//  Created by pan on 16/8/18.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit

class YJMessageViewController: YJBaseTableViewController {

     var login = false
        
    override func loadView() {
         super.loadView()
        
        if !false {
          
            let messageVisitorView = YJMessageVisitorView.messageVisitorView()
            messageVisitorView.bounds = view.bounds
        
            
            
            view = messageVisitorView
        }
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   

}
