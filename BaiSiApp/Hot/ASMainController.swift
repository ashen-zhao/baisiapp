//
//  ASMainController.swift
//  BaiSiApp
//
//  Created by ashen on 16/4/18.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASMainController: UIViewController, ASCustomNavDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var contentScroll: UIScrollView!
    private var navView:ASCustomNav!
    private var currentMainTBV:ASTBController!
    private var topImg = UIImageView()
    private var topImgUrl = "http://www.devashen.com"
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navView = ASCustomNav.init(frame: (navigationController?.navigationBar.frame)!,menuType: contentScroll.tag == 0 ? "精华" : "最新")
        navView.delegate = self
        navigationItem.titleView = navView
        automaticallyAdjustsScrollViewInsets = false
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ASCustomNavDelegate

    func getTitlesCount(menuURLS: NSMutableArray, count: NSInteger) {
        
        ASDataHelper.getTopImages { (AnyObject) in
            let topAry = (AnyObject as! NSMutableArray);
            var imgrsrc = ""
            if topAry.count > 0 {
                let model = topAry.firstObject as! ASTopImagesModel
                self.topImgUrl = model.url
                imgrsrc = model.image
                self.topImg.kf_setImageWithURL(NSURL(string:model.image)!, placeholderImage:UIImage(named: "top_defauth.jpg"))
                
            } else {
                self.topImg.image = UIImage(named: "top_defauth.jpg")
            }
            for i in 0 ..< count {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("sbTBView") as! ASTBController
                vc.menuURL = menuURLS[i] as! String
                if i == 0 {
                    vc.topImg.kf_setImageWithURL(NSURL(string:imgrsrc)!, placeholderImage:UIImage(named: "top_defauth.jpg"))
                }
                vc.topImgURL = self.topImgUrl
                self.addChildViewController(vc)
            }
            self.contentScroll.delegate = self
            self.contentScroll.contentSize = CGSizeMake(CGFloat(count) * self.contentScroll.frame.width, self.contentScroll.frame.height)
            self.scrollViewDidEndScrollingAnimation(self.contentScroll)
        }
    }
    
    func titleAction(index: NSInteger) {
        
        UIView.animateWithDuration(0.3) { 
            self.contentScroll.setContentOffset(CGPoint(x: CGFloat(index) * self.view.frame.size.width, y: 0), animated: true)
        }
    }
    
    // MARK: UIScrollViewDelegate

    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / view.frame.size.width)
        let controller = childViewControllers[currentPage] as! ASTBController
        controller.view.frame = view.frame
        controller.view.frame.origin.x = scrollView.contentOffset.x
        if currentPage != 0 {
            controller.topImg.image = self.topImg.image
        }
        contentScroll.addSubview(controller.view)
        
        if currentMainTBV != nil && currentMainTBV!.currentCell != nil && !controller.isEqual(currentMainTBV) {
            currentMainTBV!.currentCell.video_View.player.pause()
        }
        currentMainTBV = controller
        navView.moveTitlesLine(currentPage)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
}
