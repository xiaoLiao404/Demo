
//
//  UILabel+Extension.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/27.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

/// 扩展UILabel
extension UILabel {
    
    /**
    便利构造函数,创建Label
    
    - parameter color:    文字颜色
    - parameter fontSize: 文字大小
    
    - returns: Label
    */
    convenience init(color: UIColor, fontSize: CGFloat) {
        self.init()
        
        // 设置颜色
        self.textColor = color
        
        // 设置字体
        self.font = UIFont.systemFontOfSize(fontSize)
    }
}
