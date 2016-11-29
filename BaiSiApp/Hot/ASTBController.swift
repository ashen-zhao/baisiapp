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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if currentCell == nil {
            return
        }
        currentCell.video_View.player.pause()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        topImg.isUserInteractionEnabled = true
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as! ASMainCell
        cell.setupData(dataSource[indexPath.row] as! ASListsModel)
        
        cell.blc_currentCell = {(currentCell)->() in
            if self.currentCell != nil {
                self.currentCell.video_View.player.stop()
            }
            self.currentCell = currentCell
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        topImg.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height:60)
        return topImg
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ASMainCell.getCellHeight(dataSource[indexPath.row] as! ASListsModel);
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
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
                self.topImg.kf.setImage(with: ImageResource.init(downloadURL:URL(string:model.image)!))
            } else {
                self.topImg.image = UIImage(named: "top_defauth.jpg")
            }
            }, fails: {_ in})
        
        ASDataHelper.getListsWithMenuURL((menuURL), lagePage: "0", success: { (AnyObject) in
            let dataArr = AnyObject as! NSMutableArray
            self.dataSource.removeAllObjects()
            for listModel in dataArr {
                self.dataSource.add(listModel as! ASListsModel)
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
                self.dataSource.add(listModel as! ASListsModel)
            }
            self.tableView.reloadData()
        }) { (AnyObject) in
            self.lagePage = "\(AnyObject)"
        }
        
        self.tableView.mj_footer.endRefreshing()
    }
    
    func autoScrollTop() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.tableView.contentOffset.y = 0
        }) 
    }
    
    //MARK: - 暂时不采用的Method
    
    func archiver() {
        let cacheArr = NSMutableArray()
        for index in 0 ..< dataSource.count {
            let model = dataSource[index] as! ASListsModel
            let data = NSMutableData()
            let archiver = NSKeyedArchiver(forWritingWith: data)
            archiver.encode(model, forKey: menuURL.components(separatedBy: "/topic/").last! + "\(index)")
            archiver.finishEncoding()
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! + "/" + menuURL.components(separatedBy: "/topic/").last!.replacingOccurrences(of: "/", with: "") + "\(index)"
            print(path)
            data.write(toFile: path, atomically: true)
            cacheArr.add(path)
        }
        UserDefaults.standard.set(cacheArr, forKey: menuURL.components(separatedBy: "/topic/").last!)
        
    }
    
    func getArchiver() {
        
        if UserDefaults.standard.object(forKey: menuURL.components(separatedBy: "/topic/").last!) == nil {
            return
        }
        
        let cacheArr = UserDefaults.standard.object(forKey: menuURL.components(separatedBy: "/topic/").last!) as! NSMutableArray
        for index in 0..<cacheArr.count {
            let path = cacheArr[index] as! String
            let data = NSMutableData.init(contentsOfFile: path)
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data! as Data)
            let model = unarchiver.decodeObject(forKey: menuURL.components(separatedBy: "/topic/").last! + "\(index)") as! ASListsModel
            print(model.u.name)
            unarchiver.finishDecoding()
        }
    }

}
