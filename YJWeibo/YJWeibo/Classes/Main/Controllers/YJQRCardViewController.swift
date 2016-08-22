//
//  YJQRCardViewController.swift
//  YJWeibo
//
//  Created by pan on 16/8/22.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit
import SnapKit
class YJQRCardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    
        navigationItem.title = "我的名片"
        
        //添加二维码图片
        view.addSubview(QRCardImageView)
        
        
        //生成二维码Image
        
        let qrCodeImage = crateQRCodeImage("大杰哥")
        
        //显示
        
        QRCardImageView.image = qrCodeImage
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        QRCardImageView.snp_makeConstraints(closure: { (make) in
            
            make.size.equalTo(CGSizeMake(200, 200))
            make.center.equalTo(self.view)
            
        })
    }
    

    //MARK:生成二维image
    private func crateQRCodeImage(QRString:String)->UIImage {
    
        //1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 设置默认属性
        filter?.setDefaults()
        
        //设置需要生成二维码的数据
        filter?.setValue(QRString.dataUsingEncoding(NSUTF8StringEncoding), forKey: "inputMessage")
        
        
        //从滤镜中取出生成好的图片
        let ciImage = filter?.outputImage
        
        
        //将模糊的生成高清的
        
         let bgImage = createNonInterpolatedUIImageFormCIImage(ciImage!, size: 200)
        
        
        //创建一个头像
        let iconImage = UIImage(named: "timg.jpg")
        
        
        // 将二维图片和头像合成一张新的图片
        let newImage = creteImage(bgImage, iconImage: iconImage!)
        
        return newImage
        
        
        
    }
    
    /**
     合成图片
     
     :param: bgImage   背景图片
     :param: iconImage 头像
     */
    private func creteImage(bgImage: UIImage, iconImage: UIImage) -> UIImage
    {
        // 1.开启图片上下文
        UIGraphicsBeginImageContext(bgImage.size)
        // 2.绘制背景图片
        bgImage.drawInRect(CGRect(origin: CGPointZero, size: bgImage.size))
        // 3.绘制头像
        let width:CGFloat = 50
        let height:CGFloat = width
        let x = (bgImage.size.width - width) * 0.5
        let y = (bgImage.size.height - height) * 0.5
        iconImage.drawInRect(CGRect(x: x, y: y, width: width, height: height))
        // 4.取出绘制号的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 5.关闭上下文
        UIGraphicsEndImageContext()
        // 6.返回合成号的图片
        return newImage
    }
    
    /**
     根据CIImage生成指定大小的高清UIImage
     
     :param: image 指定CIImage
     :param: size    指定大小
     :returns: 生成好的图片
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = CGRectIntegral(image.extent)
        let scale: CGFloat = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        
        // 1.创建bitmap;
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef,  CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale);
        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }

    
    
    //MARK:懒加载
    private lazy var QRCardImageView:UIImageView = {
    
        let qrImageView = UIImageView()
        
      
        
        return qrImageView
    }()
    
    


}
