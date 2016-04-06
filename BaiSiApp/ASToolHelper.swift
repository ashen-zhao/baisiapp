//
//  ASToolHelper.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/1.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASToolHelper: NSObject {

    class func getSizeForText(text:NSString, size:CGSize, font:CGFloat)->CGSize {
      return text.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes:[NSFontAttributeName : UIFont.systemFontOfSize(font)], context: nil).size
    }
}
