//
//  ASCustomLabel.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/1.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASCustomLabel: UILabel {
    override func drawTextInRect(rect: CGRect) {
        let newRect = CGRectMake(rect.origin.x + 2, rect.origin.y + 1, rect.size.width - 4, rect.size.height);
        super.drawTextInRect(newRect)
    }
}
