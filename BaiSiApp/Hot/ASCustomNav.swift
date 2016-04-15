//
//  ASCustomNav.swift
//  BaiSiApp
//
//  Created by ashen on 16/3/29.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASCustomNav: UIView, UIScrollViewDelegate {
    
    
    var scrollView:UIScrollView!
    var leftImg:UIImageView!
    var rightImg:UIImageView!
    var randowBtn:UIButton!
    var lineView:UIView!
    var lastBtn:UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        ASDataHelper.getMenusType("精华") { (AnyObject) in
            let array = AnyObject as! NSMutableArray
            let tempArr = NSMutableArray()
            for model in array {
                tempArr.addObject((model as! ASMenusModel).name)
            }
            self.makeUI(tempArr)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    func makeUI(titles:NSMutableArray) {
        
        scrollView = UIScrollView(frame: CGRect.init(x: 0, y: 0, width:self.frame.size.width - 35, height: self.frame.size.height))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        self.addSubview(scrollView)
        
        leftImg = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 10, height: scrollView.frame.size.height))
        leftImg.image = UIImage(named: "left_bg")
        leftImg.hidden = true
        self.addSubview(leftImg)
        
        rightImg = UIImageView(frame: CGRect.init(x: CGRectGetMaxX(scrollView.frame) - 10, y: 0, width: 10, height: scrollView.frame.size.height))
        rightImg.image = UIImage(named: "right_bg")
        self.addSubview(rightImg)
        
        randowBtn = UIButton(type: .Custom)
        randowBtn.frame = CGRectMake(CGRectGetMaxX(scrollView.frame), 0, 40, self.frame.size.height)
        randowBtn.setImage(UIImage(named: "RandomAcross"), forState: .Normal)
        self.addSubview(randowBtn)
        
        scrollView.contentSize = CGSize(width: CGFloat(titles.count * 50), height: self.frame.size.height)
        for i in 0..<titles.count {
            let title = UIButton(type: .Custom)
            title.frame = CGRectMake(CGFloat(i * 50), 0, 50, self.frame.size.height)
            title.setTitle(titles[i] as? String, forState: UIControlState.Normal)
            title.tag = i;
            if i == 0 {
                lastBtn = title
                title.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                title.titleLabel?.font = UIFont.systemFontOfSize(15.5)
            } else {
                title.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
                title.titleLabel?.font = UIFont.systemFontOfSize(15)
            }
            title.addTarget(self, action: #selector(ASCustomNav.titlesChangeAction(_:)), forControlEvents: .TouchUpInside)
            scrollView.addSubview(title)
        }
        
        lineView = UIView(frame: CGRectMake(9, CGRectGetMaxY(scrollView.frame) - 3, 30, 2))
        lineView.backgroundColor = UIColor.redColor()
        scrollView.addSubview(lineView)
    }
    
    
    // MARK: - delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        leftImg.hidden = scrollView.contentOffset.x <= 0 ? true : false
    }
    
    // MARK: - actons
    func titlesChangeAction(btn:UIButton) {
        
        
        if lastBtn?.tag == btn.tag {
            return
        }
        
        lastBtn?.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        lastBtn?.titleLabel?.font = UIFont.systemFontOfSize(15)
        
        btn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(15.5)
        
        lastBtn = btn
        
        var frame = lineView.frame
        frame.origin.x = CGFloat(btn.tag * 50) + 9
       
        var dict:[Int:CGFloat] = [0:0.0, 1:0.0, 2:0.0, 3:50.0, 4:100.0, 5:150.0, 6:160.0, 7:180.0, 8:180.0]
        
        UIView.animateWithDuration(0.3) {
            self.scrollView.contentOffset.x = dict[btn.tag]!
            self.lineView.frame = frame
        }
        leftImg.hidden = scrollView.contentOffset.x <= 0 ? true : false
    }
}
