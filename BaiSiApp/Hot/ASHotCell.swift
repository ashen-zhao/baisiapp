//
//  ASHotCell.swift
//  BaiSiApp
//
//  Created by ashen on 16/3/29.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
import Kingfisher

class ASHotCell: UITableViewCell {

    @IBOutlet weak var imgVHeader: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var lblComment: UILabel!
    
    @IBOutlet weak var scrollTag: UIScrollView!
    
    @IBOutlet weak var btnDing: UIButton!
    
    @IBOutlet weak var btnBad: UIButton!
    
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var btnComment: UIButton!


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupData(listModel:ASListsModel) {
        imgVHeader.kf_setImageWithURL(NSURL(string: listModel.u.header[0])!, placeholderImage: UIImage(named: "defaultUserIcon"))
        lblText.text = listModel.text
        lblName.text = listModel.u.name
        lblTime.text = listModel.passtime
        lblComment.text = listModel.top_comment.content
        btnDing.setTitle(" " + listModel.up, forState: .Normal)
        btnBad.setTitle(" \(listModel.down!)", forState: .Normal)
        btnShare.setTitle(" " + listModel.forward, forState: .Normal)
        btnComment.setTitle(" \(listModel.comment!)", forState: .Normal)
    }
    
    class func getSizeForString(string:String) {
        
    }
    

}
