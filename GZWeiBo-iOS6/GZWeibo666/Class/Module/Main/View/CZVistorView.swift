//
//  CZVistorView.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/22.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

/*
    frame:
        origin: 位置 (相对父控件)
        size: 设置大小 (写死的数值)

    autolayout:
        位置: 参照比较丰富
        大小: 参照比较丰富
*/

// 协议
protocol CZVistorViewDelegate: NSObjectProtocol {
    // 默认是必须实现的方法
    // 登录按钮点击
    func vistorViewLoginClick()
}

/// 访客视图
class CZVistorView: UIView {
    
    // MARK: - 属性
    /// 代理
    weak var delegate: CZVistorViewDelegate?
    
    // swift默认所有的view都能通过xib/storyboard 加载
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        // super是要在设置普通的存储型属性的下面
        super.init(frame: frame)
        
        // 设置背景颜色
        backgroundColor = UIColor(white: 237 / 255.0, alpha: 1)
        
        prepareUI()
    }
    
    // MARK: - 按钮点击事件
    func loginClick() {
        // 通知代理
        delegate?.vistorViewLoginClick()
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let a = iconView.layer.animationForKey("rotation")
//        print("动画 a:\(a)")
//    }
    
    // MARK: - 转轮动画
    func rotationAnimation() {
        // 核心动画,旋转
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        
        // 设置动画参数
        rotation.toValue = 2 * M_PI
        rotation.duration = 20
        rotation.repeatCount = MAXFLOAT
        
        // 当不可见的时候,系统会认为动画完成,在完成的时候不要移除动画
        rotation.removedOnCompletion = false
        
        // 开始核心动画
        iconView.layer.addAnimation(rotation, forKey: "rotation")
    }
    
    // MARK: - 核心动画开始和暂停
    /// 暂停旋转
    func pauseAnimation() {
        // 记录暂停时间
        let pauseTime = iconView.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        
        // 设置动画速度为0
        iconView.layer.speed = 0
        
        // 设置动画偏移时间
        iconView.layer.timeOffset = pauseTime
    }
    
    /// 恢复旋转
    func resumeAnimation() {
        // 获取暂停时间
        let pauseTime = iconView.layer.timeOffset
        
        // 设置动画速度为1
        iconView.layer.speed = 1
        
        iconView.layer.timeOffset = 0
        
        iconView.layer.beginTime = 0
        
        let timeSincePause = iconView.layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pauseTime
        
        iconView.layer.beginTime = timeSincePause
    }
    
    // MARK: - 设置访客视图的内容
    /**
    设置访客视图的内容
    
    - parameter imageName: 图片名称
    - parameter message:   内容
    */
    func setupVistorView(imageName: String, message: String) {
        // 图片, 替换转轮的图片
        iconView.image = UIImage(named: imageName)
        
        // 文字
        messageLabel.text = message
        // 适应大小
        messageLabel.sizeToFit()
        
        // 隐藏小房子
        homeView.hidden = true
        
        coverView.hidden = true
        // 父控件把子控件 coverView移动最后面
//        sendSubviewToBack(coverView)
        
        // 父控件把子控件coverView移动最前面
//        bringSubviewToFront(coverView)
    }
    
    /// 准备UI
    private func prepareUI() {
        // 1 添加子控件
        addSubview(iconView)
        
        // 添加遮罩
        addSubview(coverView)
        addSubview(homeView)
        addSubview(messageLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        // 2 添加约束 autolayout
        // 注意: 要设置约束的view有父控件后才能设置它的自动布局约束
        // 关闭Autoresizing,不让它干扰autolayout的约束
        // 约束需要添加到View上面,如果不清楚添加到自身还是父控件,可以直接添加到父控件
        iconView.translatesAutoresizingMaskIntoConstraints = false
        coverView.translatesAutoresizingMaskIntoConstraints = false
        homeView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 创建约束对象
        /// iconView CenterX与父控件的CenterX重合
        // item: 要添加约束的view
        // attribute: 设置的约束
        // relatedBy: Equal
        // toItem: 参照的view
        // attribute: 参照的view的约束
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        /// iconView CenterY与父控件的CenterY重合
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -40))
        
        // 小房子
        // x
        addConstraint(NSLayoutConstraint(item: homeView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        // y
        addConstraint(NSLayoutConstraint(item: homeView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
        // 消息label
        // x
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        // y
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        
        // 宽度约束
        // 当 toItem = nil时attribute必须设置为NSLayoutAttribute.NotAnAttribute
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 226))
        
        // 注册按钮
        // 左边和label对齐
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        
        // 顶部距离label底部16
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        
        // 宽
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 90))
        
        // 高
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35))
        
        // 登录按钮
        // 右边和label对齐
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        
        // 顶部距离label底部16
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        
        // 宽
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 90))
        
        // 高
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35))
        
        // 遮罩约束
        // 左边
        addConstraint(NSLayoutConstraint(item: coverView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        
        // 上
        addConstraint(NSLayoutConstraint(item: coverView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        
        // 右
        addConstraint(NSLayoutConstraint(item: coverView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        
        // 下
        addConstraint(NSLayoutConstraint(item: coverView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: registerButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
    }

    // MARK: - 懒加载
    /// 转轮
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    
    /// 小房子
    private lazy var homeView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    
    /// 消息label
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor.darkGrayColor()
        
        // 设置label文本了
        label.text = "关注一些人,看看有神马惊喜"
        label.numberOfLines = 0
        
        // 根据文本来适应大小
        label.sizeToFit()
        
        return label
    }()
    
    /// 注册按钮
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        
        // 设置按钮的背景图片
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        
        // 设置文本
        button.setTitle("注册", forState: UIControlState.Normal)
        
        // 设置文本颜色
        button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        
        // 设置文本大小
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
        
        // 根据内容适应大小
        button.sizeToFit()
        
        return button
    }()
    
    /// 登录按钮
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        
        // 设置按钮的背景图片
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        
        button.setTitle("登录", forState: UIControlState.Normal)
        
        // 设置文本颜色
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        // 设置文本大小
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
        
        // 根据内容适应大小
        button.sizeToFit()
        
        // 添加点击事件
        button.addTarget(self, action: "loginClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
    /// 遮罩视图
    private lazy var coverView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
}
