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
    class func getMenusType(_ type:String, successs:@escaping (AnyObject)->Void, fails:()->Void){
        
        
        if let _ = UserDefaults.standard.object(forKey: type) {
            let data = UserDefaults.standard.object(forKey: type) as! Data
            let result = JSON(dataToJson(data)!)
            DispatchQueue.main.async(execute: {
                successs(ASMenusModel.getMenus(type, jsonArr: result["menus"].array!))
            })
        }
        
        ASNetWorkHepler.getResponseData("http://s.budejie.com/public/list-appbar/baisi_xiaohao-iphone-4.1", parameters: nil, success: { (result) in
            successs(ASMenusModel.getMenus(type, jsonArr: result["menus"].array!))
            let data = jsonToData(result.object as AnyObject)
            UserDefaults.standard.set(data, forKey: type)
            UserDefaults.standard.synchronize()
        }) { (error) in
            print("标题请求失败")
        }
    }
    
    //获取列表数据
    class func getListsWithMenuURL(_ url:String, lagePage:String, success:@escaping(AnyObject)->Void, lastPage:@escaping(AnyObject)->Void) {
        
        if lagePage == "0"{
            if let _ = UserDefaults.standard.object(forKey: url) {
                let data = UserDefaults.standard.object(forKey: url) as! Data
                let result = JSON(dataToJson(data)!)
                DispatchQueue.main.async(execute: {
                    success(ASListsModel.getLists(result["list"].array!))
                    lastPage(result["info"].dictionary!["np"]!.object as AnyObject)
                })
            }
        }
        
        ASNetWorkHepler.getResponseData(url + "/baisi_xiaohao-iphone-4.1/\(lagePage)-20.json", parameters: nil, success: { (result) in
            success(ASListsModel.getLists(result["list"].array!))
            lastPage(result["info"].dictionary!["np"]!.object as AnyObject)
            UserDefaults.standard.set(jsonToData(result.object as AnyObject), forKey: url)
            UserDefaults.standard.synchronize()
        }) { (error) in
            print("列表数据请求失败")
        }
    }
    
    //获取top图片
    class func getTopImages(_ success:@escaping(AnyObject)->Void,fails:()->Void) {
        
        if let _ = UserDefaults.standard.object(forKey: "topImage") {
            DispatchQueue.main.async(execute: {
                success(ASTopImagesModel.getImages(dataToJson(UserDefaults.standard.object(forKey: "topImage") as! Data) as! NSArray))
            })
        }
        
        ASNetWorkHepler.getResponseData("http://api.budejie.com/api/api_open.php?a=get_top_promotion&appname=baisi_xiaohao&asid=34FC34B8-5F29-473B-B771-6EE702C04384&c=topic&client=iphone&device=ios%20device&from=ios&jbk=1&mac=&market=&openudid=df051fdd9cd44aa5e2a8b1de8547ad7188a996b9&udid=&ver=4.1", parameters: nil, success: { (result) in
            success(ASTopImagesModel.getImages(result["result"].dictionary!["list"]! .arrayObject! as NSArray))
            UserDefaults.standard.set(jsonToData(result["result"].dictionary!["list"]! .arrayObject! as AnyObject), forKey: "topImage")
            UserDefaults.standard.synchronize()
        }) { (error) in
            print("顶部图片请求失败")
        }
    }
    
    class func getMyLists(_ success:@escaping(AnyObject)->Void,fails:(AnyObject)->Void) {
        if let _ = UserDefaults.standard.object(forKey: "tags") {
            let model = ASMineTagsModel()
            model.setValuesForKeys(dataToJson(UserDefaults.standard.object(forKey: "tags") as! Data) as! [String : AnyObject])
            DispatchQueue.main.async(execute: {
                success(model)
            })
        }
        ASNetWorkHepler.getResponseData("http://api.budejie.com/api/api_open.php?a=square&appname=baisi_xiaohao&asid=2CA17E5B-D6EB-43B0-95B6-EE70D8D466F7&c=topic&client=iphone&device=ios%20device&from=ios&jbk=1&mac=&market=&openudid=df051fdd9cd44aa5e2a8b1de8547ad7188a996b9&udid=&ver=4.1", parameters: nil, success: { (result) in
            let model = ASMineTagsModel()
            model.setValuesForKeys(result.object as! [String : AnyObject])
            success(model)
            
            UserDefaults.standard.set(jsonToData(result.object as AnyObject), forKey: "tags")
            UserDefaults.standard.synchronize()
        }) { (error) in
            print("我的界面请求失败")
        }
    }
    
    // MARK: methods
    
    class func clearCache() {
        let domain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: domain!)
    }
    
    fileprivate class func jsonToData(_ jsonResponse: AnyObject) -> Data? {
        
        do{
            let data = try JSONSerialization.data(withJSONObject: jsonResponse, options: JSONSerialization.WritingOptions.prettyPrinted)
            return data;
            
        }catch
        {
            return nil
        }
    }
    
    fileprivate class func dataToJson(_ data: Data) -> AnyObject? {
        
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            return json as AnyObject?
            
        }
        catch
        {
            return nil
        }
    }
}
