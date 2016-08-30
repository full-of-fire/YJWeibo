//
//  YJStatusBottomToolBar.swift
//  YJWeibo
//
//  Created by pan on 16/8/30.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit

class YJStatusBottomToolBar: UIView {

    
    //MARK:创建底部工具栏
    internal class func statusBottomToolBar () -> YJStatusBottomToolBar {
    
        return NSBundle.mainBundle().loadNibNamed("YJStatusBottomToolBar", owner: nil, options: nil).first as! YJStatusBottomToolBar
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }

}
