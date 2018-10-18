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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //调整tabbar中间特殊的item
        let v:UIViewController = self.viewControllers![2]
        v.tabBarItem.image = UIImage(named: "tabBar_publish_icon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        v.tabBarItem.selectedImage = UIImage(named: "tabBar_publish_click_icon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        v.tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.gray
        delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers![2] {
            
            let vc = UIStoryboard(name: "Plus", bundle: nil).instantiateViewController(withIdentifier: "Plus") as! ASPlusController
            
             UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: false, completion: nil)
            
            return false
        }
        return true
    }
}
