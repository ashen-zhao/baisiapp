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

    var dataSource = NSMutableArray()
    
    // MARK: - life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let navView = ASCustomNav.init(frame: (navigationController?.navigationBar.frame)!)
        navigationItem.titleView = navView
        self.tableView.separatorStyle = .None
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ASDataHelper.getAllLists { (AnyObject) in
            let dataArr = AnyObject as! NSMutableArray
            for listModel in dataArr {
                self.dataSource.addObject(listModel)
            }
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("hotCell", forIndexPath: indexPath) as! ASHotCell
        cell.setupData(dataSource[indexPath.row] as! ASListsModel)
        return cell
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let topImg = UIImageView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height:60))
        ASDataHelper.getTopImages { (AnyObject) in
            let model = (AnyObject as! NSMutableArray)[0] as! ASTopImagesModel
            topImg.kf_setImageWithURL(NSURL(string:model.image)!, placeholderImage:UIImage(named: "top_defauth.jpg"))
        }
        
        return topImg
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300;
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
