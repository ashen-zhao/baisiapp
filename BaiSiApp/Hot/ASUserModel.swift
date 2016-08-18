//
//  ASUserModel.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/1.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASUserModel: NSObject, NSCoding {
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
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(header, forKey: "header")
        aCoder.encodeObject(is_v, forKey: "is_v")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(is_vip, forKey: "is_vip")
    }
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.header = aDecoder.decodeObjectForKey("header") as! [String]
        self.is_v = aDecoder.decodeObjectForKey("is_v") as! Bool
        self.uid = aDecoder.decodeObjectForKey("uid")
        self.is_vip = aDecoder.decodeObjectForKey("is_vip") as! Bool
    }
    
}
