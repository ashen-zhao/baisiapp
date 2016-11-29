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
        btnRegister.layer.borderColor = UIColor.red.cgColor
        btnRegister.layer.borderWidth = 0.6
        btnRegister.layer.cornerRadius = 3
        btnRegister.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func adds(_ sender: AnyObject) {
        HUD.show(HUDContentType.label("去关注"))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            HUD.hide()
        }
    }
    
    @IBAction func loginAction(_ sender: AnyObject) {
        HUD.show(HUDContentType.label("去登录"))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            HUD.hide()
        }
    }
    
    @IBAction func registerAction(_ sender: AnyObject) {
        HUD.show(HUDContentType.label("去注册"))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            HUD.hide()
        }
    }
}
