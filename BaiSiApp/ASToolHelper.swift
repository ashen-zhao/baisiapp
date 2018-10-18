//
//  ASToolHelper.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/1.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASToolHelper: NSObject {

    class func getSizeForText(_ text:NSString, size:CGSize, font:CGFloat)->CGSize {
        return text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes:[NSAttributedString.Key.font : UIFont.systemFont(ofSize: font)], context: nil).size
    }
}
