//
//  CZBaseTableViewController.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/22.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

class CZBaseTableViewController: UITableViewController {

    /// 用户登录的标志
    var userlogin = CZUserAccount.userLogin
    
    override func loadView() {
        // 如果用户已经登录,正常加载TableView, 否则就创建访客视图
        userlogin ? super.loadView() : setupVistorVidew()
    }
    
    /// 创建访客视图
    private func setupVistorVidew() {
        // 设置view
        view = vistorView
        
        // 设置代理
        vistorView.delegate = self
        
        print("当前控制器:\(self)")
        // 在这里判断是什么类型的控制器.根据不同的控制器,设置不同的访客视图内容
        // 判断类型
        if self is CZHomeViewController {
            // 转轮转起来
            vistorView.rotationAnimation()
            
            // 监听应用进入和退出后台
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
        } else if self is CZMessageViewController {
            // 设置消息访客视图内容
            vistorView.setupVistorView("visitordiscover_image_message", message: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
        } else if self is CZDiscoverViewController {
            // 设置发现访客视图内容
            vistorView.setupVistorView("visitordiscover_image_message", message: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
        } else if self is CZProfileViewController {
            // 设置我访客视图内容
            vistorView.setupVistorView("visitordiscover_image_profile", message: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
        }
        
        // 设置导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "vistorViewRegisterClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "vistorViewLoginClick")
    }
    
    deinit {
        // 移除通知
        if self is CZHomeViewController {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    }
    
    /// 应用进入后台会调用
    func didEnterBackground() {
        // 暂停核心动画
        vistorView.pauseAnimation()
    }
    
    /// 进入应用程序
    func didBecomeActive() {
        // 开始核心动画
        vistorView.resumeAnimation()
    }
    
    // MARK: - 懒加载
    /// 访客视图
    private lazy var vistorView: CZVistorView = CZVistorView()
}

// MARK: - 扩展 CZBaseTableViewController 实现 CZVistorViewDelegate 协议
// extension 和 OC 中的 Category非常类似, 可以将协议的相关方法放到一起, 方便统一管理代码
extension CZBaseTableViewController: CZVistorViewDelegate {
    // MARK: - 实现代理方法
    func vistorViewLoginClick() {
        // 创建Oauth授权界面
        let oauthVC = CZOauthViewController()
        
        presentViewController(UINavigationController(rootViewController: oauthVC), animated: true, completion: nil)
    }
    
    func vistorViewRegisterClick() {
        print("注册按钮被点击")
    }
}