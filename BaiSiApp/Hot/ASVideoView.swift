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
    
    @IBOutlet weak var bgkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = .None
    }
    
    class func videoView() -> ASVideoView {
        return NSBundle.mainBundle().loadNibNamed("ASVideoView", owner: nil, options: nil)[0] as! ASVideoView
    }
   
    var videoModel:ASVideoModel! {
        didSet {
            bgkImageView.kf_setImageWithURL(NSURL(string: videoModel.thumbnail.count > 0 ? videoModel.thumbnail[0]: "")!)
            lblPlayCount.text = "\(videoModel.playcount) 播放"
            lblPlayTime.text = getNormalTime(videoModel.duration)
        }
    }
    
    func getNormalTime(second:Int)->String {
        return "\(second / 60):\(String(format: "%02d", second % 60))"
    }
}
