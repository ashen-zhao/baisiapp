//
//  ASTagsModel.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/1.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASTagsModel: NSObject, NSCoding {
    //    "tags": [
    //    {
    //    "id": 56,
    //    "name": "创意"
    //    }
    
    
    var id = 0
    var name = ""
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "tags")
    }
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.name = aDecoder.decodeObjectForKey("tags") as! String
    }

}
