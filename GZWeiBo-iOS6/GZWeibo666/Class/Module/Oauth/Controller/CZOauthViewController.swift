//
//  CZOauthViewController.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

import SVProgressHUD

class CZOauthViewController: UIViewController {
    
    override func loadView() {
        // 不用设置约束
        view = webView
        webView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 加载授权界面
        let request = NSURLRequest(URL: CZNetworkTool.sharedInstance.oauthURL())
        webView.loadRequest(request)
        
        // 设置导航栏
        // 左边
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "填充", style: UIBarButtonItemStyle.Plain, target: self, action: "autoFill")
        
        // 右边
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
    }
    
    /// 填充账号
    func autoFill() {
        // 创建js代码
        let js = "document.getElementById('userId').value='czbkiosweibo@163.com'; document.getElementById('passwd').value='czbkios666';"
        // 让webView执行js代码
        webView.stringByEvaluatingJavaScriptFromString(js)
    }
    
    /// 加载accessToken
    func loadAccessToken(code: String) {
        // 发送网络请求
        CZNetworkTool.sharedInstance.loadAccessToken(code) { (result, error) -> () in
            // 判断是否有错误.有错误,提示用户,关闭控制器
            // 测试出错的情况
            if error != nil || result == nil {
                // 告诉用户出错了
                SVProgressHUD.showErrorWithStatus("你的网络不给力...", maskType: SVProgressHUDMaskType.Black)
                
                // 延时1s
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(<#delayInSeconds#> * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    <#code to be executed after a specified delay#>
//});
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                    self.close()
                })
                return
            }
            
            // 没有出错,保存数据
//            print("vc result: \(result)")
            // 创建模型
            let userAccount = CZUserAccount(dict: result!)
            
            // 保存对象
            userAccount.saveAccout()
            
            print("userAccount:\(userAccount)")
            
            self.close()
            
            // 切换界面
//            (UIApplication.sharedApplication().delegate as? AppDelegate)?.switchViewController(false)
            AppDelegate.switchRootViewController(false)
        }
    }
    
    deinit {
        print("Oauth控制器销毁")
    }
    
    /// 关闭控制器
    func close() {
        // 关闭SV
        SVProgressHUD.dismiss()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 懒加载
    /// webView
    private lazy var webView = UIWebView()
}

// MARK: - 扩展 CZOauthViewController 实现 UIWebViewDelegate 协议
extension CZOauthViewController: UIWebViewDelegate {
    /// webView开始加载链接
    func webViewDidStartLoad(webView: UIWebView) {
        // showWithStatus只有没有主动关闭,一直显示
        // showInfoWithStatus 过段时间就消失
        SVProgressHUD.showWithStatus("正在加载...", maskType: SVProgressHUDMaskType.Black)
    }
    
    /// webView加载完成某个链接
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    // webView加载链接,每当webView加载一个链接都会通过这个代理方法来询问我们这个地址是否可以加载 true表示可以加载, false 就不加载.
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.URL!.absoluteString
        print("urlString: \(urlString)")
        
        // 点击取消: http://www.baidu.com/?error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=21330
        // 点击授权: http://www.baidu.com/?code=78ea2a88d6ee9d1f968b7036576c1521
        // 当用户点击取消或同意,拦截,不让它加载,我们来处理
        if !urlString.hasPrefix(CZNetworkTool.sharedInstance.redirect_uri) {
            // 其他情况, 直接加载
            return true
        }
        
        // 点击取消 或 点击授权
        // 判断url地址里面是以code=开头,截取code= 后面的字符串
        // error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=21330
        // code=57c4568b41da3e3fed3541758b804f8a
        if let query = request.URL?.query {
//        print("query: \(query)")
            let codeString = "code="
            // 判断是否是以code=开头
            if query.hasPrefix(codeString) {
                // 点击授权, 截取code的值
                let nsQuery = query as NSString
                let code = nsQuery.substringFromIndex(codeString.characters.count)
                print("code:\(code)")
                
                // 加载accessToken
                loadAccessToken(code)
            } else {
                // 点击取消
                print("点击取消")
                self.close()
            }
        }
        
        // 不去加载授权回调地址
        return false
    }
}
