//
//  ASNavigationController.swift
//  BaiSiApp
//
//  Created by ashen on 16/3/28.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = self.viewControllers.count >= 1
        super.pushViewController(viewController, animated: true)
    }

}
