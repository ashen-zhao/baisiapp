//
//  ASGifModel.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/6.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASGifModel: NSObject {
//    "gif": {
//    "images": [
//    "http://wimg.spriteapp.cn/ugc/2016/04/05/57035c819fa26.gif"
//    ],
//    "width": 300,
//    "gif_thumbnail": [
//    "http://wimg.spriteapp.cn/ugc/2016/04/05/57035c819fa26_a_1.jpg"
//    ],
//    "download_url": [
//    "http://wimg.spriteapp.cn/ugc/2016/04/05/57035c819fa26_d.jpg",
//    "http://wimg.spriteapp.cn/ugc/2016/04/05/57035c819fa26_a_1.jpg"
//    ],
//    "height": 300
//    },
    
    
    var images = [String]()
    var gif_thumbnail = [String]()
    var height = 0
    var width = 0
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

