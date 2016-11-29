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
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "tags")
    }
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.name = aDecoder.decodeObject(forKey: "tags") as! String
    }

}
