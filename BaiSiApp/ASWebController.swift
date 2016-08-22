//
//  ASWebController.swift
//  BaiSiApp
//
//  Created by ashen on 16/8/19.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
import WebKit
import FDFullscreenPopGesture

class ASWebController: UIViewController,WKNavigationDelegate {

    var urlString:String! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "正在加载..."
        let wk = WKWebView(frame: self.view.frame)
        wk.navigationDelegate = self
        wk.loadRequest(NSURLRequest(URL: NSURL(string: urlString)!))
        view.addSubview(wk)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        if webView.title?.characters.count <= 0 {
            return
        }
        self.navigationItem.title = webView.title!
    }
}
