//
//  MenusModel.swift
//  BaiSiApp
//
//  Created by ashen on 16/3/30.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
import SwiftyJSON

class MenusModel: NSObject {

    // MARK: - 属性
    var nameType = ""
    var name = ""
    var url = ""
    var entrytype = ""
    
    
    init(dic:JSON) {
        super.init()
        nameType = dic["name"].stringValue
        
        MenusModel.getMenus(dic["submenus"].arrayValue)
    
    }
    
    class func getMenus(jsonArr:[JSON])-> NSMutableArray {
        let tempArr = NSMutableArray()
        for item in jsonArr {
            tempArr.addObject(MenusModel.init(dic: item))
        }
        return tempArr
    }
    
}
