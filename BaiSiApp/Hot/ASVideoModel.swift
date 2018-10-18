//
//  ASVideoModel.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/1.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
@objcMembers
class ASVideoModel: NSObject,NSCoding {
    
    //    "video": {
    //    "playfcount": 1992,
    //    "height": 360,
    //    "width": 640,
    //    "video": [
    //    "http://wvideo.spriteapp.cn/video/2016/0331/ccbd5c54-f74a-11e5-a401-90b11c479401_wpd.mp4",
    //    "http://bvideo.spriteapp.cn/video/2016/0331/ccbd5c54-f74a-11e5-a401-90b11c479401_wpd.mp4"
    //    ],
    //    "duration": 239,
    //    "playcount": 13147,
    //    "thumbnail": [
    //    "http://wimg.spriteapp.cn/picture/2016/0331/ccbd5c54-f74a-11e5-a401-90b11c479401__69.jpg"
    //    ],
    //    "download": [
    //    "http://wvideo.spriteapp.cn/video/2016/0331/ccbd5c54-f74a-11e5-a401-90b11c479401_wpc.mp4",
    //    "http://bvideo.spriteapp.cn/video/2016/0331/ccbd5c54-f74a-11e5-a401-90b11c479401_wpc.mp4"
    //    ]
    //    },
  
    var playfcount = 0
    var height = 0
    var width = 0
    var duration = 0
    var playcount = 0
    var video = [String]()
    var thumbnail = [String]()
    var download = [String]()
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(playfcount, forKey: "playfcount")
        aCoder.encode(height, forKey: "height")
        aCoder.encode(width, forKey: "width")
        aCoder.encode(duration, forKey: "duration")
        aCoder.encode(playcount, forKey: "playcount")
        aCoder.encode(video, forKey: "video")
        aCoder.encode(thumbnail, forKey: "thumbnail")
        aCoder.encode(download, forKey: "download")
    }
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.playfcount = aDecoder.decodeObject(forKey: "playfcount") as! Int
        self.height = aDecoder.decodeObject(forKey: "height") as! Int
        self.width = aDecoder.decodeObject(forKey: "width") as! Int
        self.duration = aDecoder.decodeObject(forKey: "duration") as! Int
        self.playcount = aDecoder.decodeObject(forKey: "playcount") as! Int
        self.video = aDecoder.decodeObject(forKey: "video") as! [String]
        self.thumbnail = aDecoder.decodeObject(forKey: "thumbnail") as! [String]
        self.download = aDecoder.decodeObject(forKey: "download") as! [String]
    }
}
