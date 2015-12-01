//
//  CZNetworkTool.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

import AFNetworking

// 网络请求的枚举
enum CZNetoworkMethod: String {
    case GET = "GET"
    case POST = "POST"
}

/// 统一管理错误
enum CZNetworkToolError: Int {
    case EmptyAccessToken = -1
    case EmptyUid = -2
    
    // 属性, 根据不同的枚举类型返回不同的值
    var description: String {
        switch self {
        case .EmptyAccessToken:
            return "AccessToken没有值"
        case .EmptyUid:
            return "Uid没有值"
        }
    }
    
    // 方法, 根据当前类型返回一个NSError
    func error() -> NSError {
        return NSError(domain: "cn.itcast.error.net", code: self.rawValue, userInfo: ["description" : self.description])
    }
}

/// 网络单例
class CZNetworkTool: AFHTTPSessionManager {
    
    // 单例
    static let sharedInstance: CZNetworkTool = {
        // baseURL
        let baseURL = NSURL(string: "https://api.weibo.com/")
        let tool = CZNetworkTool(baseURL: baseURL)
        
        // 添加响应的序列化器
        tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tool
    }()
    
    // MARK: - Oauth授权
    /// 申请应用时分配的AppKey
    private let client_id = "173700330"
    
    /// 申请应用时分配的AppSecret
    private let client_secret = "696426f35e8cadf118ba783376857b4d"
    
    /// 授权回调地址, 一定要一模一样
    let redirect_uri = "http://www.baidu.com/"
    
    /// 返回授权界面的URL地址
    func oauthURL() -> NSURL {
        // GET方式拼接登录界面请求地址
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        return NSURL(string: urlString)!
    }
    
    // MARK: - 网络工具类加载AccessToken, 只负责加载数据,让别人来处理数据(通过闭包)
    func loadAccessToken(code: String, finished: NetworkCallback) {
        // url地址
        let urlString = "oauth2/access_token"
        
        // 请求参数
        let parameters = [
            "client_id": client_id,
            "client_secret": client_secret,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirect_uri
        ]
        
        // 发送POST请求
        
        request(requestMethod: CZNetoworkMethod.POST, urlString: urlString, parameters: parameters, needAccessToken: false, finished: finished)
        
//        requestPOST(urlString, parameters: parameters, finished: finished)
        
//        POST(urlString, parameters: parameters, success: { (_, result) -> Void in
////            print("result: \(result)")
//            // as! 强制转换,f 有风险,如果转换不了,直接崩溃
//            // as? 如果能转成功就转换,如果不能转换就返回nil
//            finished(result: result as? [String : AnyObject], error: nil)
//            }) { (_, error) -> Void in
////                print("error:\(error)")
//                finished(result: nil, error: error)
//        }
    }
    
    // MARK: - 获取用户数据
    func loadUserInfo(finished: NetworkCallback) {
//        guard let access_token = CZUserAccount.loadUserAccount()?.access_token else {
//            print("access_token 没有值")
//            
//            let error = CZNetworkToolError.EmptyAccessToken.error()
//            
//            finished(result: nil, error: error)
//            return
//        }
        
        guard let uid = CZUserAccount.loadUserAccount()?.uid else {
            print("uid没有值")
            let error = CZNetworkToolError.EmptyUid.error()
            finished(result: nil, error: error)
            return
        }
        
        let urlString = "2/users/show.json"
        
        // 参数
        let parameters = [
            "uid": uid
        ]
        
        // 发送请求 网络工具类只负责加载数据,不处理数据,交给别人处理
        request(requestMethod: CZNetoworkMethod.GET, urlString: urlString, parameters: parameters, needAccessToken: true, finished: finished)
        
//        requestGET(urlString, parameters: parameters, finished: finished)
        
//        GET(urlString, parameters: parameters, success: { (_, result) -> Void in
//            finished(result: result as? [String: AnyObject], error: nil)
//            }) { (_, error) -> Void in
//                finished(result: nil, error: error)
//        }
    }
    
    // MARK: - 加载微博数据
    
    
    // 要实现下拉刷新,需要传入since_id参数
    // 要实现上拉加载更多数据,需要传入max_id参数,来获取比max_id还小(时间更早的微博)
    
