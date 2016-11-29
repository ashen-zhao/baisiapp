//
//  ASMineTagsModel.swift
//  BaiSiApp
//
//  Created by ashen on 16/8/24.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
//{
//    "tag_list": [
//    {
//    "theme_id": "3096",
//    "theme_name": "百思红人"
//    },
//    {
//    "theme_id": "9",
//    "theme_name": "自拍"
//    }
//    ],
//    "square_list": [
//    {
//    "id": "28",
//    "name": "审贴",
//    "icon": "http://img.spriteapp.cn/ugc/2015/05/20/150532_5078.png",
//    "url": "mod://BDJ_To_Check",
//    "android": "",
//    "iphone": "",
//    "ipad": "",
//    "market": ""
//    }]
// }
class ASMineTagsModel: NSObject {
    var tag_list:NSArray = []
    var square_list = [AnyObject]()
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
