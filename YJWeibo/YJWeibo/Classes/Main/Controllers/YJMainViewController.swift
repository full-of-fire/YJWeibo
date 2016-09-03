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

let lastFreshTimeKey = "lastFreshTimeKey" // 上次刷新时间的key

class YJMainViewController: YJBaseTableViewController,YJMainVisitorViewDelegate {

    // 是否登录
    var login = true
    var statusArry:[YJStatus] = [] // 微博数组
    
    var refresh:Bool = false // 标记是否刷新
    
    
    
  
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
        
        // 添加最新微博提示
        view.addSubview(newStatusTipsLabel)
        
        
        // 注册cell
        tableView.registerClass(YJStatusCell.self, forCellReuseIdentifier: resuesID)
        
        // 设置下来刷新控件
        
        refreshControl = freshControl
        
        // 注册显示图片浏览器的通知
        NSNotificationCenter.defaultCenter().addObserverForName(YJShowPhotoBrowerNotification, object: nil, queue: nil) { (notice) in
            
            
            if let info = notice.userInfo {
            
                //通知处理
                let photoBrowserVC = YJPhotoBrowseViewController()
                photoBrowserVC.sourceImageURLs = info[YJLargeURLSkey] as?[NSURL]
                photoBrowserVC.clickIndex = (info[YJIndexKey] as! NSIndexPath).row
                
                self.presentViewController(photoBrowserVC, animated: true, completion: nil)
                
            }
            
        }
        
        
        // 请求数据
        loadData()
        
       
    
        
        
    }
    
    //MARK: 移除通知
    deinit {
    
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
    
    func freshAction(freshControl:UIRefreshControl) {
        
        print("刷新好不好")
        
        // 设置为刷新为true
        refresh = true
        
        // 
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        if var  lastTime = userDefault.objectForKey(lastFreshTimeKey){
        
            lastTime = "上次刷新时间:" + (lastTime as! String)
            
            freshControl.attributedTitle = NSAttributedString(string: lastTime as!String)
        }
        
        //获取当前时间
        let currentTime = NSDate()
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-hh:mm"
        
        let dateString = formatter.stringFromDate(currentTime)
        
        //保存当前时间
        userDefault .setObject(dateString, forKey: lastFreshTimeKey)

        
        
        // 加载数据
        loadData()
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
    private func loadData() {
    
        let path = "https://api.weibo.com/2/statuses/public_timeline.json"
        let para = ["access_token":YJUserAccount.loadAccount()?.access_token as!AnyObject]
        Alamofire.request(.GET, path, parameters: para, encoding:.URL, headers: nil).responseJSON { (respon) in
            
            
            print(respon.result)
            
            if let json = respon.result.value {
            
                print(json)
                
                self.freshControl.endRefreshing()
                
                let dict = json as![String:AnyObject]
                
                let arr = dict["statuses"] as![AnyObject]
                
                // 创建一个临时数组
                var tempArr = [AnyObject]()
                
                for dic in arr as![[String:AnyObject]]{
                
                
                    let status = YJStatus(dict:dic)
                    
                   tempArr.append(status)
                    
                }
                
                //如果是下拉刷新，插入最新的数据
                if self.refresh {
                    
                    //如果是刷新显示刷新了多少条微博
                    UIView.animateWithDuration(2, animations: {
                            self.newStatusTipsLabel.hidden = false
                            self.newStatusTipsLabel.alpha = 1.0
                            self.newStatusTipsLabel.text = "最新\(tempArr.count)条微博"
                        }, completion: { (_) in
                            
                            self.newStatusTipsLabel.hidden = true
                            self.newStatusTipsLabel.alpha = 0.0
                    })
                    
                    
                    for tempStatus in tempArr as![YJStatus] {
                    
                        self.statusArry.insert(tempStatus, atIndex: 0)
                    }
                }
                
                
                // 不是下拉，就是加载数据和上拉加载更多的情况
                for tempStatus in tempArr as![YJStatus] {
                    
                    self.statusArry.append(tempStatus)
                }
                
                
                
                self.tableView.reloadData()
                
                
            }
            else {
            
                self.freshControl.endRefreshing()
            }
            
        }
        
    }
    
    
    //MARK:懒加载
    private lazy var  rowCache:[Int:CGFloat] = [Int:CGFloat]()
    
    private lazy var calCell:YJStatusCell = YJStatusCell()
    
    //下来刷新控件
    private lazy var freshControl:UIRefreshControl = {
    
       
        let fresh = UIRefreshControl()
        
        fresh.attributedTitle = NSAttributedString(string:"刷新")
        fresh.addTarget(self, action: "freshAction:", forControlEvents: .ValueChanged)
        
        return fresh
    }()
    
    //显示刷新微博的数量的Label
    private lazy var newStatusTipsLabel:UILabel = {
    
        let label = UILabel()
        
        label.backgroundColor = UIColor.yj_color(254, G: 126, B: 0)
        label.hidden = true
        label.alpha = 0.0
        label.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        return label
    }()
    
    
}



extension YJMainViewController{

    //
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statusArry.count
        
       
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        //判断是不是最后一个cell，如果是最好一个就加载更多数据
        
        if (indexPath.row == (statusArry.count - 1)) {
            
            print("我他妈是最后一个cell了能不能给我加载数据呢")
            refresh = false
            
            loadData()
        }
        
        let cell  = tableView.dequeueReusableCellWithIdentifier(resuesID, forIndexPath: indexPath) as! YJStatusCell
    
        let  status = statusArry[indexPath.row]
        cell.status = status
      
        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
    
        let status = statusArry[indexPath.row]
    
        let height = calCell.getCellHeight(status)
        //缓存高度
        print("计算高度")
        return height
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("点击事件了")
    }
    
    
    
}
