//
//  CZRefreshControl.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/30.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

/// 自定义刷新控件,继承系统的刷新控件
class CZRefreshControl: UIRefreshControl {
    
    // MARK: - 属性
    /// 箭头旋转的值
    private let RefreshControlRotationValue: CGFloat = -60
    
    /// 标记,记录箭头状态
    private var isUp = false
    
    // 覆盖刷新控件的frame, 当拖动tableView时,frame会不断的改变,tableView往下拖动,frame.origin.y是负数,而且越来越小
    override var frame: CGRect {
        didSet {
//            print("刷新控件的frame: \(frame)")
            
            // 当frame.origin.y > 0, 不用关心
            if frame.origin.y > 0 {
                // 刷新控件是被tableView挡住的,看不见
                return
            }
            
            // 判断刷新控件的刷新状态
            if refreshing {
                // 刷新控件进入刷新状态,调用refreshView开始旋转
                refreshView.startRotation()
            }
            
            // 当frame.origin.y > - 60 箭头向下
            // 当frame.origin.y < - 60 箭头向上
            if frame.origin.y < RefreshControlRotationValue &&  !isUp {
                isUp = true
                // 动画,箭头转上去
                refreshView.tipIconRotation(isUp)
            } else if frame.origin.y > RefreshControlRotationValue && isUp {
                isUp = false
                // 动画,箭头转下去
                refreshView.tipIconRotation(isUp)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        
        // 隐藏
        
        prepareUI()
    }
    
    // 覆盖父类的方法 endRefreshing
    override func endRefreshing() {
        super.endRefreshing()
        
        // 让自定义的view停止刷新
        refreshView.stopRotation()
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加控件
        addSubview(refreshView)
        
        // 从xib里面加载出来的view大小是有值的.
//        print("refreshView: \(refreshView)")
        
        // 添加约束
        refreshView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: refreshView.bounds.size)
    }

    // 懒加载
    // 自定义刷新控件的view
    private lazy var refreshView = CZRefreshView.refreshView()
}

/// 自定义刷新控件内部的view
class CZRefreshView: UIView {
    
    // 旋转的箭头,   !表示隐式拆包,在构造函数掉用的时候没有,但是在我们调用时一定有值,在使用的时候会自动强制拆包
    @IBOutlet weak var tipIcon: UIImageView!
    
    // 箭头和下拉刷新数据label的父控件
    @IBOutlet weak var tipView: UIView!
    
    // 转轮
    @IBOutlet weak var loadingView: UIImageView!
    
    /**
    从xib加载 CZRefreshView
    
    - returns: CZRefreshView
    */
    class func refreshView() -> CZRefreshView {
        return NSBundle.mainBundle().loadNibNamed("CZRefreshView", owner: nil, options: nil).last as! CZRefreshView
    }
    
    /**
    箭头旋转
    
    - parameter isUp: true箭头转上去,false箭头转下来
    */
    func tipIconRotation(isUp: Bool) {
        // 使用UIView动画
        UIView.animateWithDuration(0.25) { () -> Void in
            self.tipIcon.transform = isUp ? CGAffineTransformMakeRotation(CGFloat(M_PI - 0.01)) : CGAffineTransformIdentity
        }
    }
    
    /// 开始刷新
    func startRotation() {
        let animationKey = "rotation"
        // 判断动画是否正在进行,如果正在动画,就不再添加动画了
        if let _ = loadingView.layer.animationForKey(animationKey) {
            // 有动画,直接返回
//            print("有动画,直接返回")
            return
        }
        
        // 没有动画
        
        // 隐藏tipView
        tipView.hidden = true
        
        // 旋转的核心动画
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        
        // 设置动画参数
        rotation.toValue = 2 * M_PI
        rotation.duration = 0.25
        rotation.repeatCount = MAXFLOAT
        
        // 添加到图层,开始动画
        loadingView.layer.addAnimation(rotation, forKey: animationKey)
    }
    
    /// 停止刷新
    func stopRotation() {
        // 显示箭头的父控件
        tipView.hidden = false
        
        // 移除旋转动画
        loadingView.layer.removeAllAnimations()
    }
}