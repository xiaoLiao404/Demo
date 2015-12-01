//
//  CZHomeTitleButton.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

class CZHomeTitleButton: UIButton {
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String) {
        super.init(frame: CGRectZero)
        
        self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        self.setTitle(title, forState: UIControlState.Normal)
        
        self.setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        
        self.sizeToFit()
    }
    
    /// 系统调用
    override func layoutSubviews() {
        // 一定要调用父类的方法,不然子控件都看不到了
        super.layoutSubviews()
        
        // 交换按钮的标题和图片的位置
//        var frame = titleLabel?.frame
//        frame?.origin.x = 0
//        titleLabel?.frame = frame!
        
        // 将标题移到最左边
        titleLabel?.frame.origin.x = 0
        
        // 将图片移到titleLabel的右边
        imageView?.frame.origin.x = titleLabel!.frame.width + 3
    }
}
