//
//  YJMainViewController.swift
//  YJWeibo
//
//  Created by pan on 16/8/18.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit
import Alamofire

let resuesID = "YJStatusCell"  // 复用微博cellID
class YJMainViewController: YJBaseTableViewController,YJMainVisitorViewDelegate {

    // 是否登录
    var login = true
    
    var statusArry:[YJStatus] = [] // 微博数组
    
  
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
        
        // 注册cell
        tableView.registerClass(YJStatusCell.self, forCellReuseIdentifier: resuesID)
        
        
        // 请求数据
        loadNewData()
        
       
    
        
        
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
    
    //MARK:请求数据
    private func loadNewData() {
    
        let path = "https://api.weibo.com/2/statuses/public_timeline.json"
        let para = ["access_token":YJUserAccount.loadAccount()?.access_token as!AnyObject]
        Alamofire.request(.GET, path, parameters: para, encoding:.URL, headers: nil).responseJSON { (respon) in
            
            
            print(respon.result)
            
            if let json = respon.result.value {
            
//                print(json)
                
                let dict = json as![String:AnyObject]
                
                let arr = dict["statuses"] as![AnyObject]
                
                for dic in arr as![[String:AnyObject]]{
                
                    let status = YJStatus(dict:dic)
                    
                    
                    self.statusArry.append(status)
                    
                }
                
                self.tableView.reloadData()
                
                
            }
            
        }
        
    }
    
   
}

extension YJMainViewController{

    //
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statusArry.count
        
       
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let  cell = tableView.dequeueReusableCellWithIdentifier(resuesID) as! YJStatusCell
        
     
       
        
        let  status = statusArry[indexPath.row]
        cell.status = status
      
        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 320
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("点击事件了")
    }
    
    
    
}