    /**
    加载微博数据
    
    - parameter since_id: 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    - parameter max_id:   若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    - parameter finished: 网络请求完毕的回调
    */
    func loadStatus(since_id: Int, max_id: Int, finished: NetworkCallback) {   // 通过闭包告诉调用者网络请求成功还是失败
//        guard let access_token = CZUserAccount.loadUserAccount()?.access_token else {
//            print("access_token 没有值")
//            let error = CZNetworkToolError.EmptyAccessToken.error()
//            
//            finished(result: nil, error: error)
//            return
//        }
        
        // url
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        // 参数
        var parameters = [String: AnyObject]()
        
        // 拼接参数
        if since_id > 0 {   // 表示别人有传since_id,下拉刷新,才需要拼接
            parameters["since_id"] = since_id
        } else if max_id > 0 {  //表示别人有传max_id,上拉加载更多,才需要拼接
            parameters["max_id"] = max_id - 1   // 防止加载重复的数据
        }
        
        // 调用封装好的GET请求
        let debug = false
        if debug {
            // 调试,加载本地数据
            loadLocalStatuses(finished)
        } else {
            // 不是调试,加载网络微博数据
            request(requestMethod: CZNetoworkMethod.GET, urlString: urlString, parameters: parameters, needAccessToken: true, finished: finished)
        }
//        requestGET(urlString, parameters: parameters, finished: finished)
        
//        GET(urlString, parameters: parameters, success: { (_, result) -> Void in
//            finished(result: result as! [String : AnyObject], error: nil)
//            }) { (_, error) -> Void in
//                finished(result: nil, error: error)
//        }
    }
    
    /// 将本地的测试微博数据加载进来
    private func loadLocalStatuses(finished: NetworkCallback) {
        // 获取测试微博数据的路径
        let path = NSBundle.mainBundle().pathForResource("statuses", ofType: "json")!
        
        // 从文件加载数据 NSData
        let data = NSData(contentsOfFile: path)!
        
        // 将 NSData 转成 JSON
        // throws 有异常,需要处理异常
        // try! 强制try, 如果JSONObjectWithData出现异常,程序直接崩溃
//        let json = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
        
        do {
            let json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
            
            // 通知调用者获取到了本地数据
            finished(result: json as? [String: AnyObject], error: nil)
        } catch {
            print("出现了异常")
        }
        
    }
    
    // MARK: 抽取AFN GET方法
    
    // 定义类型别名
    typealias NetworkCallback = (result: [String: AnyObject]?, error: NSError?) -> ()
    
    /**
    抽取AFN GET方法
    
    - parameter urlString:  url地址
    - parameter parameters: 参数
    - parameter finished:   回调的闭包
    */
//    func requestGET(urlString: String, parameters: [String: AnyObject], finished: NetworkCallback) {
//        GET(urlString, parameters: parameters, success: { (_, result) -> Void in
//            finished(result: result as? [String : AnyObject], error: nil)
//            }) { (_, error) -> Void in
//                finished(result: nil, error: error)
//        }
//    }
    
    /**
    抽取AFN POST方法
    
    - parameter urlString:  url地址
    - parameter parameters: 参数
    - parameter finished:   回调的闭包
    */
//    func requestPOST(urlString: String, parameters: [String: AnyObject], finished: NetworkCallback) {
//        POST(urlString, parameters: parameters, success: { (_, result) -> Void in
//            finished(result: result as? [String : AnyObject], error: nil)
//            }) { (_, error) -> Void in
//                finished(result: nil, error: error)
//        }
//    }
    
    /**
    抽取AFN GET / POST 方法,网络请求的统一入口都是这个方法
    
    - parameter requestMethod: 请求方式
    - parameter urlString:     url地址
    - parameter parameters:    参数
    - parameter finished:      回调的闭包
    */
    func request(requestMethod requestMethod: CZNetoworkMethod, urlString: String, var parameters: [String: AnyObject], needAccessToken: Bool, finished: NetworkCallback) {
        
        // 需要accessToken,就拼接
        if needAccessToken {
            // 判断 access_token是否存在,存在就拼接,不存在就告诉调用者access_token 为空
            guard let access_token = CZUserAccount.loadUserAccount()?.access_token else {
                print("access_token 没有值")
                
                let error = CZNetworkToolError.EmptyAccessToken.error()
                
                finished(result: nil, error: error)
                return
            }
            
            // 在参数里面拼接 access_token
            parameters["access_token"] = access_token
        }
        
        // 准备成功的闭包, 在外面只要准备一次,可以传给GET,也可以传给POST
        let successCallback = { (task: NSURLSessionDataTask, result: AnyObject) -> Void in
            // 执行的代码
            finished(result: result as? [String : AnyObject], error: nil)
        }
        
        // 准备失败的闭包
        let failureCallback = { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            finished(result: nil, error: error)
        }
    
        // 根据请求方式,发送对应的请求
        switch requestMethod {
        case .GET:
            GET(urlString, parameters: parameters, success: successCallback, failure: failureCallback)
        case .POST:
            POST(urlString, parameters: parameters, success: successCallback, failure: failureCallback)
        }
    }
}
