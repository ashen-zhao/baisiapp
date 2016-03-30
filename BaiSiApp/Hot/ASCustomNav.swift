//
//  ASCustomNav.swift
//  BaiSiApp
//
//  Created by ashen on 16/3/29.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASCustomNav: UIView {
    
    
    var scrollView:UIScrollView!
    var leftImg:UIImageView!
    var rightImg:UIImageView!
    var randowBtn:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        
        scrollView = UIScrollView(frame: CGRect.init(x: 0, y: 0, width:self.frame.size.width - 50, height: self.frame.size.height))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.addSubview(scrollView)
        
        leftImg = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 10, height: scrollView.frame.size.height))
        leftImg.image = UIImage(named: "left_bg")
        self.addSubview(leftImg)
        
        rightImg = UIImageView(frame: CGRect.init(x: CGRectGetMaxX(scrollView.frame) - 10, y: 0, width: 10, height: scrollView.frame.size.height))
        rightImg.image = UIImage(named: "right_bg")
        self.addSubview(rightImg)
        
        randowBtn = UIButton(type: .Custom)
        randowBtn.frame = CGRectMake(CGRectGetMaxX(scrollView.frame), 0, 40, self.frame.size.height)
        randowBtn.setImage(UIImage(named: "RandomAcross"), forState: .Normal)
        self.addSubview(randowBtn)
        
        scrollView.contentSize = CGSize(width: 9 * 50, height: self.frame.size.height)
        for i in 0...8 {
            let title = UIButton(type: .Custom)
            title.frame = CGRectMake(CGFloat(i * 50), 0, 50, self.frame.size.height)
            title.setTitle("视频", forState: UIControlState.Normal)
            title.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            title.titleLabel?.font = UIFont.systemFontOfSize(15)
            scrollView.addSubview(title)
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
