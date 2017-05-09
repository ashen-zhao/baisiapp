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
    fileprivate var navView:ASCustomNav?
    fileprivate var currentMainTBV:ASTBController!
    fileprivate var topImg = UIImageView()
    fileprivate var topImgUrl = "http://www.devashen.com"
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navView = ASCustomNav.init(frame: (navigationController?.navigationBar.frame)!,menuType: contentScroll.tag == 0 ? "精华" : "最新", delegate: self)
        navigationItem.titleView = navView
        automaticallyAdjustsScrollViewInsets = false
        self.sayHi()
    }
    
    
    dynamic func sayHi() {
        print("Hi")
    }
    
    dynamic func printMe(_ a:String, b rb:String) {
        print(a + rb)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ASCustomNavDelegate

    dynamic func getTitlesCount(_ menuURLS: NSMutableArray, count: NSInteger) {
        
        for vc in self.childViewControllers {
            vc.removeFromParentViewController()
        }
        for i in 0 ..< count {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbTBView") as! ASTBController
            vc.menuURL = menuURLS[i] as! String
            self.addChildViewController(vc)
        }
        self.contentScroll.delegate = self
        self.contentScroll.contentSize = CGSize(width: CGFloat(count) * self.contentScroll.frame.width, height: self.contentScroll.frame.height)
        self.scrollViewDidEndScrollingAnimation(self.contentScroll)
        
    }
    
    dynamic func titleAction(_ index: NSInteger) {
        UIView.animate(withDuration: 0.3, animations: { 
            self.contentScroll.setContentOffset(CGPoint(x: CGFloat(index) * self.view.frame.size.width, y: 0), animated: true)
        }) 
    }
    
    // MARK: UIScrollViewDelegate

   dynamic func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / view.frame.size.width)
        let controller = childViewControllers[currentPage] as! ASTBController
        controller.view.frame = view.frame
        controller.view.frame.origin.x = scrollView.contentOffset.x
        contentScroll.addSubview(controller.view)
        if currentMainTBV != nil && currentMainTBV!.currentCell != nil && !controller.isEqual(currentMainTBV) {
            currentMainTBV!.currentCell.video_View.player.pause()
        }
        if let _ = currentMainTBV {
            NotificationCenter.default.removeObserver(currentMainTBV)
        }
        currentMainTBV = controller
        NotificationCenter.default.addObserver(controller, selector: #selector(controller.autoScrollTop), name: NSNotification.Name(rawValue: "ScrollTop"), object: nil)
        navView?.moveTitlesLine(currentPage)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
}
