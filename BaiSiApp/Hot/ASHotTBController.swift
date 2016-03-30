//
//  ASHotTBController.swift
//  BaiSiApp
//
//  Created by ashen on 16/3/29.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
import Kingfisher

class ASHotTBController: UITableViewController {

    // MARK: - life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let navView = ASCustomNav.init(frame: (navigationController?.navigationBar.frame)!)
        navigationItem.titleView = navView
        self.tableView.separatorStyle = .None
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("hotCell", forIndexPath: indexPath) as! ASHotCell
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let topImg = UIImageView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height:60))
        topImg.kf_setImageWithURL(NSURL(string: "http://img.spriteapp.cn/ugc/2016/03/24/145600_1879.jpg")!, placeholderImage:UIImage(named: "top_defauth.jpg"))
        return topImg
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
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
