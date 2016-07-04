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
    var forward:AnyObject?
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
    var isLongLongImage:Bool!
    
    init(dict:JSON) {
        super.init()
        id = dict["id"].string!
        comment = dict["comment"].object
        bookmark = dict["bookmark"].string!
        text = dict["text"].string!
        up = dict["up"].string!
        down = dict["down"].object
        forward = dict["forward"].object
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
            image = tempImage
        }
        
        if !dict["gif"].isEmpty {
            let tempImage = ASGifModel()
            tempImage.setValuesForKeysWithDictionary(dict["gif"].dictionaryObject!)
            gif = tempImage
        }
        
        if !dict["top_comment"].isEmpty {
            let tempComment = ASCommentModel()
            tempComment.setValuesForKeysWithDictionary(dict["top_comment"].dictionaryObject!)
            top_comment = tempComment
        }
        
        let txtSize = ASToolHelper.getSizeForText(text, size: CGSizeMake(ASMainWidth - 36, CGFloat.max), font: 17)
        
        switch dict["type"].stringValue {
        case "video":
            type = ContentType.Video
            cellHeight(CGFloat(video.width), h: CGFloat(video.height), txtHeight:txtSize.height)
            
        case "gif":
            type = ContentType.Gif
            cellHeight(CGFloat(gif.width), h: CGFloat(gif.height), txtHeight: txtSize.height)
            
        case "image":
            type = ContentType.Image
            cellHeight(CGFloat(image.width), h: CGFloat(image.height), txtHeight: txtSize.height)
            
        case "html":
            type = ContentType.Html
            cellHeight = txtSize.height +  ASSpaceHeight
            
        case "text":
            type = ContentType.Text
            cellHeight = txtSize.height +  ASSpaceHeight
            addCommentHeight()
        default:
            type = ContentType.Text
            cellHeight = txtSize.height +  ASSpaceHeight
        }
    }
    
    class func getLists(jsonArr:[JSON])->NSMutableArray {
        let temArr = NSMutableArray()
        for dict in jsonArr {
            //暂时先处理视频
            if dict["type"] != "html"{
                temArr.addObject(ASListsModel.init(dict: dict))
            }
        }
        return temArr
    }
    
    
    
    func cellHeight(w:CGFloat, h:CGFloat, txtHeight:CGFloat) {
        var width = w
        var height = h
        if width > ASMainWidth - 20 {
            height =  (ASMainWidth - 20) * height / width
            width = ASMainWidth - 20
        }
        
        if width < ASMainWidth - 20 {
            height =  (ASMainWidth - 20) * height / width
            width = ASMainWidth - 20
        }
        
        isLongLongImage = false
        if height > 3 * (ASMainHeight - 64) {
            width = (ASMainWidth - 20)
            height = width
            isLongLongImage = true
        }
        
        frame = CGRectMake((ASMainWidth - width) / 2, 0, width, height)
        
        cellHeight = height + txtHeight + ASSpaceHeight
        
        addCommentHeight()
    }
    func addCommentHeight() {
        if !top_comment.content.isEmpty {
            cellHeight = cellHeight + ASToolHelper.getSizeForText(top_comment.content + top_comment.user.name + ": ", size: CGSizeMake(ASMainWidth - 24, CGFloat.max), font: 14).height + 15
        }
    }
    
}
