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
    var currentCell:ASMainCell!
    var menuURL:String!
    var lagePage = "0"
    
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    
    
    
    // MARK: - life Cycle
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if currentCell == nil {
            return
        }
        currentCell.video_View.player.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .None
        
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(ASMainTBController.headerRefresh))
        self.tableView.mj_header = header
        self.tableView.mj_header.beginRefreshing()
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(ASMainTBController.footerRefresh))
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
        let cell = tableView.dequeueReusableCellWithIdentifier("mainCell") as! ASMainCell
        cell.setupData(dataSource[indexPath.row] as! ASListsModel)
        
        cell.blc_currentCell = {(currentCell)->() in
            if self.currentCell != nil {
                self.currentCell.video_View.player.stop()
            }
            self.currentCell = currentCell
        }
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
        return ASMainCell.getCellHeight(dataSource[indexPath.row] as! ASListsModel);
    }
    
    
    // MARK: - Refresh 
    func headerRefresh() {
        ASDataHelper.getListsWithMenuURL((menuURL), lagePage: lagePage, success: { (AnyObject) in
            let dataArr = AnyObject as! NSMutableArray
            for listModel in dataArr {
                self.dataSource.addObject(listModel as! ASListsModel)
            }
            self.tableView.reloadData()
            self.tableView.mj_footer = self.footer
            
            }) { (AnyObject) in
                self.lagePage = "\(AnyObject)"
        }
        self.tableView.mj_header.endRefreshing()
    }
    
    func footerRefresh() {
        ASDataHelper.getListsWithMenuURL((menuURL), lagePage: lagePage, success: { (AnyObject) in
            let dataArr = AnyObject as! NSMutableArray
            for listModel in dataArr {
                self.dataSource.addObject(listModel as! ASListsModel)
            }
            self.tableView.reloadData()
        }) { (AnyObject) in
            self.lagePage = "\(AnyObject)"
        }

        self.tableView.mj_footer.endRefreshing()
    }
}
