//
//  CZStatus.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/27.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

import SDWebImage

// CustomStringConvertible
class CZStatus: NSObject {

    /// 微博创建时间
    var created_at: String?

    /// 微博ID
    var id: Int = 0
    
    /// 微博信息内容
    var text: String?
    
    /// 微博来源
    var source: String?
    
    /// 微博 缩略图 图片地址数组: 数组里面存放的是字典   ["thumbnail_pic": 图片urlString]
    var pic_urls: [[String: AnyObject]]? {
        didSet {
            if pic_urls?.count == 0 {
                return
            }
            
            // 有图片, 获取到对应的图片地址,生成NSURL,赋值给pictureURLs
            
            // 创建 pictureURLs
            storePictureURLs = [NSURL]()
            for dict in pic_urls! {
            //  thumbnail_pic	:	http://ww3.sinaimg.cn/thumbnail/88c594eegw1eyfe75k2ngj20c88og4qp.jpg
                
                // 获取字典里面的图片urlString
                let urlString = dict["thumbnail_pic"] as! String
                
                // 创建NSURL
                let url = NSURL(string: urlString)!
                
                // 添加到 pictureURLs
                storePictureURLs?.append(url)
            }
        }
    }
    
    /// 缩略图NSURL数组
    var storePictureURLs: [NSURL]?
    
    /// 计算,当模型是原创微博的时候返回原创微博对应的图片URL,如果是转发微博,返回被转发微博的图片URL
    var pictureURLs: [NSURL]? {
        // 当模型是原创微博的时候返回原创微博对应的图片URL
        // 如果是转发微博,返回被转发微博的图片URL
        return retweeted_status == nil ? storePictureURLs : retweeted_status?.storePictureURLs
    }
    
    /// 用户模型, 如果不做特殊处理,KVC会将返回数据中的字典赋值给user, 普通的属性使用KVC赋值,如果是user属性,我们拦截,不使用KVC赋值,我们自己来字典转模型,在赋值给 user
    var user: CZUser?
    
    /// 转发数
    var reposts_count: Int = 0
    
    /// 评论数
    var comments_count: Int = 0
    
    /// 表态数(赞)
    var attitudes_count: Int = 0
    
    /// 行高
    var rowHeight: CGFloat?
    
    /// 被转发的微博
    var retweeted_status: CZStatus?
    
    /// 模型根据模型是否有 retweeted_status 属性,表示转发微博,没有这个属性,原创微博
    func cellId() -> String {
        return retweeted_status == nil ? CZStatusReuseIdentifier.NormalCell.rawValue : CZStatusReuseIdentifier.ForwardCell.rawValue
    }
    
    /// 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()    // 创建对象
        
        // 有了对象,才能调用对象的方法
        // KVC字典转模型
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "user" {
//            print("user: \(user), value: \(value)")
            
            if let dict = value as? [String: AnyObject] {
                // 在这里字典转模型, 赋值给user属性
                user = CZUser(dict: dict)
            }
            
            // 千万要记得return,不然会被父类从新赋值,覆盖掉了
            return
        }
        
        // 设置被转发微博
        if key == "retweeted_status" {
            if let dict = value as? [String: AnyObject] {
                // 手动字典转模型,赋值给 retweeted_status 属性
                retweeted_status = CZStatus(dict: dict)
            }
            
            // 千万要记得return,不然会被父类从新赋值,覆盖掉了
            return
        }
        
