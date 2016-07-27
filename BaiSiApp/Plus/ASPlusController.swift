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
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        for view in self.view.subviews {
            view.transform = CGAffineTransformMakeTranslation(0, -600)
        }
        cancel.transform = CGAffineTransformMakeTranslation(0, 0)
    }
    
    override func viewDidAppear(animated: Bool) {
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
            
            UIView.animateWithDuration(0.6,
                                       delay: delay,
                                       usingSpringWithDamping: 0.82,
                                       initialSpringVelocity: 0,
                                       options: .CurveEaseOut,
                                       animations: { () -> Void in
                                        view.transform = CGAffineTransformIdentity
            }) { (bool:Bool) -> Void in
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancel.layer.borderColor = UIColor.lightGrayColor().CGColor
        cancel.layer.borderWidth = 0.6
        cancel.layer.cornerRadius = 2
        cancel.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: -Actions
    @IBAction func publishActions(sender: AnyObject) {
        switch sender.tag {
        case 1001:
            HUD.show(HUDContentType.Label("发视频"))
        case 1002:
            HUD.show(HUDContentType.Label("发图片"))
        case 1003:
            HUD.show(HUDContentType.Label("发段子"))
        case 1004:
            HUD.show(HUDContentType.Label("发声音"))
        case 1005:
            HUD.show(HUDContentType.Label("审核"))
        case 1006:
            HUD.show(HUDContentType.Label("发连接"))
        default:break
            
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            HUD.hide()
        }
    }
    @IBAction func cancel(sender: AnyObject) {
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
            UIView.animateWithDuration(0.5,
                                       delay: delay,
                                       usingSpringWithDamping: 1,
                                       initialSpringVelocity: 0,
                                       options: .CurveEaseOut,
                                       animations: { () -> Void in
                                        view.transform = CGAffineTransformMakeTranslation(0, 500)
                                        
            }) { (bool:Bool) in
                self.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }
    
    
}
