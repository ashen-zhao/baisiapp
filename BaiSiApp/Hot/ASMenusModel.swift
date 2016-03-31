//
//  ASMenusModel.swift
//  BaiSiApp
//
//  Created by ashen on 16/3/31.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//


import UIKit
import SwiftyJSON

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
    
    class func getMenus(type:String, jsonArr:[JSON]) -> NSMutableArray {
        let tempArr = NSMutableArray()
        
        for itemDict in jsonArr {
            if type == itemDict["name"].string! {
                for subDict in itemDict["submenus"].array! {
                    tempArr.addObject(ASMenusModel.init(dic: subDict))
                }
            }

        }
        return tempArr
    }
    
}

