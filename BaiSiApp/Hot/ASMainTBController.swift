//
//  ASMainTBController.swift
//  BaiSiApp
//
//  Created by ashen on 16/3/29.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
import Kingfisher
import MJRefresh

class ASMainTBController: UITableViewController {

    private var dataSource = NSMutableArray()
    var menuURL:String!
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .None
        ASDataHelper.getListsWithMenuURL(menuURL) { (AnyObject) in
            let dataArr = AnyObject as! NSMutableArray
            for listModel in dataArr {
                self.dataSource.addObject(listModel as! ASListsModel)
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
        return dataSource.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let iden = "mainCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(iden) as? ASMainCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("ASMainCell", owner: nil, options: nil)[0] as? ASMainCell
        } else {
            while cell?.contentView.subviews.last != nil {
                cell?.contentView.subviews.last?.removeFromSuperview()
            }
        }
        cell!.setupData(dataSource[indexPath.row] as! ASListsModel)
        return cell!
        
//        let cell = tableView.dequeueReusableCellWithIdentifier("mainCell") as! ASMainCell
//        cell.setupData(dataSource[indexPath.row] as! ASListsModel)
//        return cell
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
        return ASMainCell.getCellHeight(dataSource[indexPath.row] as! ASListsModel);
    }
}
