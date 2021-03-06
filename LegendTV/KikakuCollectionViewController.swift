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
    func transitionViewController(ToVC ToVC:BaseTableViewController)
}

class KikakuCollectionViewController: BaseCollectionViewController {
    
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
        
        if let path = NSBundle.mainBundle().pathForResource("Kikaku", ofType: "json") {
            if let data = NSData(contentsOfFile: path) {
                let json = JSON(data: data, options: NSJSONReadingOptions.AllowFragments, error: nil)
                kikakuJSON = json
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return kikakuJSON["items"].count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: kikakuReuseId.headerView, forIndexPath: indexPath) as! KikakuHeaderView
            
            let item = kikakuJSON["items"][indexPath.section]
            headerView.headerTitleLabel.text = item["seriesName"].stringValue
            
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
        
        let item = kikakuJSON["items"][indexPath.section]
        cell.descriptionLabel.text = item["desc"].stringValue
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let item = kikakuJSON["items"][indexPath.section]
        
        let vc = SecondBackNumberTableViewController()
        vc.kikakuList = item["kikakuList"]
        vc.navigationItem.title = item["seriesName"].stringValue
        
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
