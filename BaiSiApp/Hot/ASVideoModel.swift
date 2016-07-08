//
//  ASVideoModel.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/1.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASVideoModel: NSObject {
    
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
}
