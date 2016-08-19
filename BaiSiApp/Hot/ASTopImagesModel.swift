//
//  TopImagesModel.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/1.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASTopImagesModel: NSObject {
//    {
//    "code": 0,
//    "msg": "suc",
//    "result": {
//    "list": [
//    {
//    "id": 288,
//    "url": "mod://App_To_ActivityDetail@id=3096",
//    "image": "http://img.spriteapp.cn/ugc/2016/03/24/145600_1879.jpg",
//    "android": "4.0|",
//    "iphone": "3.0|",
//    "ipad": ""
//    }
//    ],
//    "total": 1,
//    "interval": 10
//    }
//    }
    
    var image = ""
    var url = "http://www.devashen.com"
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    init(dict:NSDictionary) {
        super.init()
        self.setValuesForKeysWithDictionary(dict as! [String : AnyObject])
    }
    
    class func getImages(jsonArr:NSArray)->NSMutableArray {
        let tempArr = NSMutableArray()
        for dict in jsonArr {
            tempArr.addObject(ASTopImagesModel.init(dict: dict as! NSDictionary))
        }
        return tempArr
    }
    
}
