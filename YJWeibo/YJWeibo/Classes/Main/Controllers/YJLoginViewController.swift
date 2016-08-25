//
//  YJLoginViewController.swift
//  YJWeibo
//
//  Created by pan on 16/8/24.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class YJLoginViewController: UIViewController {

    let ReBackURL:String = "https://api.weibo.com/oauth2/default.html" // 回调的URL
    
    let AppKey:String = "2100191772" // 程序appkey
    
    let AppSecret:String = "20701cb27e6279060eae21c1a7522f8c" // APPSecret
    
    let BaseURL:String = "https://api.weibo.com/"
    
    override func loadView() {
        super.loadView()
        
        webView.frame = view.bounds
        
        view = webView
        
    }
    
    
    //MARK:View视图的生命周期
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置标题
        navigationItem.title = "登录"
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(AppKey)&redirect_uri=\(ReBackURL)";
        
        let url = NSURL(string: urlString)
        
        let request = NSURLRequest(URL: url!)
        
        webView.loadRequest(request)
        
        
       
    }
    
    //MARK:懒加载
    lazy var webView:UIWebView = {
    
       
        let webView = UIWebView()
        
        
        
        webView.delegate = self
        
        return webView
    }()

   
}


// MARK:UIWebViewDelegate
extension YJLoginViewController:UIWebViewDelegate {

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    
        
        let urlString:String = request.URL!.absoluteString
        
        if !urlString.hasPrefix(ReBackURL) {
            
            //如果不是回调Url就继续加载
            return true
        }
        
        // 判断是否授权成功
        let parameterStr = "code="
        if request.URL!.query!.hasPrefix(parameterStr) {
            
            //授权成功,取出code的参数用于
            print(request.URL!.query!)
        
            let code = request.URL!.query!.substringFromIndex(parameterStr.endIndex)
            
            // 获取accessToken
            
            requestAccessToken(code)
            
            
            
        }
        else {
        
            navigationController?.popViewControllerAnimated(true)
        }
        
        
        return false
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        // 提示用户正在加载
        SVProgressHUD.showInfoWithStatus("正在加载...", maskType: SVProgressHUDMaskType.Black)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // 关闭提示
        SVProgressHUD.dismiss()
    }

    
    private func requestAccessToken(code:String){
    
        //
        let accessTokenPath = "https://api.weibo.com/oauth2/access_token"
        
        // 参数
        let params = ["client_id":AppKey,"client_secret":AppSecret,"grant_type":"authorization_code","code":code,"redirect_uri":ReBackURL]
        
        
        Alamofire.request(.POST, accessTokenPath, parameters: params, encoding: .URL, headers: nil).responseJSON { (response) in
            
            print(response.request)
            
            print(response.response)
            
            print(response.data)
            
            print(response.result)
            
            if let json = response.result.value {
            
                print("json\(json)")
                
                let userAccount = YJUserAccount(dict: json as![String:AnyObject])
                
                print(userAccount.access_token)
                userAccount.loginSuccess = true
                
                userAccount.savaAccount()
                
                //获取accessToken成功，证明登录成功了
                let base = YJBaseTabBarViewController()
                base.selectedIndex = 1
                
                UIApplication.sharedApplication().keyWindow?.rootViewController = base
                
                SVProgressHUD.showInfoWithStatus("登录成功")
                
            }
            
            
        }
    }
}
