//
//  ASVideoView.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/6.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASVideoView: UIView {

    @IBOutlet weak var lblPlayCount: UILabel!
    
    @IBOutlet weak var lblPlayTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = .None
    }
    
    class func videoView() -> ASVideoView {
        return NSBundle.mainBundle().loadNibNamed("ASVideoView", owner: nil, options: nil)[0] as! ASVideoView
    }
   
}
