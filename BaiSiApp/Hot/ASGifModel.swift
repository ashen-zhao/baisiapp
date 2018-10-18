//
//  ASGifModel.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/6.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
@objcMembers

class ASGifModel: NSObject,NSCoding {
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
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(images, forKey: "images")
        aCoder.encode(gif_thumbnail, forKey: "gif_thumbnail")
        aCoder.encode(height, forKey: "height")
        aCoder.encode(width, forKey: "width")
    }
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.images = aDecoder.decodeObject(forKey: "images") as! [String]
        self.gif_thumbnail = aDecoder.decodeObject(forKey: "gif_thumbnail") as! [String]
        self.height = aDecoder.decodeObject(forKey: "height") as! Int
        self.width = aDecoder.decodeObject(forKey: "width") as! Int
    }
}

