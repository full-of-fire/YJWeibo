//
//  YJPhotoBrowseViewController.swift
//  YJWeibo
//
//  Created by pan on 16/9/3.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

let YJPhotoBrowseViewReuseID = "YJPhotoBrowseViewReuseID"
class YJPhotoBrowseViewController: UIViewController {

    
    // 图片数组
    var sourceImageURLs:[NSURL]?{
    
        didSet {
        
            collectView.contentSize = CGSizeMake(CGFloat(sourceImageURLs!.count)*UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        }
    }
    
    // 点击图片的所在索引
    var clickIndex:Int? {
    
        didSet {
        
            topLabel.text = "\(clickIndex! + 1)/\(sourceImageURLs!.count)"
            
            let offSetX = (CGFloat(clickIndex!)*UIScreen.mainScreen().bounds.size.width)
            
            print(offSetX)
            collectView.contentOffset = CGPointMake(offSetX, 0)
        }
    }
    
    // 记录当前选中的索引
    var currentSelectedIndex:Int = 0
    
    
    //记录需要保存的图片
    var saveImage:UIImage?
    
    
    override func loadView() {
        
        super.loadView()
//        
//        collectView.frame = view.bounds
//        
//        view = collectView
    }
    
    //MARK: - viewLife
    override func viewDidLoad() {
        super.viewDidLoad()

        //注册cell
        collectView.registerClass(YJPhotoBrowserCell.self , forCellWithReuseIdentifier: YJPhotoBrowseViewReuseID)
        
        //添加collectionView
        collectView.frame = view.bounds
        view.addSubview(collectView)
        
        //添加Label
        view.addSubview(topLabel)
        topLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(20)
        }
        
        

    
        
  
      
    }
    
    //MARK: - 懒加载
    private lazy var  collectView:UICollectionView = {
    
        let collectView = UICollectionView.init(frame: CGRectZero, collectionViewLayout: YJPhotoBrowserLayout())
        
        collectView.dataSource = self
        collectView.delegate = self
    
        return collectView
    }()
    
   private  lazy var topLabel:UILabel = {
    
        let label = UILabel()
        label.textColor = UIColor.lightGrayColor()
        label.textAlignment = NSTextAlignment.Center
        return label
    }()

   

}

extension YJPhotoBrowseViewController:UICollectionViewDataSource,UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return sourceImageURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectView.dequeueReusableCellWithReuseIdentifier(YJPhotoBrowseViewReuseID, forIndexPath: indexPath) as! YJPhotoBrowserCell
        
        cell.backgroundColor = UIColor.yj_randomColor()
        
        cell.photoURL = sourceImageURLs![indexPath.row]
        
        
        // 图片的点击事件
        cell.imageClick = {
        
            //dismiss
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        // 长按保存图片的点击事件
        cell.imageLongPress = {
        
            (saveImage:UIImage)->() in
        
            self.saveImage = saveImage
            //保存图片到相册
            let alertView = UIAlertView()

            alertView.message = "保存图片到相册?"
            alertView.addButtonWithTitle("取消")
            alertView.addButtonWithTitle("保存")
            alertView.delegate = self
            alertView.show()
            
            
        }
        
        
        return cell
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let page = scrollView.contentOffset.x / UIScreen.mainScreen().bounds.size.width + 0.5
        
        currentSelectedIndex = Int(page)
        
       
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        clickIndex = currentSelectedIndex
    }
    
    
    
}


extension YJPhotoBrowseViewController:UIAlertViewDelegate {

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == 1 {
            
            print("真的需要保存图片到相册了")
            
            UIImageWriteToSavedPhotosAlbum(saveImage!, self, "image:didFinishSavingWithError:contextInfo:", nil)
            
            //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
        }
    }
    
    func image(image:(UIImage),didFinishSavingWithError error:(NSError?) ,contextInfo:(AnyObject)){
    
        if error != nil {
            
            SVProgressHUD.showErrorWithStatus("保存失败", maskType: SVProgressHUDMaskType.Black)
        }
        else {
        
            SVProgressHUD.showSuccessWithStatus("保存成功", maskType: SVProgressHUDMaskType.Black)
        }
    }
}


