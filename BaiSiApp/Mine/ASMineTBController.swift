//
//  ASMineTBController.swift
//  BaiSiApp
//
//  Created by ashen on 16/8/23.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

import UIKit

class ASMineTBController: UITableViewController {

    var tagsModel:ASMineTagsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ASDataHelper.getMyLists({ (AnyObject) in
            self.tagsModel = AnyObject as! ASMineTagsModel
            self.tableView.reloadData()
            }, fails: {_ in })
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(iconAction), name: "NOTIICONACTION", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tagsModel == nil {
            return 3
        }
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("loginCell", forIndexPath: indexPath)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("downloadCell", forIndexPath: indexPath)
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("topicCell", forIndexPath: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("tagsCell", forIndexPath: indexPath) as! ASMineTagCell
            cell.makeUIByData(tagsModel)
            cell.selectionStyle = .None
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return indexPath.section == 3 ? CGFloat((tagsModel.square_list.count / 4) + (tagsModel.square_list.count % 4 != 0 ? 1 : 0)) * (self.view.frame.size.width / 4 + 20) : 44
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    //MARK: -Actions 
    func iconAction(noti:NSNotification) {
        let url = noti.object as! String
        let wk = ASWebController()
        wk.urlString = url
        self.navigationController?.pushViewController(wk, animated: true)
    }
}
