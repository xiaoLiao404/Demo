//
//  CZTabbar.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/22.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

class CZTabbar: UITabBar {

    // 系统调用
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        // 计算item的宽度
        let width = bounds.size.width / 5
        
        // 创建frame
        let frame = CGRect(x: 0, y: 0, width: width, height: bounds.size.height)
        
        // 记录是第几个view
        var index = 0
        // 重新设置按钮位置(UITabBarButton)
        for view in self.subviews {
            if view is UIControl && !(view is UIButton) {  // 撰写按钮不需要来设置frame, 忽略撰写按钮
                // 只有系统的UITabBarButton需要设置frame
//                print("子控件:\(view)")
                // 设置frame   CGRectOffset可以平移frame
                view.frame = CGRectOffset(frame, CGFloat(index) * width, 0)
                
//                index++
//                if index == 2 {
//                    index++
//                }
                index += index == 1 ? 2 : 1
            }
        }
        
        // 设置撰写按钮的frame
        composeButton.frame = CGRectOffset(frame, 2 * width, 0)
    }

    // 懒加载
    /// 撰写按钮
    lazy var composeButton: UIButton = {
        let button = UIButton()
        
        // 设置参数
        // 设置按钮背景图片
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        // 设置按钮图片
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        // 添加到tabbar里面
        self.addSubview(button)
        
        return button
    }()
}
