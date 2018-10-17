//
//  ASMineTagCell.swift
//  BaiSiApp
//
//  Created by ashen on 16/8/24.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
import Kingfisher

class ASMineTagCell: UITableViewCell {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func makeUIByData(_ tagsModel:ASMineTagsModel) {
        
        var x:CGFloat = 0
        var y:CGFloat = 0
        let width:CGFloat = contentView.frame.size.width / 4
        
        var index = 0
        let count = tagsModel.square_list.count
        for _ in 0...(count / 4) {
            for _ in 1...4 {
                index += 1
                if index > count {
                    break
                }
                let tv = ASMineTagView.mineTagView()
                let imgURL = tagsModel.square_list[index - 1]
                if imgURL is NSDictionary {
                    tv.iconImgv.kf.setImage(with: ImageResource.init(downloadURL:URL(string: tagsModel.square_list[index - 1]["icon"] as! String)!))
                    
                    tv.lblIconTitle.text = tagsModel.square_list[index - 1]["name"] as? String
                    tv.actionUrl = (tagsModel.square_list[index - 1]["url"] as? String)!
                    tv.frame = CGRect(x: x, y: y, width: width, height: width + 20)
                    contentView.addSubview(tv)
                    x += width
                }
            }
            x = 0
            y += (width + 20)
      }
    }
}
