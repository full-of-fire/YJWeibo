//
//  YJQCRScannerViewController.swift
//  YJWeibo
//
//  Created by pan on 16/8/21.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit
import AVFoundation
class YJQCRScannerViewController: UIViewController,UITabBarDelegate {

    @IBOutlet weak var coustomTabBar: UITabBar!
    @IBOutlet weak var scannerLineConstraint: NSLayoutConstraint! // 扫描线的顶部约束
    
    @IBOutlet weak var contentViewHeighCons: NSLayoutConstraint!  //容器视图的高度约束
    
    @IBOutlet weak var sannerLineImageView: UIImageView! // 扫描线
    
    var timer:CADisplayLink? // 定义一个定时器
    
    
    
    
    //MARK:viewLife
    override func viewDidLoad() {
       
        super.viewDidLoad()

        // 设置其默认选中第一个
        coustomTabBar.selectedItem = coustomTabBar.items![0]
        coustomTabBar.delegate = self
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(animated)
        
        //开始动画
        startAnimation()
        
        // 开始扫描
        startScaning()
    }
    
    
    
    //MARK:UITabBarDelegate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        if item.tag == 1 {
            //二维码
            contentViewHeighCons.constant = 300
        }
        else {
        
            contentViewHeighCons.constant = 150
        }
        
        sannerLineImageView.layer.removeAllAnimations()
        
        
        //重新开始动画
        startAnimation()
    }

   
    //MARK:关闭点击事件
    @IBAction func closeAction(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // 设置冲击波的动画
    private func startAnimation (){
    
        
        scannerLineConstraint.constant = -contentViewHeighCons.constant
        sannerLineImageView.layoutIfNeeded()
//        UIView .animateWithDuration(2.0) {
//            
//            self.scannerLineConstraint.constant = 0
//            UIView.setAnimationRepeatCount(MAXFLOAT)
//            self.sannerLineImageView.layoutIfNeeded()
//        }
        
        timer = CADisplayLink(target: self ,selector: "updateScanline")
        let runloop = NSRunLoop.currentRunLoop()
        
        timer?.addToRunLoop(runloop, forMode: NSRunLoopCommonModes)
        timer?.frameInterval = 3
    }
    
    func updateScanline() {
    
        scannerLineConstraint.constant += 10;
        
        if scannerLineConstraint.constant == 0 {
            
            self.scannerLineConstraint.constant = -contentViewHeighCons.constant
            
            
        }
    }
    
    //MARK: 开启扫描
    private func startScaning() {
    
        
        // 如果输入和输出不能添加到会话直接返回
        if !captureSession.canAddInput(deviceInput) {
            return
        }
        
        if !captureSession.canAddOutput(output) {
            
            return
        }
        
        //分别加输入和输出添加到会话层
        captureSession.addInput(deviceInput)
        captureSession.addOutput(output)
        
        // 设置输出对象的能够解析的类型
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        //设置输出代理
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        
        // 添加预览图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        
        // 开始扫描
        captureSession.startRunning()
        
    }
    
    
    
    //MARK：懒加载
    
    // 会话
    private lazy var captureSession:AVCaptureSession = AVCaptureSession()
    
    // 获取输入设备
    private lazy var deviceInput:AVCaptureDeviceInput? = {
    
       //获取摄像头
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
        
            let deviceInput = try AVCaptureDeviceInput(device: device)
            return deviceInput
            
        }catch {
        
            print(error)
            
            return nil
            
        }
        
    }()
    
    //创建输出对象
    private lazy var output:AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    
    // 创建预览图层
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
    

}



extension YJQCRScannerViewController:AVCaptureMetadataOutputObjectsDelegate {
    
    internal func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
    
        
        print(metadataObjects)
    }
    
}
