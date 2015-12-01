//
//  CZStatusBottomView.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/28.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

class CZStatusBottomView: UIView {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareUI()
    }

    // MARK: - 准备UI
    private func prepareUI() {
        backgroundColor = UIColor(white: 0.98, alpha: 1)
        
        // 添加子控件
        addSubview(forwardButton)
        addSubview(commentButton)
        addSubview(likeButton)
        addSubview(sImageViewFirst)
        addSubview(sImageViewSecond)
        
        // 添加约束
        /// 平铺子控件
        /// self: 父控件
        /// views: 哪些子控件要平铺
        /// insets边距
        self.ff_HorizontalTile([forwardButton, commentButton, likeButton], insets: UIEdgeInsetsZero)
        
        sImageViewFirst.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: forwardButton, size: nil)
        
        sImageViewSecond.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: commentButton, size: nil)
    }
    
    // MARK: - 懒加载
    /// 转发按钮
    private lazy var forwardButton: UIButton = UIButton(imageName: "timeline_icon_retweet", title: "转发")
//    private lazy var forwardButton: UIButton = {
//        let button = UIButton()
//        
//        // 按钮图片
//        button.setImage(UIImage(named: "timeline_icon_retweet"), forState: UIControlState.Normal)
//        
//        // 按钮文字
//        button.setTitle("转发", forState: UIControlState.Normal)
//        
//        // 文字颜色
//        button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
//        
//        // 文字大小
//        button.titleLabel?.font = UIFont.systemFontOfSize(12)
//        
//        return button
//    }()
    
    /// 评论按钮
    private lazy var commentButton: UIButton = UIButton(imageName: "timeline_icon_comment", title: "评论")
//    private lazy var commentButton: UIButton = {
//        let button = UIButton()
//        
//        // 按钮图片
//        button.setImage(UIImage(named: "timeline_icon_comment"), forState: UIControlState.Normal)
//        
//        // 按钮文字
//        button.setTitle("评论", forState: UIControlState.Normal)
//        
//        // 文字颜色
//        button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
//        
//        // 文字大小
//        button.titleLabel?.font = UIFont.systemFontOfSize(12)
//        
//        return button
//    }()
    
    /// 赞按钮
    private lazy var likeButton: UIButton = UIButton(imageName: "timeline_icon_unlike", title: "赞")
//    private lazy var likeButton: UIButton = {
//        let button = UIButton()
//        
//        // 按钮图片
//        button.setImage(UIImage(named: "timeline_icon_unlike"), forState: UIControlState.Normal)
//        
//        // 按钮文字
//        button.setTitle("赞", forState: UIControlState.Normal)
//        
//        // 文字颜色
//        button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
//        
//        // 文字大小
//        button.titleLabel?.font = UIFont.systemFontOfSize(12)
//        
//        return button
//    }()
    
    /// 分割线1
    private lazy var sImageViewFirst: UIImageView = UIImageView(image: UIImage(named: "timeline_card_bottom_line_highlighted"))
    
    /// 分割线2
    private lazy var sImageViewSecond: UIImageView = UIImageView(image: UIImage(named: "timeline_card_bottom_line_highlighted"))
}
