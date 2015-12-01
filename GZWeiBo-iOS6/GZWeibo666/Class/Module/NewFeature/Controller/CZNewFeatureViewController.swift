//
//  CZNewFeatureViewController.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

/// 新特性界面,使用UICollectionView
class CZNewFeatureViewController: UICollectionViewController {
    
    // MARK: - 属性
    private let ReuseIdentifier = "ReuseIdentifier"
    /// 流水布局
    private var flowlayout = UICollectionViewFlowLayout()
    
    private let ImageCount = 4
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 实现空参数的构造函数
    init() {
        // 调用需要流水布局的构造函数,自己来提供流水布局
        super.init(collectionViewLayout: flowlayout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareCollectionView()
    }
    
    private func prepareCollectionView() {
        // collectionView注册cell
        collectionView?.registerClass(CZNewFeatureCell.self, forCellWithReuseIdentifier: ReuseIdentifier)
        
        // 设置布局
        // item大小
        flowlayout.itemSize = view.bounds.size
        
        // 滚动方向
        flowlayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 设置间距为0
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.minimumLineSpacing = 0
        
        // 分页
        collectionView?.pagingEnabled = true
        
        // 取消弹簧效果
        collectionView?.bounces = false
    }
    
    // 返回多少组
//    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 0
//    }
    
    // CollectionView要显示数据需要实现数据源方法
    /// CollectionView显示cell的数量
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageCount
    }
    
    /// 每个cell显示什么内容
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // dequeueReusableCellWithReuseIdentifier: 从缓存池中加载cell,如果缓存池中没有就使用注册的cell类型来创建一个cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifier, forIndexPath: indexPath) as! CZNewFeatureCell
        
        cell.index = indexPath.item
        
        return cell
    }
    
    // 停下来,判断是最后一个cell的时候才做动画
    
    // 一个cell,colllectionView停下来,cell不可见的时候
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//        print("didEndDisplayingCell: \(indexPath)")
        
        // 获取正在显示的cell的indexPath
        let visibleIndexPath = collectionView.indexPathsForVisibleItems().last!
        // 在collectionView停下来,我们自己来判断是否是最后一个cell
        if visibleIndexPath.item == ImageCount - 1 {
            // 显示的是最后一个cell
            
            // 根据indexPath获取cell
            let cell = collectionView.cellForItemAtIndexPath(visibleIndexPath) as! CZNewFeatureCell
            cell.startButtonAnimation()
        }
    }
}

/// 自定义cell,显示图片
class CZNewFeatureCell: UICollectionViewCell {
    
    // MARK: - 属性
    /// 第几个cell
    var index: Int = 0 {
        didSet {
            // 根据是第几个cell显示对应的图片
            bkgImageView.image = UIImage(named: "new_feature_\(index + 1)")
            
            startButton.hidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareUI()
    }
    
    // MARK: - 按钮点击事件
    func buttonClick() {
        // 切换控制器
//        (UIApplication.sharedApplication().delegate as? AppDelegate)?.switchViewController(true)
        AppDelegate.switchRootViewController(true)
    }
    
    func startButtonAnimation() {
        // 显示按钮
        startButton.hidden = false

        // 设置按钮X/Y缩放都为0
        startButton.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(1, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            // 设置X/Y缩放都为1, 清空到原始状态(X/Y缩放都为1)
            self.startButton.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                print("动画完成")
        }
    }
    
    private func prepareUI() {
        // 添加子控件
        contentView.addSubview(bkgImageView)
        contentView.addSubview(startButton)
        
        // 添加约束
        bkgImageView.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 填充父控件
        
        // 哪个view要添加约束,就哪个来调用
        bkgImageView.ff_Fill(contentView)
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[biv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["biv" : bkgImageView]))
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[biv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["biv" : bkgImageView]))
        
        // 开始按钮
        
        startButton.ff_AlignInner(type: ff_AlignType.BottomCenter, referView: contentView, size: nil, offset: CGPoint(x: 0, y: -160))
        
//        contentView.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
//        contentView.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -160))
    }
    
    // MARK: - 懒加载
    /// 图片
    private lazy var bkgImageView: UIImageView = UIImageView(image: UIImage(named: "new_feature_1"))
    
    /// 开始按钮
    private lazy var startButton: UIButton = {
        let button = UIButton()
        
        // 设置背景
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        
        // 设置文字
        button.setTitle("开始体验", forState: UIControlState.Normal)
        
        // 添加点击事件
        button.addTarget(self, action: "buttonClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
}







