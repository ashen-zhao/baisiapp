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
    
    class func getResponseData(_ url:String, parameters:[String:AnyObject]? = nil, success:@escaping(_ result:JSON)-> Void, error:@escaping (_ error:NSError)->Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        Alamofire.request(url, parameters: parameters).responseJSON { (response) in
            if let jsonData = response.result.value {
                success(JSON(jsonData))
            } else if let er = response.result.error {
                error(er as NSError)
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false

        }
    }
}
