//
//  UIBarButton+Extension.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    // 在 extension 构造函数只能是 便利构造函数
    // 构造函数每个参数都有外部参数名
    
    /**
    创建一个带按钮的UIBarButtonItem
    
    - parameter imageName: 普通的图片名称
    
    - returns: UIBarButtonItem
    */
    convenience init(imageName: String) {
        let button = UIButton()

        button.setBackgroundImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "\(imageName)_highlighted"), forState: UIControlState.Highlighted)

        button.sizeToFit()
        
        // 需要调用本类的指定构造函数
        self.init(customView: button)
    }
    
    /**
    创建一个带按钮的UIBarButtonItem
    
    - parameter imageName: 普通的图片名称
    
    - returns: UIBarButtonItem
    */
//    class func createBarbutton(imageName: String) -> UIBarButtonItem {
//        let button = UIButton()
//        
//        button.setBackgroundImage(UIImage(named: imageName), forState: UIControlState.Normal)
//        button.setBackgroundImage(UIImage(named: "\(imageName)_highlighted"), forState: UIControlState.Highlighted)
//        
//        button.sizeToFit()
//        
//        return UIBarButtonItem(customView: button)
//    }
}