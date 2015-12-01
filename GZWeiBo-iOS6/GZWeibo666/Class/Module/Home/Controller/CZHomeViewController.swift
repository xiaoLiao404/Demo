//
//  CZHomeViewController.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/22.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

import AFNetworking

import SVProgressHUD

import SVPullToRefresh

// 管理 cell重用标示
enum CZStatusReuseIdentifier: String {
    case NormalCell = "NormalCell"  // 原始值
    case ForwardCell = "ForwardCell"
}

class CZHomeViewController: CZBaseTableViewController {
    
    // MARK: - 属性
    // tipLabel的高度
    private let tipLabelHeight: CGFloat = 44
    
    /// 要显示的微博数据
    var statuses: [CZStatus]? {
        didSet {
            // 刷新tableView的数据
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 判断用户已经登录,才需要做下面的操作
        if !userlogin {
            return
        }
        
        setupNav()
        
        prepareTableView()
        
//        loadStatus()
    }
    
//    <<<<<<< HEAD    // 本地的代码
//    /// 加载更多数据
//    func loadMoreStatus() {
//        print("开始加载更多数据")
//        =======
//        // 下拉刷新,加载新的微博
//        func loadNewStatus() {
//            print("开始加载微博数据")
//            // 当第一次进入程序的时候 statuses 为 nil. since_id = 0,加载最新的20条微博数据
//            // 当有数据来下拉刷新,获取到第一条微博(第一条微博id最大).返回的数据,就是比第一条微博id还大的微博,就是新数据
//            let since_id = statuses?.first?.id ?? 0
//            
//            >>>>>>> 08c50a04494a0ae667651e4daf61d79cc90d0f3f    // 服务器上的代码
    

    // 下拉刷新,加载新的微博
    func loadNewStatus() {
        print("开始加载微博数据")
        // 当第一次进入程序的时候 statuses 为 nil. since_id = 0,加载最新的20条微博数据
        // 当有数据来下拉刷新,获取到第一条微博(第一条微博id最大).返回的数据,就是比第一条微博id还大的微博,就是新数据
        let since_id = statuses?.first?.id ?? 0
        
        // 加载微博数据
        CZStatus.loadStatus(since_id, max_id: 0) { (statuses, error) -> () in
            // 不管有没有获得数据,都关掉刷新控件
            self.refreshControl?.endRefreshing()
            
            // 判断是否有错误
            if error != nil {
                //                print("加载微博数据: \(error)")
                SVProgressHUD.showErrorWithStatus("网络不给力")
                return
            }
            
            let count = statuses?.count ?? 0
            
            if since_id > 0 {
                // 下拉刷新,显示加载了多少条微博数据
                self.showTipView(count)
            }
            
            // 需要判断是下拉刷新,还是第一次加载20条数据
            if count == 0 {
                // 没有新的数据
                return
            }
            
            if since_id > 0 {  // 加载新的微博数据
                // 最终的数据 = 新的数据 + 现有的数据 (可选不能进行操作,需要拆包)
                self.statuses = statuses! + self.statuses!
                print("加载到新的数据,拼接到现有数据的前面,总共: \(self.statuses?.count) 条数据")
            } else {    // 第一次加载20条数据
                // 赋值给属性
                self.statuses = statuses
                print("首次加载最新20条微博数据: \(self.statuses?.count)")
            }
        }
    }
    
    // MARK: 加载更多微博数据
    func loadMoreStatus() {
        
        // 获取max_id
        let max_id = statuses?.last?.id ?? 0
        
        CZStatus.loadStatus(0, max_id: max_id) { (statuses, error) -> () in
            // 加载完数据,结束上拉加载更多数据,让菊花停止旋转
            self.tableView.infiniteScrollingView.stopAnimating()
            
            let count = statuses?.count ?? 0
            
            if count == 0 {
                print("没有加载到更多的数据")
                SVProgressHUD.showErrorWithStatus("没有加载到更多的数据")
                return
            }
            
            // 拼接数据
            // 总的数据 = 现有数据 + 获取到的更多数据
            self.statuses = self.statuses! + statuses!
            print("上拉加载数据完成,总共有: \(self.statuses?.count) 条数据")
        }
    }
    
    // 显示下拉刷新了多少条数据
    private func showTipView(count: Int) {
//        let tipLabelHeight: CGFloat = 44
//        // 定义label
//        let tipLabel = UILabel(frame: CGRect(x: 0, y: -20 - tipLabelHeight, width: UIScreen.mainScreen().bounds.size.width, height: tipLabelHeight))
//        
//        // 设置
//        tipLabel.backgroundColor = UIColor.orangeColor()
//        tipLabel.textAlignment = NSTextAlignment.Center
//        tipLabel.textColor = UIColor.whiteColor()
//        tipLabel.font = UIFont.systemFontOfSize(16)
//        tipLabel.text = count == 0 ? "没有获取新的数据" : "加载了: \(count) 条微博"
//        
//        // 添加到导航栏上面,在最底部
//        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        
        tipLabel.text = count == 0 ? "没有获取新的数据" : "加载了: \(count) 条微博"
        
        // 动画下来
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            // UIView动画反过来执行
//            UIView.setAnimationRepeatAutoreverses(true)
//            UIView.setAnimationRepeatCount(5)
            self.tipLabel.frame.origin.y = self.tipLabelHeight
            }) { (_) -> Void in
                
                UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    self.tipLabel.frame.origin.y =  -20 - self.tipLabelHeight
                    }, completion: { (_) -> Void in
                        print("完成")
                })
        }
    }
    
    private func prepareTableView() {
        // 注册cell,需要注册2个,根据显示的模型返回对应类型的cell
        tableView.registerClass(CZStatusNormalCell.self, forCellReuseIdentifier: CZStatusReuseIdentifier.NormalCell.rawValue)
        tableView.registerClass(CZStatusForwardCell.self, forCellReuseIdentifier: CZStatusReuseIdentifier.ForwardCell.rawValue)
        
        // 取消cell的分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // 使用Autolayout来自动约束cell的高度
        
//        // 设置预估行高,减少cell的计算次数,加载cell内容的显示.缺点:没有显示的cell,在即将显示的时候,还是需要计算一次cell,有可能影响,拖动的流畅
        tableView.estimatedRowHeight = 200

//
//        // 设置行高,根据cell的约束来自动确定cell的高度
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        //  默认大小: 宽度等于屏幕的宽度,高度是60
        refreshControl = CZRefreshControl()
//        print("refreshControl: \(refreshControl)")
        
        // 当刷新控件进入刷新状态时调用
        refreshControl?.addTarget(self, action: "loadNewStatus", forControlEvents: UIControlEvents.ValueChanged)
        
        // 主动开始刷新数据
        // beginRefreshing只会让刷新控件进入刷新状态,并不会触发UIControlEvents.ValueChanged事件
        refreshControl?.beginRefreshing()
        
        // 代码触发refreshControl控件的UIControlEvents.ValueChanged
        refreshControl?.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        
        // 测试添加控件到系统的UIRefreshControl
//        let view = UIView()
//        view.backgroundColor = UIColor.redColor()
//        view.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
//        
//        refreshControl?.addSubview(view)
//        
//        refreshControl?.tintColor = UIColor.clearColor()
        
        // 使用 SVPullToRefresh 来上拉加载更多数据
        tableView.addInfiniteScrollingWithActionHandler { () -> Void in
            print("加载更多数据")
            self.loadMoreStatus()
        }
    }

    // MARK: - 设置导航栏
    private func setupNav() {
        // 设置导航栏左边
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendsearch")
    
        // 设置导航栏右边
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        // 设置标题
        // 创建按钮
        let screen_name = CZUserAccount.loadUserAccount()?.screen_name ?? "iOS06"
        
        let homeTitleButton = CZHomeTitleButton(title: screen_name)
        
        navigationItem.titleView = homeTitleButton
        homeTitleButton.addTarget(self, action: "homeTitleButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func homeTitleButtonClick(button: UIButton) {
        // 点击修改按钮的选中状态
        button.selected = !button.selected

        UIView.animateWithDuration(0.25, animations: { () -> Void in
            button.imageView?.transform = button.selected ? CGAffineTransformMakeRotation(CGFloat(M_PI - 0.01)) : CGAffineTransformIdentity
        })
    }
    
    // MARK: - tableView数据源
    /// 返回对应cell的行高
    /// 发现行高调用比较频繁,导致多次调用.计算一次,然后保存起来,下次直接返回缓存的行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 先看看有没有缓存的行高,如果有缓存行高,直接拿来用,没有的话,在计算,并缓存起来
        // 获取对应的模型
        let status = statuses![indexPath.row]
        
        if status.rowHeight != nil {
//            print("返回会缓存的行高: \(indexPath), rowHeight: \(status.rowHeight!)")
            return status.rowHeight!
        }
        
        // 能到下面来,说明没有缓存的行高
        
        // 获取cell, 计算行高,并不会显示出来
        let cell = tableView.dequeueReusableCellWithIdentifier(status.cellId()) as! CZStatusCell
        
        // cell计算行高
        let rowHeight = cell.rowHeight(status)
        
        // 缓存行高
        status.rowHeight = rowHeight
        
        // 返回行高
//        print("计算行高,indexPath: \(indexPath), rowHeight: \(rowHeight)")
        
        return rowHeight
    }
    
    /// 返回多行数据
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 返回statuses的数量
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 获得模型,模型最清楚要显示什么样的cell
        let status = statuses![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(status.cellId()) as! CZStatusCell

        // var text: String?是一个可选.
//        cell.textLabel?.text = statuses?[indexPath.row].text
        
        // 给cell设置模型
        cell.status = status
        
        return cell
    }
    
    // MARK: - 懒加载
    private lazy var tipLabel: UILabel = {
        // 定义label
        let tipLabel = UILabel(frame: CGRect(x: 0, y: -20 - self.tipLabelHeight, width: UIScreen.mainScreen().bounds.size.width, height: self.tipLabelHeight))
        
        // 设置
        tipLabel.backgroundColor = UIColor.orangeColor()
        tipLabel.textAlignment = NSTextAlignment.Center
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.font = UIFont.systemFontOfSize(16)
        
        // 添加到导航栏上面,在最底部
        self.navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        
        return tipLabel
    }()
}
