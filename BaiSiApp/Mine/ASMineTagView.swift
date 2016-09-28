//
//  ASMineTagView.swift
//  BaiSiApp
//
//  Created by ashen on 16/8/24.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASMineTagView: UIView {
    
    @IBOutlet weak var iconImgv: UIImageView!

    @IBOutlet weak var lblIconTitle: UILabel!
    
    var actionUrl = "http://www.devashen.com"
    
    class func mineTagView() -> ASMineTagView {
        return NSBundle.mainBundle().loadNibNamed("ASMineTagView", owner: nil, options: nil)![0] as! ASMineTagView
    }
    
    @IBAction func iconTapAction(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("NOTIICONACTION", object: actionUrl)
    }
}
