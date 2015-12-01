//
//  CZMainViewController.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/22.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

class CZMainViewController: UITabBarController {
    
    /// 撰写按钮点击事件
    func composeClick() {
        // __FUNCTION__ 打印方法名称
        print(__FUNCTION__)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // 设置自定义的tabBar
//        let newTabBar = CZTabbar()
//        // KVC
//        setValue(newTabBar, forKey: "tabBar")
//        
//        newTabBar.composeButton.addTarget(self, action: "composeClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        tabBar.tintColor = UIColor.orangeColor()

        // 首页
        let homeVC = CZHomeViewController()
        addChildViewController(homeVC, title: "首页", imageName: "tabbar_home")
        
        // 消息
        let messageVC = CZMessageViewController()
        addChildViewController(messageVC, title: "消息", imageName: "tabbar_message_center")
        
        // 占位控制器
        addChildViewController(UIViewController())
        
        // 发现
        let discoverVC = CZDiscoverViewController()
        addChildViewController(discoverVC, title: "发现", imageName: "tabbar_discover")
        
        // 我
        let profileVC = CZProfileViewController()
        addChildViewController(profileVC, title: "我", imageName: "tabbar_profile")
        
        // 在这里添加撰写按钮太早了,会被占位item给挡住了
//        // 设置撰写按钮的frame
//        let width = tabBar.bounds.size.width / 5
//        let frame = CGRect(x: 2 * width, y: 0, width: width, height: tabBar.bounds.height)
//        composeButton.frame = frame
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置撰写按钮的frame
        let width = tabBar.bounds.size.width / 5
        let frame = CGRect(x: 2 * width - 5, y: 0, width: width + 10, height: tabBar.bounds.height)
        composeButton.frame = frame
    }
    
    /**
    自定义添加tabbar子控制器
    
    - parameter controller: 子控制器
    - parameter title:      子控制器的标题
    - parameter imageName:  子控制器的图片名称
    */
    // private 表示只有本类或当前文件的其他类可以访问
    private func addChildViewController(controller: UIViewController, title: String, imageName: String) {
        controller.title = title
        controller.tabBarItem.image = UIImage(named: imageName)

        // 拼接高亮图片名称
        let highlightedImageName = imageName + "_highlighted"
        // 让选中的图片使用原来的颜色,不要系统帮我们渲染
        let highlightedImage = UIImage(named: highlightedImageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        // 设置高亮图片
//        controller.tabBarItem.selectedImage = highlightedImage
        
        // 设置标题颜色
//        controller.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.orangeColor()], forState: UIControlState.Highlighted)
        
        addChildViewController(UINavigationController(rootViewController: controller))
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
        self.tabBar.addSubview(button)
        
        // 添加点击事件
        button.addTarget(self, action: "composeClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
}
