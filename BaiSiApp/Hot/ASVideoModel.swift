//
//  ASVideoModel.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/1.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

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
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(playfcount, forKey: "playfcount")
        aCoder.encodeObject(height, forKey: "height")
        aCoder.encodeObject(width, forKey: "width")
        aCoder.encodeObject(duration, forKey: "duration")
        aCoder.encodeObject(playcount, forKey: "playcount")
        aCoder.encodeObject(video, forKey: "video")
        aCoder.encodeObject(thumbnail, forKey: "thumbnail")
        aCoder.encodeObject(download, forKey: "download")
    }
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.playfcount = aDecoder.decodeObjectForKey("playfcount") as! Int
        self.height = aDecoder.decodeObjectForKey("height") as! Int
        self.width = aDecoder.decodeObjectForKey("width") as! Int
        self.duration = aDecoder.decodeObjectForKey("duration") as! Int
        self.playcount = aDecoder.decodeObjectForKey("playcount") as! Int
        self.video = aDecoder.decodeObjectForKey("video") as! [String]
        self.thumbnail = aDecoder.decodeObjectForKey("thumbnail") as! [String]
        self.download = aDecoder.decodeObjectForKey("download") as! [String]
    }
}