        // 调用父类的方法
        super.setValue(value, forKey: key)
    }
    
    /// KVC字典转模型时,字典的key在模型中找不到对应的属性时会调用,在这个方法里面可以什么都不做
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    /// 对象信息
    override var description: String {
        // 数组存放的是需要打印的属性
        let properties = ["created_at", "id", "text", "source", "pic_urls", "reposts_count", "comments_count", "attitudes_count", "user", "retweeted_status"]
        
        // 根据传入数组作为字典的key,value会从模型里面自动获取
        // \n 换行 \t table
        return "\n \t 微博模型: \(dictionaryWithValuesForKeys(properties))"
    }
    
    /// 获取微博数据

    /**
    获取微博数据,字典转模型
    
    - parameter finished: 闭包回调, 如果有数据,返回微博模型,失败:error != nil
    */
    class func loadStatus(since_id: Int, max_id: Int, finished: (statuses: [CZStatus]?, error: NSError?) -> ()) {
        /// 调用网络工具类获取数据
        CZNetworkTool.sharedInstance.loadStatus(since_id, max_id: max_id) { (result, error) -> () in
            // 网络请求完毕
            
            // 判断是否有错误
            if error != nil || result == nil {
                print("error: \(error)")
                // 告诉调用者,出错了
                finished(statuses: nil, error: error)
                return
            }
            
            // 加载到微博数据, 字典转模型
            if let array = result!["statuses"] as? [[String: AnyObject]] {
                // 能到这里面来, statuses 数据是没有问题的
                
                // 创建一个数组来存放转好的模型
                var statuses = [CZStatus]()
                
                // 遍历数组,获取里面的每一个字典,
                for dict in array {
                    // 字典转模型
                    let status = CZStatus(dict: dict)
                    statuses.append(status)
                }
                
                // 字典转模型完成, 告诉调用者,有模型数据
                
                // 前提,图片比较小,才能缓存,如果太大,会影响用户体验
                // 单张图片要设置为图片本来的大小,服务器没有提供图片的大小,需要我们自己先将图片下载下来,缓存到本地,就可以知道图片的大小,告诉调用者获取到微博数据(通知控制器),获取到了微博数据,其他就可以拿到图片的大小了
                // 所有的图片都下载完成的时候才通知调用者获取到微博数据
                self.cacheWebImage(statuses, finished: finished)
                //                finished(statuses: statuses, error: nil)
            } else {
                // 返回的数据不能字典转模型,告诉调用者,没有模型数据
                finished(statuses: nil, error: nil)
            }
        }
    }
    
    // MARK: - 缓存网络图片
    private class func cacheWebImage(statuses: [CZStatus], finished: (statuses: [CZStatus]?, error: NSError?) -> ()) {
        // 创建任务组
        let group = dispatch_group_create()
        
        // 记录下载图片的大小
        var length = 0
        
        // 遍历每一个模型
        for status in statuses {
            // 判断是否有图片,没有图片跳过,遍历下一个
            guard let urls =  status.pictureURLs else {
                // 能到这里面来,说明每有图片,跳过这个模型,遍历下一个模型
                continue
            }
            
            // 说明 status.pictureURLs 不为空
            // 其实只需要缓存单张图片的情况,多张图片可以等到显示的时候在去加载,可以减少缓存图片的时间
//            for url in urls {
            // 判断是否是单张图片
            if urls.count == 1 {
                let url = urls[0]
            
                // 遍历地址,去下载图片
                
                // 使用SDWebImage去下载图片,异步下载图片
                // 让下载图片在一个任务组里面,当所有图片都下载完毕的时候,在通知我们所有图片下载完毕
                
                // 在异步任务开始之前进入组
                dispatch_group_enter(group)
                
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, error, _, _, _) -> Void in
                    // SDWebIamage下载完毕
                    // 离开组
                    dispatch_group_leave(group)
                    
                    if error != nil {
                        print("下载图片失败: \(url)")
                        return
                    }
                    
                    // 没有下载失败.
//                    print("下载图片成功: \(url)")
                    let data = UIImagePNGRepresentation(image)!
                    
                    // 记录下载图片的大小
                    length += data.length
                })
            }
        }
        
        // 监听group中的所有任务都完成, 通知一般都在主线程上面
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            // 所有图片都下载完毕
            print("所有图片都下载完毕 大小: \(CGFloat(length) / 1024.0 / 1024.0) M")
            
            // 通知调用者,获取到了微博数据
            finished(statuses: statuses, error: nil)
        }
    }
}
