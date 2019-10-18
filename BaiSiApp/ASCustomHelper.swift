//
//  ASCustomHelper.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/6.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit


var ASMainWidth = UIScreen.main.bounds.width
var ASMainHeight = UIScreen.main.bounds.height
//上67， 下35， 标签30， 间隔上8，下5，中8

var ASSpaceHeight:CGFloat = 67 + 35 + 30 + 8 + 5 + 8



enum ContentType:String {
    case Video = "video"
    case Gif = "gif"
    case Image = "image"
    case Text = "text"
    case Html = "html"
}

