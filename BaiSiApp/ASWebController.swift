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
import PKHUD
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class ASWebController: UIViewController,WKNavigationDelegate {

    var urlString:String! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        if urlString == "" {
            urlString = "http://www.devashen.com"
        }
        if urlString.contains("http://") || urlString.contains("https://"){
            self.navigationItem.title = "正在加载..."
            let wk = WKWebView(frame: self.view.frame)
            wk.navigationDelegate = self
            wk.load(URLRequest(url: URL(string: urlString)!))
            view.addSubview(wk)
            
        } else if urlString.contains("mod://") {
            let alert = UIAlertView(title: nil, message: "mod://,内部跳转机制，有待探索", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        if webView.title?.characters.count <= 0 {
            return
        }
        self.navigationItem.title = webView.title!
    }
}
