//
//  CZStatusCell.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/27.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

// 全局都可以访问
let CZStatusCellMargin: CGFloat = 8

// 原创和转发cell的父类
class CZStatusCell: UITableViewCell {
    // MARK: 属性
    /// 微博模型
    var status: CZStatus? {
        didSet {
            // 将模型赋值给顶部视图,顶部视图就可以显示内容
            topView.status = status
            
            // cell 微博内容
            contentLabel.text = status?.text
            
            // 设置配图视图的模型
            pictureView.status = status
            
            // 计算配图视图的宽高
            let size = pictureView.calcViewSize()
//            print("配图的size: \(size)")
            
            // 设置配图视图的宽高
            pictureViewWidthCon?.constant = size.width
            pictureViewHeightCon?.constant = size.height
            
//            // 测试改变配图视图高度
//            let count = arc4random_uniform(4)
//            let height = count * 90
//            pictureViewHeightCon?.constant = CGFloat(height)
        }
    }
    
    /// 配图的宽度约束
    var pictureViewWidthCon: NSLayoutConstraint?
    
    /// 配图的高度约束
    var pictureViewHeightCon: NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prepareUI()
    }
    
    // MARK: - 计算行高
    /// 计算行高
    func rowHeight(status: CZStatus) -> CGFloat {
        // 根据模型来设置内容, 当我们把传入进来的模型赋值给self.status cell里面的内容被设置成为status的内容
        self.status = status
        
        // 根据新的内容更新约束
        self.layoutIfNeeded()
        
        // 获取底部视图的最大Y值(cell的高度)
        return CGRectGetMaxY(bottomView.frame)
    }
    
    // MARK: - 准备UI
    func prepareUI() {
        // 添加子控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(bottomView)
        
        // 添加约束
        /// 顶部控件, 在contentView内部,左上没有偏移
        topView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 53))
        
        /// 微博内容在 顶部控件 左下
        contentLabel.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint(x: CZStatusCellMargin, y: CZStatusCellMargin))
        /// 宽度
        contentView.addConstraint(NSLayoutConstraint(item: contentLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: UIScreen.mainScreen().bounds.width - 2 * CZStatusCellMargin))
        
//        /// 配图视图约束, 在contentLabel,左下,宽高 290
//        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: CZStatusCellMargin))
//        
//        // 获取配图视图的宽高约束
//        pictureViewWidthCon = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
//        pictureViewHeightCon = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        
        /// 底部视图.在contentLabel的左下
        bottomView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44), offset: CGPoint(x: -CZStatusCellMargin, y: CZStatusCellMargin))
        
        /// cell的高度根据子控件来确定,需要约束顶部和底部
        /// 约束cell的底部和bottomView的底部重合
//        contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: bottomView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
    }

    // MARK: - 懒加载
    /// 顶部视图
    private lazy var topView: CZStatusTopView = CZStatusTopView()
    
    /// 微博文本内容
    lazy var contentLabel: UILabel = {
        let label = UILabel(color: UIColor.darkGrayColor(), fontSize: 14)
        
        // 设置换行
        label.numberOfLines = 0
        
        return label
    }()
    
    /// 底部视图
    lazy var bottomView: CZStatusBottomView = CZStatusBottomView()
    
    /// 配图视图
    /// 配图的宽高由 配图视图根据图片的张数来计算,如果没有图片的时候,将配图的宽高设置为0
    lazy var pictureView: CZPictureView = CZPictureView()
}
