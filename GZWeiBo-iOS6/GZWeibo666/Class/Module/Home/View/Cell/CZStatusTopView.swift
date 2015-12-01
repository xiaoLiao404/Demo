//
//  CZStatusTopView.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/27.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

class CZStatusTopView: UIView {
    
    // MARK: - 属性
    /// 微博模型
    var status: CZStatus? {
        didSet {
            // 当别人设置status属性时,来设置顶部视图内容
            
            // 设置头像头像
            if let profile_image_url = status?.user?.profile_image_url {
                // 使用SDWebImage下载头像
                iconView.sd_setImageWithURL(NSURL(string: profile_image_url), placeholderImage: UIImage(named: "avatar"))
            }
            
            // 设置用户名称
            // = 右边可以使用?是因为nameLabel.text是一个可选
            nameLabel.text = status?.user?.screen_name
            
            // 时间
            timeLabel.text = status?.created_at
            
            // 来源
            sourceLabel.text = status?.source
            
            // 设置认证图标,根据不同的数字来设置不同的图片
            verifiedImageView.image = status?.user?.verifiedImage
            
//            if let verified_type = status?.user?.verified_type {
//                // 没有认证:-1   认证用户:0  企业认证:2,3,5  达人:220
//                switch verified_type {
//                case 0:
//                    verifiedImageView.image = UIImage(named: "avatar_vip")
//                case 2,3,5:
//                    verifiedImageView.image = UIImage(named: "avatar_enterprise_vip")
//                case 220:
//                    verifiedImageView.image = UIImage(named: "avatar_grassroot")
//                default:
//                    verifiedImageView.image = nil
//                }
//            }
            
            // 在这里根据user?.mbrank来设置图片,不是很合理,当其他控制器也需要设置图片时,又需要这段代码,最好的做法是,模型能提供对应的会员等级图片, 我们就只需要设置图片.比较方便
            
            // 会员等级
            
            mbrankImageView.image = status?.user?.mbrankImage
            
//            if let mbrank = status?.user?.mbrank {
//                if mbrank > 0 && mbrank < 7 {
//                    // 能到这里面来,是会员
//                    mbrankImageView.image = UIImage(named: "common_icon_membership_level\(mbrank)")
//                } else {
//                    // 不是会员,清空图标
//                    mbrankImageView.image = nil
//                }
//            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareUI()
    }

    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        addSubview(separatorView)
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(mbrankImageView)
        addSubview(verifiedImageView)
        
        // 添加约束
        /// 分割视图.在topView(self)内部左上
        separatorView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: self, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 10))
        
        /// 用户头像,在topView底部,左下有间距
        iconView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: separatorView, size: CGSize(width: 35, height: 35), offset: CGPoint(x: CZStatusCellMargin, y: CZStatusCellMargin))
        
        /// 用户名称
        nameLabel.ff_AlignHorizontal(type: ff_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: CZStatusCellMargin, y: 0))
        
        /// 会员图标
        mbrankImageView.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: CZStatusCellMargin, y: 0))
        
        /// 时间
        timeLabel.ff_AlignHorizontal(type: ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: CZStatusCellMargin, y: 0))
        
        /// 来源
        sourceLabel.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: timeLabel, size: nil, offset: CGPoint(x: CZStatusCellMargin, y: 0))
        
        /// 认证图标
        verifiedImageView.ff_AlignInner(type: ff_AlignType.BottomRight, referView: iconView, size: CGSize(width: 17, height: 17), offset: CGPoint(x: 8.5, y: 8.5))
    }

    // MARK: - 懒加载
    /// 用户头像
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "avatar"))
    
    /// 用户名称
    private lazy var nameLabel: UILabel = UILabel(color: UIColor.darkGrayColor(), fontSize: 14)
    
    /// 时间
    private lazy var timeLabel: UILabel = UILabel(color: UIColor.orangeColor(), fontSize: 9)
    
    /// 来源
    private lazy var sourceLabel: UILabel = UILabel(color: UIColor.lightGrayColor(), fontSize: 9)
    
    /// 会员等级图标
    private lazy var mbrankImageView: UIImageView = UIImageView()
    
    /// 认证类型图标
    private lazy var verifiedImageView:  UIImageView = UIImageView(image: UIImage(named: "avatar_vip"))
    
    /// 顶部分割视图
    private lazy var separatorView: UIView = {
        let view = UIView()
        
        // 背景
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        return view
    }()
}
