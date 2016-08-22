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
    
    
    //MARK:显示我的名片
    @IBAction func showMyCard(sender: UIButton) {
        
        let QRCardVc = YJQRCardViewController()
        
        navigationController?.pushViewController(QRCardVc, animated: true)
        
    }
    
    // 设置冲击波的动画
    private func startAnimation (){
    
        
        scannerLineConstraint.constant = -contentViewHeighCons.constant
        sannerLineImageView.layoutIfNeeded()

        timer = CADisplayLink(target: self ,selector: "updateScanline")
        let runloop = NSRunLoop.currentRunLoop()
        
        timer?.addToRunLoop(runloop, forMode: NSRunLoopCommonModes)
        timer?.frameInterval = 3
    }
    
    // 改变约束的方法
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
    
    // 创建聚焦的图层
    private lazy var focusLayer:CALayer = {
    
        let layer = CALayer()
        layer.frame = UIScreen.mainScreen().bounds
        return layer
        
    }()

}



extension YJQCRScannerViewController:AVCaptureMetadataOutputObjectsDelegate {
    
    internal func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
    
        
        
        
        print(metadataObjects)
        
        
        // 1、获取到扫描的数据
        let dataString = metadataObjects.last?.stringValue
        
        // 2.获取扫描到的二维码的位置
        // 2.1转换坐标
        for object in metadataObjects
        {
            // 2.1.1判断当前获取到的数据, 是否是机器可识别的类型
            if object is AVMetadataMachineReadableCodeObject
            {
                // 2.1.2将坐标转换界面可识别的坐标
                let codeObject = previewLayer.transformedMetadataObjectForMetadataObject(object as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
                // 2.1.3绘制图形
                drawCorners(codeObject)
            }
        }

        
        
    }
    
    
    /**
     绘制图形
     
     :param: codeObject 保存了坐标的对象
     */
    private func drawCorners(codeObject: AVMetadataMachineReadableCodeObject)
    {
        if codeObject.corners.isEmpty
        {
            return
        }
        
        // 1.创建一个图层
        let layer = CAShapeLayer()
        layer.lineWidth = 4
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        // 2.创建路径
        let path = UIBezierPath()
        var point = CGPointZero
        var index: Int = 0
        // 2.1移动到第一个点
        // 从corners数组中取出第0个元素, 将这个字典中的x/y赋值给point
        CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
        path.moveToPoint(point)
        
        // 2.2移动到其它的点
        while index < codeObject.corners.count
        {
            CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
            path.addLineToPoint(point)
        }
        // 2.3关闭路径
        path.closePath()
        
        // 2.4绘制路径
        layer.path = path.CGPath
        
        // 3.将绘制好的图层添加到drawLayer上
        focusLayer.addSublayer(layer)
    }
    /**
     清空边线
     */
    private func clearConers(){
        // 1.判断drawLayer上是否有其它图层
        if focusLayer.sublayers == nil || focusLayer.sublayers?.count == 0{
            return
        }
        
        // 2.移除所有子图层
        for subLayer in focusLayer.sublayers!
        {
            subLayer.removeFromSuperlayer()
        }
    }

    
}


