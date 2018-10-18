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
    
    @objc var header = [String]()
    @objc var is_v = false
    @objc var uid:AnyObject!
    @objc var is_vip = false
    @objc var name = ""
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(header, forKey: "header")
        aCoder.encode(is_v, forKey: "is_v")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(is_vip, forKey: "is_vip")
    }
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.header = aDecoder.decodeObject(forKey: "header") as! [String]
        self.is_v = aDecoder.decodeObject(forKey: "is_v") as! Bool
        self.uid = aDecoder.decodeObject(forKey: "uid") as AnyObject
        self.is_vip = aDecoder.decodeObject(forKey: "is_vip") as! Bool
    }
    
}
