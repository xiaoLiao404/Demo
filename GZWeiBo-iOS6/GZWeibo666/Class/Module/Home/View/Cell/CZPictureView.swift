//
//  CZPictureView.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/28.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

import SDWebImage

/// 微博 配图 视图
class CZPictureView: UICollectionView {
    // MARK: - 属性
    /// cell重用标示
    private let ReuseIdentifier = "ReuseIdentifier"
    
    /// 模型
    var status: CZStatus? {
        didSet {
            // 立马显示新数据,刷新collectionView的内容
            reloadData()
        }
    }
    
    /// 流水布局
    private let flowLayout = UICollectionViewFlowLayout()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRectZero, collectionViewLayout: flowLayout)
        
        // 设置背景颜色
        backgroundColor = UIColor.clearColor()
        
        // 注册cell
        self.registerClass(CZPictureViewCell.self, forCellWithReuseIdentifier: ReuseIdentifier)
        
        // 要显示数据需要数据源
        self.dataSource = self
    }
    
    /// 计算配图视图的宽高
    func calcViewSize() -> CGSize {
        
        // 间距
        let margin: CGFloat = 10
        
        // 设置itemSize大小
        let itemSize = CGSize(width: 90, height: 90)
        flowLayout.itemSize = itemSize
        
        // 流水布局的间距
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        // 获取图片的数量
        let count = status?.pictureURLs?.count ?? 0
        
        // 根据图片数量来计算宽高
        if count == 0 {
            // 没有图片宽高为0
            return CGSizeZero
        }
        
        if count == 1 {
            // 默认itemSize
            var size = CGSize(width: 150, height: 120)
            
            // 返回图片的大小
            
            // 获取图片的url地址
            let url = status!.pictureURLs![0].absoluteString
            
            // 使用SDWebImage找到这张图片, key: 是图片的url地址
            // 图片并不一定能够获取,判断是否有图片
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(url)
            
            // 有图片
            if image != nil {
                // 重新设置siez的大小
                size = image.size
//                print("有图片,大小: \(size)")
            }
            
            // 图片宽度太小
            if size.width < 40 {
                size.width = 40
            }
            
            if size.height < 40 {
                size.height = 40
            }
            
            flowLayout.itemSize = size
            
            // 设置配图视图的大小为size
            return size
        }
        
        // 当图片的数量大于1时需要设置间距
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        if count == 4 {
            let width = 2 * itemSize.width + margin
            
            // 设置配图视图的大小为size
            return CGSize(width: width, height: width)
        }
        
        // 2, 3, 5, 6, 7, 8, 9
        // 列数
        let column = 3
        
        // 行数: 公式: 行数 = (count + column - 1) / column   注意:count, column必须是Int类型
        let row = (count + column - 1) / column
        
        // 宽度: 列数 * itemSize.width + (列数 - 1) * 间距
        let widht = CGFloat(column) * itemSize.width + (CGFloat(column) - 1) * margin
        
        // 高度: 行数 * itemSize.width + (行数 - 1) * 间距
        let height = CGFloat(row) * itemSize.width + (CGFloat(row) - 1) * margin
        
        return CGSize(width: widht, height: height)
    }
}

// MARK: - 扩展 CZPictureView 实现数据源
extension CZPictureView: UICollectionViewDataSource {
    /// 返回collectionView的 cell 数量
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.pictureURLs?.count ?? 0
    }
    
    // 每个cell张什么样
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifier, forIndexPath: indexPath) as! CZPictureViewCell
        
        // 设置cell要显示图片的url
        cell.imageURL = status?.pictureURLs?[indexPath.item]
        
        return cell
    }
}

// MARK: - 自定义cell
class CZPictureViewCell: UICollectionViewCell {
    
    // MARK: - 属性
    /// 图片的url,cell 根据url显示不同的图片
    var imageURL: NSURL? {
        didSet {
            // 使用SDWebImage来加载图片,先去本地查找,如果本地有,就不会去网络上加载
            
            bkgImageView.sd_setImageWithURL(imageURL)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        preapreUI()
    }

    private func preapreUI() {
        // 添加子控件
        contentView.addSubview(bkgImageView)
        
        // 添加约束
        // 背景图片,填充父控件
        bkgImageView.ff_Fill(contentView)
    }
    
    // MARK: - 懒加载
    /// 图片
    private lazy var bkgImageView: UIImageView = {
        let imageView = UIImageView()
        
        /*
            case ScaleToFill        // Scale会缩放
            case ScaleAspectFit 
            case ScaleAspectFill
            case Redraw
            case Center
            case Top
            case Bottom
            case Left
            case Right
            case TopLeft
            case TopRight
            case BottomLeft
            case BottomRight
        */
        
        // 设置图片填充模式
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        // 超出边界的需要剪切掉
//        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
}