//MARK:自定义布局
class YJPhotoBrowserLayout: UICollectionViewFlowLayout {
    
    
    override func prepareLayout() {
        super.prepareLayout()
        
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        itemSize = CGSizeMake(width, height)
        
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .Horizontal
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}

//MARK:- 自定义cell
class YJPhotoBrowserCell:UICollectionViewCell {

    
    var photoURL:NSURL?{
    
        didSet {
        
            
            // 重置起状态
            reset()
            
            // 下载图片
            SDWebImageManager.sharedManager().downloadWithURL(photoURL, options: SDWebImageOptions.HighPriority, progress:{ (totalSize, receiveSize) in
                
                
                SVProgressHUD.showProgress(Float(receiveSize)/Float(totalSize))
               
                if totalSize ==  receiveSize {
                    
                    SVProgressHUD.dismiss()
                }
                
            }) { (originImage, _, _, _) in
                
                
                if originImage == nil {
                
                    return
                }
                let originWidth = originImage.size.width
                let originHeight = originImage.size.height
                let screenWidth = UIScreen.mainScreen().bounds.size.width
                let screenHeight = UIScreen.mainScreen().bounds.size.height
                let realImageHeight = (originWidth/originHeight)*screenWidth
                
                if realImageHeight<screenHeight {
                     self.photeImageView.frame = CGRectMake(0, (screenHeight - realImageHeight)*0.5, screenWidth , realImageHeight)
                }else {
                
                    
                    self.photeImageView.frame = CGRectMake(0, 0, screenWidth, originHeight)
                    
                    self.backScrollView.contentSize = CGSizeMake(screenWidth, realImageHeight)
                }
                
                
                self.photeImageView.image = originImage
            }
           
        }
    }
    
    //图片单击一闭包
    var imageClick:(()->())?
    
    //图片长按闭包
    var imageLongPress:((saveImage:UIImage)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(backScrollView)
        backScrollView.frame = contentView.bounds
        
        backScrollView.minimumZoomScale = 0.5
        backScrollView.maximumZoomScale = 2
        backScrollView.delegate = self
        backScrollView.addSubview(photeImageView)
        
        //图片添加一个点击事件
        let tap = UITapGestureRecognizer.init(target: self, action: "tapClick")
        photeImageView.userInteractionEnabled = true
        photeImageView.addGestureRecognizer(tap)
        
        //给图片添加一个长按手势
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: "longPressAction:")
        photeImageView.addGestureRecognizer(longPressGesture)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:点击事件
    func tapClick() {
        
      imageClick?()
    }
    
    //MARK:长按点击事件
    func longPressAction(longPressGeture:UILongPressGestureRecognizer){
    
        
        let clickImageView = longPressGeture.view as! UIImageView
        if longPressGeture.state == .Ended {
            
            //长按收拾结束哦
            print("长按保存图片可以吗")
            imageLongPress?(saveImage:clickImageView.image!)
        }
    }
    
    
    //MARK:重置
    func reset()  {
        
        photeImageView.transform = CGAffineTransformIdentity
        
        backScrollView.contentOffset = CGPointZero
        backScrollView.contentSize = CGSizeZero
        
    
        
    }
    
    
    
    //MARK:懒加载
    private lazy var backScrollView:UIScrollView = UIScrollView()
    
    private lazy var photeImageView:UIImageView = UIImageView()
    
}


extension YJPhotoBrowserCell:UIScrollViewDelegate {

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return photeImageView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        
        print("我被缩放完啦.....")
        
        //每次缩放完后重新设置
        let screenW = UIScreen.mainScreen().bounds.size.width
        let screenH = UIScreen.mainScreen().bounds.size.height
        photeImageView.frame = CGRectMake((screenW - (view?.frame.size.width)!)*0.5, (screenH - (view?.frame.size.height)!)*0.5, (view?.frame.size.width)!, (view?.frame.size.height)!)
    }
}

