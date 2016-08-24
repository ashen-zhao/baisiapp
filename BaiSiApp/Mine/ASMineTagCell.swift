//
//  ASMineTagCell.swift
//  BaiSiApp
//
//  Created by ashen on 16/8/24.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASMineTagCell: UITableViewCell {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func makeUIByData() {
        
        var x:CGFloat = 0
        var y:CGFloat = 0
        let width:CGFloat = contentView.frame.size.width / 4
        
        var index = 0
        let count = 10
        for _ in 0...(count / 4) {
            for _ in 1...4 {
                index += 1
                if index > count {
                    break
                }
                let tv = ASMineTagView.mineTagView()
                tv.frame = CGRectMake(x, y, width, width + 20)
                contentView.addSubview(tv)
                x += width
            }
            x = 0
            y += (width + 20)
      }
    }
}
