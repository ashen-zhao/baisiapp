//
//  ASNetWorkHepler.swift
//  BaiSiApp
//
//  Created by ashen on 16/3/30.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ASNetWorkHepler: NSObject {
    
    class func getResponseData(url:String, parameters:[String:AnyObject]? = nil, success:(result:JSON)-> Void, error:(error:NSError)->Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.GET, url, parameters: parameters).responseJSON {
            response in
            if let jsonData = response.result.value {
                success(result: JSON(jsonData))
            } else if let er = response.result.error {
                error(error:er)
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
}
