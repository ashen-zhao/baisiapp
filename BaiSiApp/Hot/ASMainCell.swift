//
//  ASMainCell.swift
//  BaiSiApp
//
//  Created by ashen on 16/3/29.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
import Kingfisher

class ASMainCell: UITableViewCell {

    @IBOutlet weak var imgVHeader: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var lblTopCommentTip: ASCustomLabel!
    
    @IBOutlet weak var lblComment: UILabel!
    
    @IBOutlet weak var scrollTag: UIScrollView!
    
    @IBOutlet weak var btnDing: UIButton!
    
    @IBOutlet weak var btnBad: UIButton!
    
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var btnComment: UIButton!

    @IBOutlet weak var centerView: UIView!
    
    typealias callbackFunc = (ASMainCell)->()
    
    var blc_currentCell:callbackFunc!
    
    var video_View:ASVideoView!
    
    var image_View:ASImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupData(_ listModel:ASListsModel) {
        
        imgVHeader.kf.setImage(with: ImageResource(downloadURL: URL(string: listModel.u.header.count > 0 ? listModel.u.header[0] : "http://www.devashen.com/default.png")!))
        lblText.text = listModel.text
        lblName.text = listModel.u.name
        lblTime.text = listModel.passtime
    
        for v in centerView.subviews {
            if v.isKind(of: ASVideoView.self) {
                (v as! ASVideoView).player.stop()
            }
            NotificationCenter.default.removeObserver(v)
            v.removeFromSuperview()
        }
        
        switch listModel.type {
        case .Video:
            video_View = ASVideoView.videoView()
            video_View.blc_Touch = {() -> () in
                self.blc_currentCell(self)
            }
            video_View.frame = listModel.frame
            video_View.videoModel = listModel.video
            centerView.addSubview(video_View)
        case .Gif: fallthrough
        case .Image:
            image_View = ASImageView.imageView()
            image_View.frame = listModel.frame
            image_View.listModel = listModel
            centerView.addSubview(image_View)
        default:
            break
        }
        
        lblTopCommentTip.isHidden = listModel.top_comment.content.isEmpty
        lblComment.isHidden = listModel.top_comment.content.isEmpty
        lblComment.text = listModel.top_comment.user.name + ": " + listModel.top_comment.content
        
        btnDing.setTitle(" " + listModel.up, for: UIControl.State())
        btnBad.setTitle(" \(listModel.down!)", for: UIControl.State())
        
        btnShare.setTitle(" \(listModel.forward!)", for: UIControl.State())
        btnComment.setTitle(" \(listModel.comment!)", for: UIControl.State())
        
        
        for item in scrollTag.subviews {
            item.removeFromSuperview()
        }
        var lastTagBtn:UIButton!
        var tagContentWidth:CGFloat = 0.0
        for i in 0..<listModel.tags.count {
            
            let tagBtn = UIButton(type: .custom)
            
            let width = ASToolHelper.getSizeForText(listModel.tags[i].name as NSString, size: CGSize(width: self.frame.width - 20, height: 30),font: 15).width
            
            tagBtn.frame = CGRect.init(x: i == 0 ? 0 :lastTagBtn.frame.maxX, y: 0, width: width + 10, height: 30)
            tagBtn.setTitle(listModel.tags[i].name, for: UIControl.State())
            tagBtn.setTitleColor(UIColor.lightGray, for: UIControl.State())
            tagBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            scrollTag.addSubview(tagBtn)
            lastTagBtn = tagBtn
            tagContentWidth += (width + 10)
        }
        scrollTag.contentSize = CGSize(width: tagContentWidth, height: 30)
    }
    
    class func getCellHeight(_ listModel:ASListsModel) -> CGFloat {
      return listModel.cellHeight
    }
  
}
