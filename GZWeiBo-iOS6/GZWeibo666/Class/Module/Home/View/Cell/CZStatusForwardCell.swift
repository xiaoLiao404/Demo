//
//  CZStatusForwardCell.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/28.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

// 转发cell
class CZStatusForwardCell: CZStatusCell {

    // 子类覆盖父类的属性
    // 1.添加 override关键字
    // 2.实现属性监视器
    // 3.先调父类的属性监视器,在调子类的属性监视器
    override var status: CZStatus? {
        didSet {
            // 设置被转发微博的内容
            // 1.被转发为微博的文本 =  "@"被转发微博的作者: 被转发微博的内容
            let name = status?.retweeted_status?.user?.screen_name ?? "被转发微博名称为空"
            let retweetText = status?.retweeted_status?.text ?? "被转发微博内容为空"
            let text = "@" + name + ":" + retweetText
            
            forwardLabel.text = text
        }
    }
    
    // 覆盖父类的方法
    override func prepareUI() {
        super.prepareUI()
        
        // 添加子类自己特有的空间, 0是插入到最底部
        contentView.insertSubview(bkgButton, atIndex: 0)
        contentView.addSubview(forwardLabel)
        
        // 设置约束
        // 背景按钮,在contentLabel的垂直左下,在bottomView垂直方向的右上
        bkgButton.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: nil, offset: CGPoint(x: -CZStatusCellMargin, y: CZStatusCellMargin))
        bkgButton.ff_AlignVertical(type: ff_AlignType.TopRight, referView: bottomView, size: nil, offset: CGPoint(x: 0, y: 0))
        
        // 约束label
        forwardLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: bkgButton, size: nil, offset: CGPoint(x: CZStatusCellMargin, y: CZStatusCellMargin))
        // 宽度约束
        contentView.addConstraint(NSLayoutConstraint(item: forwardLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: UIScreen.mainScreen().bounds.width - 2 * CZStatusCellMargin))
        
        /// 配图视图约束, 在contentLabel,左下,宽高 290
        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: forwardLabel, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: CZStatusCellMargin))
        
        // 获取配图视图的宽高约束
        pictureViewWidthCon = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureViewHeightCon = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
    }
    
    // MARK: - 懒加载
    /// 背景,按钮
    private lazy var bkgButton: UIButton = {
        let button = UIButton()
        
        // 设置背景颜色
        button.backgroundColor = UIColor(white: 0.8, alpha: 1)
        
        return button
    }()
    
    /// lable,显示被转发微博内容
    private lazy var forwardLabel: UILabel = {
        let label = UILabel(color: UIColor.lightGrayColor(), fontSize: 14)
        
        // 设置显示多行
        label.numberOfLines = 0
        
        return label
    }()
}
