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
    class func getMenusType(type:String, successs:(AnyObject)->Void, fails:()->Void){
        ASNetWorkHepler.getResponseData("http://s.budejie.com/public/list-appbar/baisi_xiaohao-iphone-4.1", parameters: nil, success: { (result) in
            successs(ASMenusModel.getMenus(type, jsonArr: result["menus"].array!))
        }) { (error) in
            fails()
            print("请求失败")
        }
    }
    
    //获取列表数据
    class func getListsWithMenuURL(url:String, lagePage:String, success:(AnyObject)->Void, lastPage:(AnyObject)->Void) {
        ASNetWorkHepler.getResponseData(url.stringByAppendingString("/baisi_xiaohao-iphone-4.1/\(lagePage)-20.json"), parameters: nil, success: { (result) in
            success(ASListsModel.getLists(result["list"].array!))
            lastPage(result["info"].dictionary!["np"]!.object)
        }) { (error) in
            print("请求失败")
        }
    }

    //获取top图片
    class func getTopImages(success:(AnyObject)->Void,fails:()->Void) {
        ASNetWorkHepler.getResponseData("http://api.budejie.com/api/api_open.php?a=get_top_promotion&appname=baisi_xiaohao&asid=34FC34B8-5F29-473B-B771-6EE702C04384&c=topic&client=iphone&device=ios%20device&from=ios&jbk=1&mac=&market=&openudid=df051fdd9cd44aa5e2a8b1de8547ad7188a996b9&udid=&ver=4.1", parameters: nil, success: { (result) in
            success(ASTopImagesModel.getImages(result["result"].dictionary!["list"]! .arrayObject!))
            NSUserDefaults.standardUserDefaults().setObject(result["result"].dictionary!["list"]! .arrayObject!, forKey: "topImage")
        }) { (error) in
            
            if let _ = NSUserDefaults.standardUserDefaults().objectForKey("topImage") {
               success(ASTopImagesModel.getImages(NSUserDefaults.standardUserDefaults().objectForKey("topImage")! as! NSArray))
            }
        }
    }
    
    class func getMyLists(success:(AnyObject)->Void,fails:(AnyObject)->Void) {
     ASNetWorkHepler.getResponseData("http://api.budejie.com/api/api_open.php?a=square&appname=baisi_xiaohao&asid=2CA17E5B-D6EB-43B0-95B6-EE70D8D466F7&c=topic&client=iphone&device=ios%20device&from=ios&jbk=1&mac=&market=&openudid=df051fdd9cd44aa5e2a8b1de8547ad7188a996b9&udid=&ver=4.1", parameters: nil, success: { (result) in
        let model = ASMineTagsModel()
        model.setValuesForKeysWithDictionary(result.object as! [String : AnyObject])
        success(model)
        NSUserDefaults.standardUserDefaults().setObject(result.object, forKey: "tags")
        }) { (error) in
             if let _ = NSUserDefaults.standardUserDefaults().objectForKey("tags") {
                let model = ASMineTagsModel()
                model.setValuesForKeysWithDictionary(NSUserDefaults.standardUserDefaults().objectForKey("tags") as! [String : AnyObject])
                success(model)
            }
        }
    }
    
}
