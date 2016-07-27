//
//  ASPlusController.swift
//  BaiSiApp
//
//  Created by ashen on 16/3/29.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASPlusController: UIViewController {
    
    @IBOutlet weak var titleIMgv: UIImageView!
    @IBOutlet weak var cancel: UIButton!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        for view in self.view.subviews {
            
            switch view.tag {
            case 1001:
                view.transform = CGAffineTransformMakeTranslation(0, -1900)
            case 1002:
                view.transform = CGAffineTransformMakeTranslation(0, -1500)
            case 1003:
                view.transform = CGAffineTransformMakeTranslation(0, -1700)
            case 1004:
                view.transform = CGAffineTransformMakeTranslation(0, -1200)
            case 1005:
                view.transform = CGAffineTransformMakeTranslation(0, -500)
            case 1006:
                view.transform = CGAffineTransformMakeTranslation(0, -1000)
            case 1007:
                view.transform = CGAffineTransformMakeTranslation(0, 0)
            default:
                view.transform = CGAffineTransformMakeTranslation(0, -1700)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 1,
                                   initialSpringVelocity: 3,
                                   options: .CurveEaseInOut,
                                   animations: { () -> Void in
                                    for view in self.view.subviews {
                                        view.transform = CGAffineTransformIdentity
                                    }
        }) { (bool:Bool) -> Void in
            self.view.userInteractionEnabled = true
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
    
    @IBAction func cancel(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations: {
            for view in self.view.subviews {
                
                switch view.tag {
                case 1001:
                    view.transform = CGAffineTransformMakeTranslation(0, 900)
                case 1002:
                    view.transform = CGAffineTransformMakeTranslation(0, 500)
                case 1003:
                    view.transform = CGAffineTransformMakeTranslation(0, 700)
                case 1004:
                    view.transform = CGAffineTransformMakeTranslation(0, 200)
                case 1005:
                    view.transform = CGAffineTransformMakeTranslation(0, 500)
                case 1006:
                    view.transform = CGAffineTransformMakeTranslation(0, 400)
                case 1007:
                    view.transform = CGAffineTransformMakeTranslation(0, 100)
                default:
                    view.transform = CGAffineTransformMakeTranslation(0, 700)
                }
            }
        }) { (bool:Bool) in
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    
}
