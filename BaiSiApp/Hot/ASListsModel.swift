//
//  ASListsModel.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/1.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
import SwiftyJSON

class ASListsModel: NSObject, NSCoding {
    
    var id = ""
    var type:ContentType = ContentType.Video
    var typetemp = ""
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
        comment = dict["comment"].object as AnyObject?
        bookmark = dict["bookmark"].string!
        text = dict["text"].string!
        up = dict["up"].string!
        down = dict["down"].object as AnyObject?
        forward = dict["forward"].object as AnyObject?
        share_url = dict["share_url"].string!
        passtime = dict["passtime"].string!
        
        if !dict["tags"].isEmpty {
            for item in dict["tags"].array! {
                let tag = ASTagsModel()
                tag.setValuesForKeys(item.dictionaryObject!)
                tags.append(tag)
            }
        }
        
        if !dict["u"].isEmpty {
            let tempu = ASUserModel()
            tempu.setValuesForKeys(dict["u"].dictionaryObject!)
            u = tempu;
        }
        
        
        if !dict["video"].isEmpty {
            let tempVideo = ASVideoModel()
            tempVideo.setValuesForKeys(dict["video"].dictionaryObject!)
            video = tempVideo
        }
        
        if !dict["image"].isEmpty {
            let tempImage = ASImageModel()
            tempImage.setValuesForKeys(dict["image"].dictionaryObject!)
            image = tempImage
        }
        
        if !dict["gif"].isEmpty {
            let tempImage = ASGifModel()
            tempImage.setValuesForKeys(dict["gif"].dictionaryObject!)
            gif = tempImage
        }
        
        if !dict["top_comment"].isEmpty {
            let tempComment = ASCommentModel()
            tempComment.setValuesForKeys(dict["top_comment"].dictionaryObject!)
            top_comment = tempComment
        }
        
        let txtSize = ASToolHelper.getSizeForText(text as NSString, size: CGSize(width: ASMainWidth - 36, height: CGFloat.greatestFiniteMagnitude), font: 17)
        typetemp = dict["type"].stringValue
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
    
    class func getLists(_ jsonArr:[JSON])->NSMutableArray {
        let temArr = NSMutableArray()
        for dict in jsonArr {
            //暂时先处理视频
            if dict["type"] != "html"{
                temArr.add(ASListsModel.init(dict: dict))
            }
        }
        return temArr
    }
    
    
    
    func cellHeight(_ w:CGFloat, h:CGFloat, txtHeight:CGFloat) {
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
        let num:CGFloat = type == .Video ? 1 : 3
        if height > num * (ASMainHeight - 64) {
            width = (ASMainWidth - 20)
            height = width
            isLongLongImage = true
        }
        
        frame = CGRect(x: (ASMainWidth - width) / 2, y: 0, width: width, height: height)
        
        cellHeight = height + txtHeight + ASSpaceHeight
        
        addCommentHeight()
    }
    func addCommentHeight() {
        if !top_comment.content.isEmpty {
            
            cellHeight = cellHeight + ASToolHelper.getSizeForText(String(format: "%@%@: ", top_comment.content, top_comment.user.name) as NSString, size: CGSize(width: ASMainWidth - 24, height: CGFloat.greatestFiniteMagnitude), font: 14).height + 15
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(typetemp, forKey: "typetemp")
        aCoder.encode(comment, forKey: "comment")
        aCoder.encode(bookmark, forKey: "bookmark")
        aCoder.encode(text, forKey: "text")
        aCoder.encode(up, forKey: "up")
        aCoder.encode(down, forKey: "down")
        aCoder.encode(forward, forKey: "forward")
        aCoder.encode(share_url, forKey: "share_url")
        aCoder.encode(passtime, forKey: "passtime")
        
        aCoder.encode(tags, forKey: "tags")
        aCoder.encode(u, forKey: "user")
        aCoder.encode(video, forKey: "video")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(gif, forKey: "gif")
        aCoder.encode(top_comment, forKey: "top_comment")
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.comment = aDecoder.decodeObject(forKey: "comment") as AnyObject?
        self.bookmark = aDecoder.decodeObject(forKey: "bookmark") as! String
        self.text = aDecoder.decodeObject(forKey: "text") as! String
        self.up = aDecoder.decodeObject(forKey: "up") as! String
        self.down = aDecoder.decodeObject(forKey: "down") as AnyObject?
        self.forward = aDecoder.decodeObject(forKey: "forward") as AnyObject?
        self.share_url = aDecoder.decodeObject(forKey: "share_url") as! String
        self.passtime = aDecoder.decodeObject(forKey: "passtime") as! String
        
        self.tags = aDecoder.decodeObject(forKey: "tags") as! [ASTagsModel]
        self.u = aDecoder.decodeObject(forKey: "user") as! ASUserModel
        self.video = aDecoder.decodeObject(forKey: "video") as! ASVideoModel
        self.image = aDecoder.decodeObject(forKey: "image") as! ASImageModel
        self.gif = aDecoder.decodeObject(forKey: "gif") as! ASGifModel
        self.top_comment = aDecoder.decodeObject(forKey: "top_comment") as! ASCommentModel
        
        self.typetemp = aDecoder.decodeObject(forKey: "typetemp") as! String
        
        let txtSize = ASToolHelper.getSizeForText(text as NSString, size: CGSize(width: ASMainWidth - 36, height: CGFloat.greatestFiniteMagnitude), font: 17)
        switch typetemp {
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
    
    
}
