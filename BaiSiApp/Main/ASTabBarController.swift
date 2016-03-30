//
//  ASTabBarController.swift
//  BaiSiApp
//
//  Created by ashen on 16/3/28.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASTabBarController: UITabBarController, UITabBarControllerDelegate {

    //MARK: - life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //调整tabbar中间特殊的item
        let v:UIViewController = self.viewControllers![2]
        v.tabBarItem.image = UIImage(named: "tabBar_publish_icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        v.tabBarItem.selectedImage = UIImage(named: "tabBar_publish_click_icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        v.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.grayColor()
        delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - UITabBarControllerDelegate
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers![2] {
            
            let vc = UIStoryboard(name: "Plus", bundle: nil).instantiateViewControllerWithIdentifier("Plus") as! ASPlusController
            
             UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(vc, animated: false, completion: nil)
            
            return false
        }
        return true
    }
}
