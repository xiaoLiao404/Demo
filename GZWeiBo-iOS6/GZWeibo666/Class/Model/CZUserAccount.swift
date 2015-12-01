//
//  CZUserAccount.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

// CustomStringConvertible
// 将对象归档到沙盒
class CZUserAccount: NSObject, NSCoding {
    
    // MARK: - 属性
    /// 用户是否登录
    class var userLogin: Bool {
        get {
            return CZUserAccount.loadUserAccount() != nil
        }
    }
    
    /// 用于调用access_token，接口获取授权后的access token。
    var access_token: String?
    
    /// access_token的生命周期，单位是秒数。在KVC字典转模型基本数据类型需要设置初始值.
    var expires_in: NSTimeInterval = 0 {
        didSet {
            // 设置过期时间
            expiresDate = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    /// 保存过期时间NSDate
    var expiresDate: NSDate?

    /// 当前授权用户的UID。
    var uid: String?
    
    /// 用户昵称
    var screen_name: String?
    
    /// 用户头像地址（大图），180×180像素,图片的网络地址
    var avatar_large: String?
    
    /// 字典转模型
//    init(dict: [String: AnyObject]) {
//        access_token = dict["access_token"] as! String
//        expires_in = dict["expires_in"] as! String
//        uid = dict["uid"] as! String
//        super.init()
//    }
    
    /// 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC 字典转模型
        setValuesForKeysWithDictionary(dict)
    }
    
    /// 加载用户信息
    func loadUserInfo() {
        // 获取用户数据
        CZNetworkTool.sharedInstance.loadUserInfo { (result, error) -> () in
            if error != nil || result == nil {
                print("加载数据失败:\(error)")
                return
            }
            
//            print("加载数据成功:\(result)")
            
            // 设置属性
            self.screen_name = result!["screen_name"] as? String
            self.avatar_large = result!["avatar_large"] as? String
            
            // 对象获取的2个属性,更新userAccount账户属性
            CZUserAccount.userAccount = self
            
            // 保存起来
            self.saveAccout()
        }
    }
    
    // 保存路径 static 类方法也可以访问.对象方法访问需要使用类名.属性名
    static let plistPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! + "/account.plist"
    
    /// 保存账户信息到沙盒
    func saveAccout() {
        // 归档 当前类
        NSKeyedArchiver.archiveRootObject(self, toFile: CZUserAccount.plistPath)
    }
    
    /*
        项目中经常需要使用到CZUserAccount,如果每次调用loadUserAccount,都会去沙盒解档一个账户.这样是比较消耗性能.
        当没有账户,去沙盒解档一个.如果解档账户成功,将它保存在内存中,以后直接访问内存中的账户.可以提高性能
    */
    
    /// 内存中的账户.
    private static var userAccount: CZUserAccount?
    
    /// 读取 保存在沙盒里面的账户信息
    class func loadUserAccount() -> CZUserAccount? {
        // 1.判断内存中的账户是有可用
        if userAccount == nil {
            // 内存中没有账户, 到沙盒加载一个账户(有可能加载出来也有可能加载不出来),赋值给内存中的账户
            userAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(plistPath) as? CZUserAccount
//            print("从沙盒加载账户:\(userAccount)")
        } else {
            print("直接从内存中获取到账户")
        }
        
        // 2.判断内存中是否有用账户,有账户,判断时间是否过期
        if userAccount != nil && userAccount?.expiresDate?.compare(NSDate()) == NSComparisonResult.OrderedDescending {
            // 有账户并且没有过期,是一个可用的账户
            return userAccount
        }
        
        return nil
    }
    
    /// 解档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
    
    /// 归档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
    /// 当KVC字典的key在模型中找不到对应的属性
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    /// 打印对象信息
    override var description: String {
        return "access_token: \(access_token), expires_in:\(expires_in), uid = \(uid), expiresDate:\(expiresDate)"
    }
}
