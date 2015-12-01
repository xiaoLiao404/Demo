//
//  UIButton+Extension.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/30.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

extension UIButton {
    
    // 在扩展里面构造函数只能是便利构造函数
    /**
    快速创建按钮
    
    - parameter imageName: 按钮图片的名称
    - parameter title:     按钮的标题
    - parameter textColor: 按钮标题的颜色
    - parameter fontSize:  按钮标题的大小
    
    - returns: UIButton
    */
    convenience init(imageName: String, title: String, textColor: UIColor = UIColor.lightGrayColor(), fontSize: CGFloat = 12) { // 给默认的值,需要放在参数列表的最后面
        self.init()
        
        // 按钮图片
        self.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        
        // 按钮文字
        self.setTitle(title, forState: UIControlState.Normal)
        
        // 文字颜色
        self.setTitleColor(textColor, forState: UIControlState.Normal)
        
        // 文字大小
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
}
