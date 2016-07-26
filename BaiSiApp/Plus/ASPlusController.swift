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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancel.layer.borderColor = UIColor.lightGrayColor().CGColor
        cancel.layer.borderWidth = 0.5
        cancel.layer.cornerRadius = 2
        cancel.layer.masksToBounds = true
        
        var i = 1
        for view in self.view.subviews {
            view.transform = CGAffineTransformMakeTranslation(0, -100 - CGFloat(i) * 50)
            i += 1
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 0.9,
                                   initialSpringVelocity: 5,
                                   options: .CurveEaseInOut,
                                   animations: { () -> Void in
                                    for view in self.view.subviews {
                                        view.transform = CGAffineTransformIdentity
                                    }
        }) { (bool:Bool) -> Void in
            self.view.userInteractionEnabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations: {
            var i = 1
            for view in self.view.subviews {
                view.transform = CGAffineTransformMakeTranslation(0, 50 + CGFloat(i) * 100)
                i += 1
            }
        }) { (bool:Bool) in
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    
}
