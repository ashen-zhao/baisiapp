//
//  ASListsModel.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/1.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
import SwiftyJSON

class ASListsModel: NSObject {
    
    var id = ""
    var type:ContentType = ContentType.Video
    var comment:AnyObject?
    var bookmark = ""
    var text = ""
    var up = ""
    var down:AnyObject?
    var forward = ""
    var share_url = ""
    var passtime = ""
    
    var tags = [ASTagsModel]()
    var u = ASUserModel()
    var video = ASVideoModel()
    var image = ASImageModel()
    var gif = ASGifModel()
    var top_comment = ASCommentModel()
    
    init(dict:JSON) {
        super.init()
        id = dict["id"].string!
        comment = dict["comment"].object
        bookmark = dict["bookmark"].string!
        text = dict["text"].string!
        up = dict["up"].string!
        down = dict["down"].object
        forward = dict["forward"].string!
        share_url = dict["share_url"].string!
        passtime = dict["passtime"].string!
        
        switch dict["type"].stringValue {
        case "video":
            type = ContentType.Video
        case "gif":
            type = ContentType.Gif
        case "image":
            type = ContentType.Image
        case "html":
            type = ContentType.Html
        case "text":
            type = ContentType.Text
        default:
            type = ContentType.Text
        }
        
        
        
        if dict["tags"] != nil {
            for item in dict["tags"].array! {
                let tag = ASTagsModel()
                tag.setValuesForKeysWithDictionary(item.dictionaryObject!)
                tags.append(tag)
            }
        }
        
        if dict["u"] != nil {
            let tempu = ASUserModel()
            tempu.setValuesForKeysWithDictionary(dict["u"].dictionaryObject!)
            u = tempu;
        }
     
        
        if dict["video"] != nil {
            let tempVideo = ASVideoModel()
            tempVideo.setValuesForKeysWithDictionary(dict["video"].dictionaryObject!)
            video = tempVideo
        }
        
        if dict["image"] != nil {
            let tempImage = ASImageModel()
            tempImage.setValuesForKeysWithDictionary(dict["image"].dictionaryObject!)
        }
        
        if dict["gif"] != nil {
            let tempImage = ASGifModel()
            tempImage.setValuesForKeysWithDictionary(dict["gif"].dictionaryObject!)
        }
        
        if dict["top_comment"] != nil {
            let tempComment = ASCommentModel()
            tempComment.setValuesForKeysWithDictionary(dict["top_comment"].dictionaryObject!)
            top_comment = tempComment
        }
    }
    
    class func getLists(jsonArr:[JSON])->NSMutableArray {
        let temArr = NSMutableArray()
        for dict in jsonArr {
            temArr.addObject(ASListsModel.init(dict: dict))
        }
        return temArr
    }
    
    
    
    
    
    
}
