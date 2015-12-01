//
//  CZStatusNormal.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/28.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

// 原创cell
class CZStatusNormalCell: CZStatusCell {

    override func prepareUI() {
        super.prepareUI()
        
        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: CZStatusCellMargin))

        // 获取配图视图的宽高约束
        pictureViewWidthCon = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureViewHeightCon = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
    }

}
