//
//  YJTitleButton.swift
//  YJWeibo
//
//  Created by pan on 16/8/21.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit

class YJTitleButton: UIButton {

  
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // Swift中可以这样写
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.size.width
    }

}
