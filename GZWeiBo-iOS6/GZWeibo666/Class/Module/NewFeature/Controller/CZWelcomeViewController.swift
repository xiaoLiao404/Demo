//
//  CZWelcomeViewController.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

import SDWebImage

class CZWelcomeViewController: UIViewController {
    
    // MARK: - 属性
    /// iconView底部约束
    private var iconViewBottomCon: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        
        // 显示用户的头像
        if let avatar_large = CZUserAccount.loadUserAccount()?.avatar_large {
            iconView.sd_setImageWithURL(NSURL(string: avatar_large), placeholderImage: UIImage(named: "avatar_default_big"))
        }
        
        // 获取用户数据
        CZUserAccount.loadUserAccount()?.loadUserInfo()
    }
    
    /// 在用户看得到View的时候开始做动画
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 做动画
        moveAnimateion()
    }
    
    // MARK: - 头像动画
    private func moveAnimateion() {
        // 使用autolayout布局之后,不要去修改view的frame,bounds,center,修改约束的值
        iconViewBottomCon?.constant = -500
        
        // 弹簧效果动画
        // duration: 1.2
        // delay: 延时
        // usingSpringWithDamping: 弹簧效果明显程度 0 - 1
        // initialSpringVelocity: 初始速度
        UIView.animateWithDuration(1.2, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (_) -> Void in
                print("动画完成")
                
                // 切换界面
//                (UIApplication.sharedApplication().delegate as? AppDelegate)?.switchViewController(true)
                AppDelegate.switchRootViewController(true)
        }
        
//        UIView.animateWithDuration(1, animations: { () -> Void in
//            // 使用autolayout,只需要更新布局
//            self.view.layoutIfNeeded()
//            }) { (_) -> Void in
//                print("动画完了")
//        }
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 1.添加子控件
        // view 是控制器的根view
        view.addSubview(bkgImageView)
        view.addSubview(iconView)
        view.addSubview(messageLabel)
        
        // 2.添加约束
        bkgImageView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 背景,填充父控件
        // VFL(可视化格式语言),作用:也是使用autolayou来约束控件比较形象,简化autolayout的代码约束
        // 创建约束,通过类方法
        
        // NSLayoutConstraintconstraintsWithVisualFormat   返回的是约束的数组
        // format: VFL约束
        // options 默认
        // metrics: 默认
        // views: 参照映射
        
        /*
            VFL:
                H: 水平方向
                V: 垂直方向
                | 父控件的边界
                [] 表示view
        */
        
        // 左边和右边距离父控件都为0
        
        bkgImageView.ff_Fill(view)
        
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[biv]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["biv" : bkgImageView]))
//        
//        // 顶部和底部距离父控件都为0
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[biv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["biv" : bkgImageView]))
        
        // 头像
        
        let cons = iconView.ff_AlignInner(type: ff_AlignType.BottomCenter, referView: view, size: CGSize(width: 85, height: 85), offset: CGPoint(x: 0, y: -160))
        
        // 获取view上面的约束, 要获取哪个view上面的约束,就用哪个view来调用
        // ff_Constraint: 获取view上面的约束
        // constraintsList: view上面的已有约束
        // attribute: 获取某个约束
        iconViewBottomCon = iconView.ff_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
        
        // X CenterX和父控件的CenterX重合
//        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
//        
//        // 在其他地方使用这个约束,做动画
//        iconViewBottomCon = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -160)
//        view.addConstraint(iconViewBottomCon!)
//        
//        // 宽度
//        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 85))
//        
//        // 高度
//        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 85))
        
        // 欢迎lable
        
        messageLabel.ff_AlignVertical(type: ff_AlignType.BottomCenter, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 16))
        
//        view.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
//        view.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
    }
    
    // MARK: - 懒加载控件
    /// 背景
    private lazy var bkgImageView: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    
    /// 头像
    private lazy var iconView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "avatar_default_big"))
        
        // 设置圆角 宽高85
        view.layer.cornerRadius = 42.5
        view.layer.masksToBounds = true
        
        return view
    }()
    
    /// 消息label
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        
        label.text = "欢迎归来"
        label.sizeToFit()
        
        return label
    }()
}
