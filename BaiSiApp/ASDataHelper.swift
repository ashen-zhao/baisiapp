//
//  ASDataHelper.swift
//  BaiSiApp
//
//  Created by ashen on 16/3/30.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
import SwiftyJSON
class ASDataHelper: NSObject {
    
    //获取类型
    class func getMenusType(type:String, successs:(AnyObject)->Void){
        ASNetWorkHepler.getResponseData("http://s.budejie.com/public/list-appbar/baisi_xiaohao-iphone-4.1", parameters: nil, success: { (result) in
            successs(ASMenusModel.getMenus(type, jsonArr: result["menus"].array!))
            }) { (error) in
              NSLog("请求失败")
        }
    }
    
    //获取推荐
    class func getAllLists(success:(AnyObject)->Void) {
        ASNetWorkHepler.getResponseData("http://s.budejie.com/topic/list/jingxuan/1/baisi_xiaohao-iphone-4.1/0-20.json", parameters: nil, success: { (result) in
            success(ASListsModel.getLists(result["list"].array!))
            }) { (error) in
               NSLog("请求失败")
        }
    }
    
    //获取top图片
    class func getTopImages(success:(AnyObject)->Void) {
        ASNetWorkHepler.getResponseData("http://api.budejie.com/api/api_open.php?a=get_top_promotion&appname=baisi_xiaohao&asid=34FC34B8-5F29-473B-B771-6EE702C04384&c=topic&client=iphone&device=ios%20device&from=ios&jbk=1&mac=&market=&openudid=df051fdd9cd44aa5e2a8b1de8547ad7188a996b9&udid=&ver=4.1", parameters: nil, success: { (result) in
            success(ASTopImagesModel.getImages(result["result"].dictionary!["list"]! .arrayObject!))
            }) { (error) in
                NSLog("请求失败")
        }
    }
    
}
