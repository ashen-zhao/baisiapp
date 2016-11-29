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
    @IBOutlet weak var lookBigImg: UIButton!
    
    var image:UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = UIViewAutoresizing()
    }
    
    class func imageView() -> ASImageView {
        return Bundle.main.loadNibNamed("ASImageView", owner: nil, options: nil)![0] as! ASImageView
    }
    
    
    @IBAction func lookBigImgAction(_ sender: AnyObject) {
        if !self.imgLoadProgress.isHidden {
            return
        }
        
        let browser = ASImgBrowserController.init()
        browser.listModel = self.listModel
        browser.image = image
        browser.isGIF = self.listModel.type == .Image ? false : true
        UIApplication.shared.keyWindow?.rootViewController?.present(browser, animated: true, completion: nil)
    }
    
    var listModel:ASListsModel! {
        didSet {
            if listModel.type == .Image {
                isGifImg.isHidden = true
                
                bgkImageV.kf.setImage(with: ImageResource.init(downloadURL: URL(string:listModel.image.big.count > 0 ? listModel.image.big[0]: "")!), placeholder: nil, options: nil, progressBlock:{ (receivedSize, totalSize) in
                    self.imgLoadProgress.text = NSString(string: "\((Int(CGFloat(receivedSize)/CGFloat(totalSize) * 100)))%") as String;
                }, completionHandler: { (image, error, cache, url) in
                    if (error == nil) {
                        self.imgLoadProgress.isHidden = true
                        self.image = self.bgkImageV.image
                    }
                })
                
                lookBigImg.isHidden = !listModel.isLongLongImage
                bgkImageV.contentMode = listModel.isLongLongImage == true ? .top : .scaleAspectFit;
            } else {
                isGifImg.isHidden = false
                bgkImageV.kf.setImage(with: ImageResource.init(downloadURL: URL(string:listModel.gif.images.count > 0 ? listModel.gif.images[0]: "")!), placeholder: nil, options: nil, progressBlock: { (receivedSize, totalSize) in
                    self.imgLoadProgress.text = NSString(string: "\((Int(CGFloat(receivedSize)/CGFloat(totalSize) * 100)))%") as String;
                    }, completionHandler: { (image, error, cacheType, imageURL) in
                        if (error == nil) {
                            self.imgLoadProgress.isHidden = true
                            self.image = self.bgkImageV.image
                        }
                })
                lookBigImg.isHidden = !listModel.isLongLongImage
            }
        }
    }
}
