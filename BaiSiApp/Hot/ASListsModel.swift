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
    
    var cellHeight:CGFloat!
    
    var frame:CGRect!
    
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
      
        if !dict["tags"].isEmpty{
            for item in dict["tags"].array! {
                let tag = ASTagsModel()
                tag.setValuesForKeysWithDictionary(item.dictionaryObject!)
                tags.append(tag)
            }
        }
        
        if !dict["u"].isEmpty {
            let tempu = ASUserModel()
            tempu.setValuesForKeysWithDictionary(dict["u"].dictionaryObject!)
            u = tempu;
        }
     
        
        if !dict["video"].isEmpty {
            let tempVideo = ASVideoModel()
            tempVideo.setValuesForKeysWithDictionary(dict["video"].dictionaryObject!)
            video = tempVideo
        }
        
        if !dict["image"].isEmpty {
            let tempImage = ASImageModel()
            tempImage.setValuesForKeysWithDictionary(dict["image"].dictionaryObject!)
        }
        
        if !dict["gif"].isEmpty {
            let tempImage = ASGifModel()
            tempImage.setValuesForKeysWithDictionary(dict["gif"].dictionaryObject!)
        }
        
        if !dict["top_comment"].isEmpty {
            let tempComment = ASCommentModel()
            tempComment.setValuesForKeysWithDictionary(dict["top_comment"].dictionaryObject!)
            top_comment = tempComment
        }
        
        let txtSize = ASToolHelper.getSizeForText(text, size: CGSizeMake(ASMainWidth - 36, CGFloat.max), font: 17)
        
        switch dict["type"].stringValue {
        case "video":
            cellHeight(CGFloat(video.width), h: CGFloat(video.height), txtHeight:txtSize.height, topComment: dict["top_comment"])
            type = ContentType.Video
            
        case "gif":
            if CGFloat(gif.width) > ASMainWidth - 20 {
                gif.height = (Int)(ASMainWidth - 20) * gif.height / gif.width
                gif.width = Int(ASMainWidth) - 20
            }
            
            if CGFloat(gif.height) > ASMainHeight - 64 {
                gif.width = (Int)(ASMainHeight - 64) * gif.width / gif.height
                gif.height = Int(ASMainHeight) - 64
            }
            
            frame = CGRectMake(10, 8, CGFloat(gif.width), CGFloat(gif.height))
            cellHeight = CGFloat(gif.height) + txtSize.height + ASTopAndBottomHeight + 40
            if dict["top_comment"] != nil {
                cellHeight = cellHeight + ASToolHelper.getSizeForText(top_comment.content, size: CGSizeMake(ASMainWidth - 20, CGFloat.max), font: 14).height + 30
            }
            type = ContentType.Video

        case "image":
            cellHeight = CGFloat(image.height) + txtSize.height +  62 + 65 + 40
            frame = CGRectMake(0, 0, CGFloat(image.width), CGFloat(image.height))
            type = ContentType.Image
        case "html":
            cellHeight = txtSize.height +  62 + 65 + 40
            type = ContentType.Html
        case "text":
            cellHeight = txtSize.height +  62 + 65 + 40
            type = ContentType.Text
        default:
            cellHeight = txtSize.height +  62 + 65 + 40
            type = ContentType.Text
        }
        
    }
    
    class func getLists(jsonArr:[JSON])->NSMutableArray {
        let temArr = NSMutableArray()
        for dict in jsonArr {
            //暂时先处理视频
            if dict["type"] == "video" {
                temArr.addObject(ASListsModel.init(dict: dict))
            }
        }
        return temArr
    }
    
    
    
    func cellHeight(w:CGFloat, h:CGFloat, txtHeight:CGFloat, topComment:JSON) {
        var width = w
        var height = h
        if width > ASMainWidth - 20 {
            height =  (ASMainWidth - 20) * height / width
            width = ASMainWidth - 20
        }
        
        if height > ASMainHeight - 64 {
            width = (ASMainHeight - 64) * width / height
            height = ASMainHeight - 64
        }
        
        frame = CGRectMake(10, 8, width, height)
        cellHeight = height + txtHeight + ASTopAndBottomHeight + 40
        
        if !topComment.isEmpty {
            cellHeight = cellHeight + ASToolHelper.getSizeForText(top_comment.content, size: CGSizeMake(ASMainWidth - 20, CGFloat.max), font: 14).height + 30
        }
    }
    
    
}
