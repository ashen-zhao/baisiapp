//
//  ASImageView.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/13.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
import Kingfisher

class ASImageView: UIView {

    @IBOutlet weak var isGifImg: UIImageView!
    @IBOutlet weak var bgkImageV: UIImageView!
    @IBOutlet weak var imgLoadProgress: UILabel!
    @IBOutlet weak var btnCheckLongImage: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = .None
    }
    
    class func imageView() -> ASImageView {
        return NSBundle.mainBundle().loadNibNamed("ASImageView", owner: nil, options: nil)[0] as! ASImageView
    }
    
    @IBOutlet weak var lookBigImg: UIButton!
    
    var listModel:ASListsModel! {
        didSet {
            if listModel.type == .Image {
                isGifImg.hidden = true
                bgkImageV.kf_setImageWithURL(NSURL(string:listModel.image.big.count > 0 ? listModel.image.big[0]: "")!, placeholderImage: nil, optionsInfo: nil, progressBlock: { (receivedSize, totalSize) in
                    self.imgLoadProgress.text = NSString(string: "\((Int(CGFloat(receivedSize)/CGFloat(totalSize) * 100)))%") as String;
                    }, completionHandler: { (image, error, cacheType, imageURL) in
                        self.imgLoadProgress.hidden = true
                })
                btnCheckLongImage.hidden = !listModel.isLongLongImage
                bgkImageV.contentMode = listModel.isLongLongImage == true ? .Top : .ScaleAspectFit;
            } else {
                isGifImg.hidden = false
                bgkImageV.kf_setImageWithURL(NSURL(string:listModel.gif.images.count > 0 ? listModel.gif.images[0]: "")!, placeholderImage: nil, optionsInfo: nil, progressBlock: { (receivedSize, totalSize) in
                    self.imgLoadProgress.text = NSString(string: "\((Int(CGFloat(receivedSize)/CGFloat(totalSize) * 100)))%") as String;
                    }, completionHandler: { (image, error, cacheType, imageURL) in
                        self.imgLoadProgress.hidden = true
                })

                btnCheckLongImage.hidden = !listModel.isLongLongImage
            }
        }
    }
    
}
