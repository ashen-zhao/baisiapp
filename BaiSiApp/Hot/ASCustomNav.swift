//
//  ASCustomNav.swift
//  BaiSiApp
//
//  Created by ashen on 16/3/29.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit


public protocol ASCustomNavDelegate: NSObjectProtocol {
    func getTitlesCount(_ menuURLS:NSMutableArray, count:NSInteger)
    func titleAction(_ index:NSInteger)
}


class ASCustomNav: UIView, UIScrollViewDelegate {
    
    fileprivate var scrollView:UIScrollView!
    fileprivate var leftImg:UIImageView!
    fileprivate var rightImg:UIImageView!
    fileprivate var randowBtn:UIButton!
    fileprivate var lineView:UIView!
    fileprivate var lastBtn:UIButton?
    fileprivate var tempArr:NSMutableArray!
    fileprivate var urlsArr:NSMutableArray!
    fileprivate var mType = "精华"
    
    weak var delegate:ASCustomNavDelegate?
    
    init(frame: CGRect ,menuType:String, delegate:ASCustomNavDelegate) {
        super.init(frame: frame)
        self.delegate = delegate
        mType = menuType
        ASDataHelper.getMenusType(menuType, successs: { (AnyObject) in
            let array = AnyObject as! NSMutableArray
            self.tempArr = NSMutableArray()
            self.urlsArr = NSMutableArray()
            for model in array {
                self.tempArr.add((model as! ASMenusModel).name)
                self.urlsArr.add((model as! ASMenusModel).url)
            }
            self.makeUI(self.tempArr)
            self.delegate?.getTitlesCount(self.urlsArr, count: array.count)

            }, fails: {_ in})
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    func makeUI(_ titles:NSMutableArray) {
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        scrollView = UIScrollView(frame: CGRect.init(x: 0, y: 0, width:self.frame.size.width - 35, height: self.frame.size.height))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        self.addSubview(scrollView)
        
        leftImg = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 10, height: scrollView.frame.size.height))
        leftImg.image = UIImage(named: "left_bg")
        leftImg.isHidden = true
        self.addSubview(leftImg)
        
        rightImg = UIImageView(frame: CGRect.init(x: scrollView.frame.maxX - 10, y: 0, width: 10, height: scrollView.frame.size.height))
        rightImg.image = UIImage(named: "right_bg")
        self.addSubview(rightImg)
        
        randowBtn = UIButton(type: .custom)
        randowBtn.frame = CGRect(x: scrollView.frame.maxX, y: 0, width: 40, height: self.frame.size.height)
        let imgName = mType == "精华" ? "RandomAcross" : "MainTagSubIcon"
        randowBtn.setImage(UIImage(named: imgName), for: UIControlState())
        self.addSubview(randowBtn)
        
        scrollView.contentSize = CGSize(width: CGFloat(titles.count * 50), height: self.frame.size.height)
        for i in 0..<titles.count {
            let title = UIButton(type: .custom)
            title.frame = CGRect(x: CGFloat(i * 50), y: 0, width: 50, height: self.frame.size.height)
            title.setTitle(titles[i] as? String, for: UIControlState())
            title.tag = i;
            if i == 0 {
                lastBtn = title
                title.setTitleColor(UIColor.red, for: UIControlState())
                title.titleLabel?.font = UIFont.systemFont(ofSize: 15.5)
            } else {
                title.setTitleColor(UIColor.lightGray, for: UIControlState())
                title.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            }
            title.addTarget(self, action: #selector(ASCustomNav.titlesChangeAction(_:)), for: .touchUpInside)
            scrollView.addSubview(title)
        }
        
        lineView = UIView(frame: CGRect(x: 9, y: scrollView.frame.maxY - 3, width: 30, height: 2))
        lineView.backgroundColor = UIColor.red
        scrollView.addSubview(lineView)
    }
    
    
    // MARK: - delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        leftImg.isHidden = scrollView.contentOffset.x <= 0 ? true : false
    }
    
    // MARK: - actons
    func titlesChangeAction(_ btn:UIButton) {
        
        if lastBtn?.tag == btn.tag {
            return
        }
        
        lastBtn?.setTitleColor(UIColor.lightGray, for: UIControlState())
        lastBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        btn.setTitleColor(UIColor.red, for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.5)
        
        lastBtn = btn
        
        moveTitlesLine(btn.tag)
    }
    
    func moveTitlesLine(_ index:NSInteger) {
    
        var frame = lineView.frame
        frame.origin.x = CGFloat(index * 50) + 9
        
        var dict:[Int:CGFloat] = [0:0.0, 1:0.0, 2:0.0, 3:50.0, 4:100.0, 5:150.0, 6:160.0, 7:180.0, 8:180.0]
        
        delegate?.titleAction(index)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.contentOffset.x = dict[index]!
            self.lineView.frame = frame
        }) 
        leftImg.isHidden = scrollView.contentOffset.x <= 0 ? true : false
        
        let btn = scrollView.subviews[index] as! UIButton
        
        lastBtn?.setTitleColor(UIColor.lightGray, for: UIControlState())
        lastBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        btn.setTitleColor(UIColor.red, for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.5)
        
        lastBtn = btn
    }
    
}
