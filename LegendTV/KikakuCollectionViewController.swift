//
//  KikakuCollectionViewController.swift
//  Gaki
//
//  Created by naoyashiga on 2015/07/11.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

struct kikakuReuseId {
    static let cell = "KikakuCollectionViewCell"
    static let headerView = "KikakuHeaderView"
    static let footerView = "KikakuFooterView"
}

protocol KikakuCollectionViewControllerDelegate {
    func transitionViewController(#ToVC:BaseTableViewController)
}

class KikakuCollectionViewController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var kikakuData: NSDictionary = NSDictionary()
    
    var kikakuDelegate: KikakuCollectionViewControllerDelegate?
    var kikakuJSON: JSON = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellSize.height = 95
        
        collectionView?.applyHeaderNib(headerNibName: kikakuReuseId.headerView)
//        collectionView?.applyFooterNib(footerNibName: kikakuReuseId.footerView)
        collectionView?.applyCellNib(cellNibName: kikakuReuseId.cell)
        
        setKikakuData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setKikakuData() {
        let path:NSString = NSBundle.mainBundle().pathForResource("Kikaku", ofType: "plist")!
        kikakuData = NSDictionary(contentsOfFile: path as String)!
        
        if let path = NSBundle.mainBundle().pathForResource("Kikaku", ofType: "json") {
            if let data = NSData(contentsOfFile: path) {
                let json = JSON(data: data, options: NSJSONReadingOptions.AllowFragments, error: nil)
                kikakuJSON = json
            }
        }
    }
    
    func getSeriesName(index: Int) -> String {
        let index_name: String = "item" + String(index)
        let item: AnyObject = kikakuData[index_name]!
        return item["seriesName"] as! String
    }
    
    func getKikakuDescription(index: Int) -> String {
        let index_name: String = "item" + String(index)
        let item: AnyObject = kikakuData[index_name]!
        return item["desc"] as! String
    }
    
    func getKikakuList(index: Int) -> NSArray {
        let index_name: String = "item" + String(index)
        let item: AnyObject = kikakuData[index_name]!
        return item["kikakuList"] as! [String]
    }
    
    func getQueries(index: Int) -> NSArray {
        let index_name: String = "item" + String(index)
        let item: AnyObject = kikakuData[index_name]!
        return item["queries"] as! [String]
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return kikakuData.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            var headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: kikakuReuseId.headerView, forIndexPath: indexPath) as! KikakuHeaderView
            
            headerView.headerTitleLabel.text = getSeriesName(indexPath.section)
            
            return setCornerRadius(headerView: headerView)
            
//        case UICollectionElementKindSectionFooter:
//            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: kikakuReuseId.footerView, forIndexPath: indexPath) as! KikakuFooterView
//            
//            return footerView
//            
        default:
            assert(false, "error")
            return UICollectionReusableView()
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kikakuReuseId.cell, forIndexPath: indexPath) as! KikakuCollectionViewCell
        
        cell.descriptionLabel.text = getKikakuDescription(indexPath.section)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kikakuReuseId.cell, forIndexPath: indexPath) as! KikakuCollectionViewCell
        
        let item = kikakuJSON["items"][indexPath.section]
        let kikakuList = item["kikakuList"].array
        
        let vc = SecondBackNumberTableViewController()
        
        vc.kikakuList = item["kikakuList"]
        
//        vc.queries = getQueries(indexPath.section) as! [(String)]
        vc.navigationItem.title = item["seriesName"].string
        
//        let vc = SecondBackNumberTableViewController()
//        vc.kikakuList = getKikakuList(indexPath.section) as! [(String)]
//        vc.queries = getQueries(indexPath.section) as! [(String)]
//        vc.navigationItem.title = getSeriesName(indexPath.section)
        
        kikakuDelegate?.transitionViewController(ToVC: vc)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: cellSize.width, height: 45)
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: cellSize.width, height: 55)
//    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }
}
