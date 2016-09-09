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
        
        
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey(type) {
            let data = NSUserDefaults.standardUserDefaults().objectForKey(type) as! NSData
            let result = JSON(dataToJson(data)!)
            dispatch_async(dispatch_get_main_queue(),{
                successs(ASMenusModel.getMenus(type, jsonArr: result["menus"].array!))
            })
        }
        
        ASNetWorkHepler.getResponseData("http://s.budejie.com/public/list-appbar/baisi_xiaohao-iphone-4.1", parameters: nil, success: { (result) in
            successs(ASMenusModel.getMenus(type, jsonArr: result["menus"].array!))
            let data = jsonToData(result.object)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: type)
            NSUserDefaults.standardUserDefaults().synchronize()
        }) { (error) in
            print("标题请求失败")
        }
    }
    
    //获取列表数据
    class func getListsWithMenuURL(url:String, lagePage:String, success:(AnyObject)->Void, lastPage:(AnyObject)->Void) {
        
        if lagePage == "0"{
            if let _ = NSUserDefaults.standardUserDefaults().objectForKey(url) {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(url) as! NSData
                let result = JSON(dataToJson(data)!)
                dispatch_async(dispatch_get_main_queue(),{
                    success(ASListsModel.getLists(result["list"].array!))
                    lastPage(result["info"].dictionary!["np"]!.object)
                })
            }
        }
        
        ASNetWorkHepler.getResponseData(url.stringByAppendingString("/baisi_xiaohao-iphone-4.1/\(lagePage)-20.json"), parameters: nil, success: { (result) in
            success(ASListsModel.getLists(result["list"].array!))
            lastPage(result["info"].dictionary!["np"]!.object)
            NSUserDefaults.standardUserDefaults().setObject(jsonToData(result.object), forKey: url)
            NSUserDefaults.standardUserDefaults().synchronize()
        }) { (error) in
            print("列表数据请求失败")
        }
    }
    
    //获取top图片
    class func getTopImages(success:(AnyObject)->Void,fails:()->Void) {
        
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey("topImage") {
            dispatch_async(dispatch_get_main_queue(), {
                success(ASTopImagesModel.getImages(dataToJson(NSUserDefaults.standardUserDefaults().objectForKey("topImage") as! NSData) as! NSArray))
            })
        }
        
        ASNetWorkHepler.getResponseData("http://api.budejie.com/api/api_open.php?a=get_top_promotion&appname=baisi_xiaohao&asid=34FC34B8-5F29-473B-B771-6EE702C04384&c=topic&client=iphone&device=ios%20device&from=ios&jbk=1&mac=&market=&openudid=df051fdd9cd44aa5e2a8b1de8547ad7188a996b9&udid=&ver=4.1", parameters: nil, success: { (result) in
            success(ASTopImagesModel.getImages(result["result"].dictionary!["list"]! .arrayObject!))
            NSUserDefaults.standardUserDefaults().setObject(jsonToData(result["result"].dictionary!["list"]! .arrayObject!), forKey: "topImage")
            NSUserDefaults.standardUserDefaults().synchronize()
        }) { (error) in
            print("顶部图片请求失败")
        }
    }
    
    class func getMyLists(success:(AnyObject)->Void,fails:(AnyObject)->Void) {
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey("tags") {
            let model = ASMineTagsModel()
            model.setValuesForKeysWithDictionary(dataToJson(NSUserDefaults.standardUserDefaults().objectForKey("tags") as! NSData) as! [String : AnyObject])
            dispatch_async(dispatch_get_main_queue(), {
                success(model)
            })
        }
        ASNetWorkHepler.getResponseData("http://api.budejie.com/api/api_open.php?a=square&appname=baisi_xiaohao&asid=2CA17E5B-D6EB-43B0-95B6-EE70D8D466F7&c=topic&client=iphone&device=ios%20device&from=ios&jbk=1&mac=&market=&openudid=df051fdd9cd44aa5e2a8b1de8547ad7188a996b9&udid=&ver=4.1", parameters: nil, success: { (result) in
            let model = ASMineTagsModel()
            model.setValuesForKeysWithDictionary(result.object as! [String : AnyObject])
            success(model)
            
            NSUserDefaults.standardUserDefaults().setObject(jsonToData(result.object), forKey: "tags")
            NSUserDefaults.standardUserDefaults().synchronize()
        }) { (error) in
            print("我的界面请求失败")
        }
    }
    
    // MARK: methods
    
    class func clearCache() {
        let domain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(domain!)
    }
    
    private class func jsonToData(jsonResponse: AnyObject) -> NSData? {
        
        do{
            let data = try NSJSONSerialization.dataWithJSONObject(jsonResponse, options: NSJSONWritingOptions.PrettyPrinted)
            return data;
            
        }catch
        {
            return nil
        }
    }
    
    private class func dataToJson(data: NSData) -> AnyObject? {
        
        do{
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            return json
            
        }
        catch
        {
            return nil
        }
    }
}
