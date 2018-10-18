//
//  ASMenusModel.swift
//  BaiSiApp
//
//  Created by ashen on 16/3/31.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//


import UIKit
import SwiftyJSON
@objcMembers
class ASMenusModel: NSObject {
    
    // MARK: - 属性
    var name = ""
    var url = ""
    var entrytype = ""
    
    init(dic:JSON) {
        super.init()

        name = dic["name"].string!
        url = dic["url"].string!
        entrytype = dic["entrytype"].string!
    }
    
    class func getMenus(_ type:String, jsonArr:[JSON]) -> NSMutableArray {
        let tempArr = NSMutableArray()
        let tempd0 = ["name":"全部",
                      "url":"http://s.budejie.com/topic/list/jingxuan/1/",
                      "entrytype":"www"]
        let tempd1 = ["name":"热门",
                      "url":"http://s.budejie.com/topic/list/remen/1/",
                      "entrytype":"www"]
        let tempd2 = ["name":"图片",
                     "url":"http://s.budejie.com/topic/list/jingxuan/10/",
                     "entrytype":"www"]
        let tempd3 = ["name":"段子",
                      "url":"http://s.budejie.com/topic/list/jingxuan/29/",
                      "entrytype":"www"]
        let tempd4 = ["name":"视频",
                      "url":"http://s.budejie.com/topic/list/jingxuan/41/",
                      "entrytype":"www"]
        tempArr.add(ASMenusModel.init(dic: JSON.init(tempd0)))
        tempArr.add(ASMenusModel.init(dic: JSON.init(tempd1)))
        tempArr.add(ASMenusModel.init(dic: JSON.init(tempd2)))
        tempArr.add(ASMenusModel.init(dic: JSON.init(tempd3)))
        tempArr.add(ASMenusModel.init(dic: JSON.init(tempd4)))

//        for itemDict in jsonArr {
//            if type == itemDict["name"].string! {
//                for subDict in itemDict["submenus"].array! {
//                    tempArr.add(ASMenusModel.init(dic: subDict))
//                }
//            }
//        }
        return tempArr
    }
    
}

