//
//  ASWebController.swift
//  BaiSiApp
//
//  Created by ashen on 16/8/19.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
import WebKit

class ASWebController: UIViewController,WKNavigationDelegate {

    var urlString:String! = nil
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
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
        self.navigationItem.title = webView.title
    }
}
