//
//  SecondBackNumberTableViewController.swift
//  housoushitsu
//
//  Created by naoyashiga on 2015/06/19.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

class SecondBackNumberTableViewController: BaseTableViewController {
    private let reuseIdentifier = "BackNumberTableViewCell"
    var kikakuList = [String]()
    var queries = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNib(reuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        animateTable(customCell: BackNumberTableViewCell())
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kikakuList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BackNumberTableViewCell
        
        if indexPath.row < queries.count {
            
            if queries[indexPath.row] == "準備中" {
                cell.backNumberLabel.textColor = UIColor.kikakuTitleInPreparationColor()
                cell.backNumberLabel.text = "[準備中]" + kikakuList[indexPath.row]
            } else {
                cell.backNumberLabel.textColor = UIColor.kikakuTitleColor()
                cell.backNumberLabel.text = kikakuList[indexPath.row]
            }
            
        } else {
            println("indexPath.row index error")
        }
        
        
        cell.layoutIfNeeded()
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if queries[indexPath.row] == "準備中" {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return
        }
        
//        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BackNumberTableViewCell
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: view.frame.width, height: 200)
        collectionViewLayout.minimumInteritemSpacing = 1
        
        let vc = VideoCollectionViewController(collectionViewLayout: collectionViewLayout)
        vc.searchText = queries[indexPath.row]
        vc.navigationItem.title = kikakuList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
