//
//  ASCommentModel.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/1.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
@objcMembers

class ASCommentModel: NSObject, NSCoding {
//    "top_comment": {
//    "voicetime": 0,
//    "precid": 0,
//    "content": "这才是为人师表。难怪出国留学这么多",
//    "like_count": "339",
//    "u": {
//    "header": [
//    "http://wimg.spriteapp.cn/profile/large/2015/09/06/55ebb55fc4219_mini.jpg"
//    ],
//    "sex": "f",
//    "uid": "5564405",
//    "name": "人生的茶几上果然摆满杯具"
//    },
//    "preuid": 0,
//    "voiceuri": "",
//    "id": 47433888
//    },
    
    var content = ""
    var user = ASUserModel()
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "u" {
            user.setValuesForKeys(value as! Dictionary)
        }
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(content, forKey: "content")
        aCoder.encode(user, forKey: "user")
    }
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.content = aDecoder.decodeObject(forKey: "content") as! String
        self.user = aDecoder.decodeObject(forKey: "user") as! ASUserModel
    }
}
