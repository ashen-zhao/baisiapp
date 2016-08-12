//
//  ASLoginController.swift
//  BaiSiApp
//
//  Created by ashen on 16/8/11.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
import PKHUD
class ASLoginController: UIViewController {

    @IBOutlet weak var btnLogIn: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogIn.layer.cornerRadius = 3
        btnLogIn.layer.masksToBounds = true
        btnRegister.layer.borderColor = UIColor.redColor().CGColor
        btnRegister.layer.borderWidth = 0.6
        btnRegister.layer.cornerRadius = 3
        btnRegister.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func adds(sender: AnyObject) {
        HUD.show(HUDContentType.Label("去关注"))
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            HUD.hide()
        }
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        HUD.show(HUDContentType.Label("去登录"))
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            HUD.hide()
        }
    }
    
    @IBAction func registerAction(sender: AnyObject) {
        HUD.show(HUDContentType.Label("去注册"))
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            HUD.hide()
        }
    }
}
