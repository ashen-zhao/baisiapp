//
//  ASDataHelper.swift
//  BaiSiApp
//
//  Created by ashen on 16/3/30.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASDataHelper: NSObject {
    
    func getMenusType(successs:(AnyObject)->Void){
        ASNetWorkHepler.getResponseData("http://s.budejie.com/public/list-appbar/baisi_xiaohao-iphone-4.1", parameters: nil, success: { (result) in
            successs(result as! AnyObject)
            }) { (error) in
              NSLog("请求失败")
        }
    }
    
}
