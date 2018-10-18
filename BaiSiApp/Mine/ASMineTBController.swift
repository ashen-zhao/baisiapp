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
            self.tagsModel = (AnyObject as! ASMineTagsModel)
            self.tableView.reloadData()
            }, fails: {_ in })
        
        NotificationCenter.default.addObserver(self, selector: #selector(iconAction), name: NSNotification.Name(rawValue: "NOTIICONACTION"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if tagsModel == nil {
            return 3
        }
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loginCell", for: indexPath)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "downloadCell", for: indexPath)
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tagsCell", for: indexPath) as! ASMineTagCell
            cell.makeUIByData(tagsModel)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.section == 3 ? CGFloat((tagsModel.square_list.count / 4) + (tagsModel.square_list.count % 4 != 0 ? 1 : 0)) * (self.view.frame.size.width / 4 + 20) : 44
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    //MARK: -Actions 
    @objc func iconAction(_ noti:Notification) {
        let url = noti.object as! String
        let wk = ASWebController()
        wk.urlString = url
        self.navigationController?.pushViewController(wk, animated: true)
    }
}
