//
//  ASImgBrowserController.swift
//  BaiSiApp
//
//  Created by ashen on 16/7/1.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASImgBrowserController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var listModel:ASListsModel!
    var image:UIImage!
    var imgV = UIImageView()
    var isGIF:Bool!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName: "ASImgBrowserController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imgV)
        imgV.userInteractionEnabled = true
        imgV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(disMissBrowserAction)))
        
        let w = ASMainWidth
        var h:CGFloat
        if (isGIF == true) {
            h = ASMainWidth * CGFloat(listModel.gif.height) / CGFloat(listModel.gif.width)
        } else {
            h = ASMainWidth * CGFloat(listModel.image.height) / CGFloat(listModel.image.width)
        }
        imgV.frame = CGRectMake(0, 0, w, h)
        if h < ASMainHeight {
            imgV.center = CGPointMake(imgV.center.x, ASMainHeight * 0.5)
        }
        imgV.image = image
        scrollView.contentSize = imgV.frame.size
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func disMissBrowserAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveImgAction(sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(imgV.image!, self, #selector(saveimage), nil)
    }
    
    func saveimage(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        
        if didFinishSavingWithError != nil {
            print("Fail")
        }else {
            print("OK")
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
