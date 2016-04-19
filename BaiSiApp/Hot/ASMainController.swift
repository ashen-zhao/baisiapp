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
    var navView:ASCustomNav!
    
    // MARK: - life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navView = ASCustomNav.init(frame: (navigationController?.navigationBar.frame)!)
        navView.delegate = self
        navigationItem.titleView = navView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ASCustomNavDelegate
    func getTitlesCount(count: NSInteger) {
        for _ in 0 ..< count {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("sbTBView") as! ASHotTBController
            addChildViewController(vc)
        }
        contentScroll.delegate = self
        contentScroll.contentSize = CGSizeMake(CGFloat(count) * contentScroll.frame.width, contentScroll.frame.height)
        scrollViewDidEndScrollingAnimation(contentScroll)
    }
    
    func titleAction(index: NSInteger) {
        
        UIView.animateWithDuration(0.3) { 
            self.contentScroll.setContentOffset(CGPoint(x: CGFloat(index) * self.view.frame.size.width, y: 0), animated: true)
        }
    }
    
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / view.frame.size.width)
        let controller = childViewControllers[currentPage] as! ASHotTBController
        controller.view.frame = view.frame
        controller.view.frame.origin.x = scrollView.contentOffset.x
        contentScroll.addSubview(controller.view)
        
        navView.moveTitlesLine(currentPage)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
}
