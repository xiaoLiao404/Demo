//
//  CZUser.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/27.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

/// 用户模型
class CZUser: NSObject {

    /// 用户UID
    var id: Int = 0
    
    /// 用户昵称
    var screen_name: String?
    
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    
    /// 是否是微博认证用户，即加V用户，true：是，false：否
    var verified: Bool = false
    
    /// verified_type 没有认证:-1   认证用户:0  企业认证:2,3,5  达人:220
    var verified_type: Int = -1 {
        didSet {
            // 没有认证:-1   认证用户:0  企业认证:2,3,5  达人:220
            switch verified_type {
            case 0:
                verifiedImage = UIImage(named: "avatar_vip")
            case 2,3,5:
                verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verifiedImage = UIImage(named: "avatar_grassroot")
            default:
                verifiedImage = nil
            }
        }
    }
    
    /// 认证类型对应的图片
    var verifiedImage: UIImage?
    
    /// 会员等级 1-6
    var mbrank: Int = 0 {
        didSet {
            if mbrank > 0 && mbrank < 7 {
                // 能到这里面来,是会员
                mbrankImage = UIImage(named: "common_icon_membership_level\(mbrank)")
            } else {
                // 不是会员,清空图标
                mbrankImage = nil
            }
        }
    }
    
    /// 会员等级对应的图片
    var mbrankImage: UIImage?
    
    /// 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()
        
        // 字典转模型
        setValuesForKeysWithDictionary(dict)
    }
    
    /// 字典的key在模型中找不到对应的属性
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    /// 打印
    override var description: String {
        let properties = ["id", "screen_name", "profile_image_url", "verified", "verified_type", "mbrank"]
        
        return "\n\t\t用户模型: \(dictionaryWithValuesForKeys(properties))"
    }
}
