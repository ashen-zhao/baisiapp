//
//  ASTBController.swift
//  BaiSiApp
//
//  Created by ashen on 16/3/29.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit
import Kingfisher
import MJRefresh


class ASTBController: UITableViewController {
    
    var dataSource = NSMutableArray()
    var currentCell:ASMainCell!
    var menuURL:String!
    var lagePage = "0"
    var topImg = UIImageView()
    var topImgURL = "http://www.devashen.com"
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
    
    
    func archiver() {
        let cacheArr = NSMutableArray()
        for index in 0 ..< dataSource.count {
            let model = dataSource[index] as! ASListsModel
            let data = NSMutableData()
            let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
            archiver.encodeObject(model, forKey: menuURL.componentsSeparatedByString("/topic/").last! + "\(index)")
            archiver.finishEncoding()
            let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! + "/" + menuURL.componentsSeparatedByString("/topic/").last!.stringByReplacingOccurrencesOfString("/", withString: "") + "\(index)"
            print(path)
            data.writeToFile(path, atomically: true)
            cacheArr.addObject(path)
        }
        NSUserDefaults.standardUserDefaults().setObject(cacheArr, forKey: menuURL.componentsSeparatedByString("/topic/").last!)
        

    }
    
    func getArchiver() {
        
        if NSUserDefaults.standardUserDefaults().objectForKey(menuURL.componentsSeparatedByString("/topic/").last!) == nil {
            return
        }
        
        let cacheArr = NSUserDefaults.standardUserDefaults().objectForKey(menuURL.componentsSeparatedByString("/topic/").last!) as! NSMutableArray
        for index in 0..<cacheArr.count {
            let path = cacheArr[index] as! String
            let data = NSMutableData.init(contentsOfFile: path)
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)
            let model = unarchiver.decodeObjectForKey(menuURL.componentsSeparatedByString("/topic/").last! + "\(index)") as! ASListsModel
            print(model.u.name)
            unarchiver.finishDecoding()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .None
        topImg.userInteractionEnabled = true
        topImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoWeb)))
        
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(ASTBController.headerRefresh))
        self.tableView.mj_header = header
        self.tableView.mj_header.beginRefreshing()
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(ASTBController.footerRefresh))
        
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
        topImg.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height:60)
        return topImg
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ASMainCell.getCellHeight(dataSource[indexPath.row] as! ASListsModel);
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
   
    }
    
    
    // MARK: - Actions 
    func gotoWeb() {
        let wk = ASWebController()
        wk.urlString = topImgURL
        self.navigationController?.pushViewController(wk, animated: true)
    }
    
    
    // MARK: - Refresh
    func headerRefresh() {
        ASDataHelper.getTopImages({ (AnyObject) in
            let topAry = (AnyObject as! NSMutableArray);
            if topAry.count > 0 {
                let model = topAry.firstObject as! ASTopImagesModel
                self.topImgURL = model.url
                self.topImg.kf_setImageWithURL(NSURL(string:model.image)!, placeholderImage:UIImage(named: "top_defauth.jpg"))
            } else {
                self.topImg.image = UIImage(named: "top_defauth.jpg")
            }
            }, fails: {
                
        })

        
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
