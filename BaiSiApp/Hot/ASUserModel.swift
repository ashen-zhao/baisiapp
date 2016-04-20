//
//  ASUserModel.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/1.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASUserModel: NSObject {
    //    "u": {
    //    "header": [
    //    "http://wimg.spriteapp.cn/profile/large/2016/03/14/56e61baedf666_mini.jpg"
    //    ],
    //    "is_v": false,
    //    "uid": "16965746",
    //    "is_vip": false,
    //    "name": "爬上高墙等红杏888"
    //    },
    
    var header = [String]()
    var is_v = false
    var uid:AnyObject!
    var is_vip = false
    var name = ""
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
