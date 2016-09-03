//
//  UIColor+YJAdd.swift
//  YJWeibo
//
//  Created by pan on 16/9/3.
//  Copyright © 2016年 yj. All rights reserved.
//

import UIKit

extension UIColor {

    
    internal class func yj_color(R:CGFloat,G:CGFloat,B:CGFloat ) ->UIColor {
    
        return yj_color(R, G: G, B: B, alpha: 1.0)
        
    }
    
    internal class func yj_color(R:CGFloat,G:CGFloat,B:CGFloat ,alpha:CGFloat) ->UIColor {
    
        
        return UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: alpha)
    }
    
    internal class func yj_randomColor() -> UIColor {
    
        let r = CGFloat(arc4random_uniform(255)+1)
        
        let g = CGFloat(arc4random_uniform(255)+1)
        
        let b = CGFloat(arc4random_uniform(255)+1)
        
        
        
        return yj_color(r, G: g, B: b)
    }
}
