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
        
        let txtSize = ASToolHelper.getSizeForText(text, size: CGSizeMake(ASMainWidth - 36, CGFloat.max), font: 17)
        
        switch dict["type"].stringValue {
        case "video":
         
            if CGFloat(video.width) > ASMainWidth - 20 {
                video.height = (Int)(ASMainWidth - 20) * video.height / video.width
                video.width = Int(ASMainWidth) - 20
            }

            if CGFloat(video.height) > ASMainHeight - 64 {
                video.width = (Int)(ASMainHeight - 64) * video.width / video.height
                video.height = Int(ASMainHeight) - 64
            }
            
            frame = CGRectMake(10, 8, CGFloat(video.width), CGFloat(video.height))
            //71上部分高度，40操作按钮高度，30标签高度，40评论框
            cellHeight = CGFloat(video.height) + txtSize.height + ASTopAndBottomHeight + 30
            if dict["top_comment"] != nil {
                cellHeight += 40
            }
            type = ContentType.Video
            
        case "gif":
            cellHeight = CGFloat(gif.height) + txtSize.height +  62 + 65 + 40
            frame = CGRectMake(0, 0, CGFloat(gif.width), CGFloat(gif.height))
            type = ContentType.Gif
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
    
    
    
    
    
    
}
