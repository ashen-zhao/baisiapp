//
//  ASCustomLabel.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/1.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASCustomLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let newRect = CGRect(x: rect.origin.x + 2, y: rect.origin.y + 1, width: rect.size.width - 4, height: rect.size.height);
        super.drawText(in: newRect)
    }
}
