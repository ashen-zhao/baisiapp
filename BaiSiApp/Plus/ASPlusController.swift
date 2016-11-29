//
//  ASPlusController.swift
//  BaiSiApp
//
//  Created by ashen on 16/3/29.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
import PKHUD
class ASPlusController: UIViewController {
    
    @IBOutlet weak var titleIMgv: UIImageView!
    @IBOutlet weak var cancel: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for view in self.view.subviews {
            view.transform = CGAffineTransform(translationX: 0, y: -600)
        }
        cancel.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for view in self.view.subviews {
            var delay:Double = 0.0
            switch view.tag {
            case 1001:
                delay = 0.25
            case 1002:
                delay = 0.15
            case 1003:
                delay = 0.2
            case 1004:
                delay = 0.1
            case 1005:
                delay = 0.0
            case 1006:
                delay = 0.05
            case 1007:
                delay = 0.0
            default:
                delay = 0.3
            }
            
            UIView.animate(withDuration: 0.6,
                                       delay: delay,
                                       usingSpringWithDamping: 0.82,
                                       initialSpringVelocity: 0,
                                       options: .curveEaseOut,
                                       animations: { () -> Void in
                                        view.transform = CGAffineTransform.identity
            }) { (bool:Bool) -> Void in
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancel.layer.borderColor = UIColor.lightGray.cgColor
        cancel.layer.borderWidth = 0.6
        cancel.layer.cornerRadius = 2
        cancel.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: -Actions
    @IBAction func publishActions(_ sender: AnyObject) {
        switch sender.tag {
        case 1001:
            HUD.show(HUDContentType.label("发视频"))
        case 1002:
            HUD.show(HUDContentType.label("发图片"))
        case 1003:
            HUD.show(HUDContentType.label("发段子"))
        case 1004:
            HUD.show(HUDContentType.label("发声音"))
        case 1005:
            HUD.show(HUDContentType.label("审核"))
        case 1006:
            HUD.show(HUDContentType.label("发连接"))
        default:break
            
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            HUD.hide()
        }
    }
    @IBAction func cancel(_ sender: AnyObject) {
        for view in self.view.subviews {
            var delay:Double = 0.0
            switch view.tag {
            case 1001:
                delay = 0.25
            case 1002:
                delay = 0.15
            case 1003:
                delay = 0.2
            case 1004:
                delay = 0.1
            case 1005:
                delay = 0.02
            case 1006:
                delay = 0.05
            case 1007:
                delay = 0.0
            default:
                delay = 0.3
            }
            UIView.animate(withDuration: 0.5,
                                       delay: delay,
                                       usingSpringWithDamping: 1,
                                       initialSpringVelocity: 0,
                                       options: .curveEaseOut,
                                       animations: { () -> Void in
                                        view.transform = CGAffineTransform(translationX: 0, y: 500)
                                        
            }) { (bool:Bool) in
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    
}
