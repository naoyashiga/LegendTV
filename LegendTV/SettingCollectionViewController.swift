//
//  SettingCollectionViewController.swift
//  LegendTV
//
//  Created by naoyashiga on 2015/08/24.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

struct settingReuseId {
    static let cell = "SettingCollectionViewCell"
    static let headerView = "SettingHeaderView"
}

class SettingCollectionViewController: BaseCollectionViewController {
    var reviewMenu = [
        "レビューを書いて応援する",
        "他のアプリを見る"
    ]
    
    var snsMenu = [
        "Twitterでつぶやく",
        "LINEに送る"
    ]
    
    var shareText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellSize.width = view.bounds.width
        cellSize.height = 80
        
        if let collectionView = collectionView {
            collectionView.contentInset = UIEdgeInsetsMake(10, cellMargin.horizontal / 2, 0, cellMargin.horizontal / 2)
            collectionView.applyHeaderNib(headerNibName: settingReuseId.headerView)
            collectionView.applyCellNib(cellNibName: settingReuseId.cell)
        }
        
        let localizedshareText = "お笑い動画アプリ "
        shareText = localizedshareText + AppConstraints.appStoreURLString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return reviewMenu.count
        } else {
            return snsMenu.count
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: settingReuseId.headerView, forIndexPath: indexPath) as! SettingHeaderView
            
            switch indexPath.section {
            case 0:
                headerView.titleLabel.text = "応援"
            case 1:
                headerView.titleLabel.text = "シェア"
            default:
                break
            }
            
            return setCornerRadius(headerView: headerView)
            
        default:
            assert(false, "error")
            return UICollectionReusableView()
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(settingReuseId.cell, forIndexPath: indexPath) as! SettingCollectionViewCell
        
        switch indexPath.section {
        case 0:
            cell.titleLabel.text = reviewMenu[indexPath.row]
        case 1:
            cell.titleLabel.text = snsMenu[indexPath.row]
        default:
            break;
        }
        
        return getSelectedBackgroundViewCell(cell: cell)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(settingReuseId.cell, forIndexPath: indexPath) as! SettingCollectionViewCell
        
        switch indexPath.section {
        case 0:
            
            if indexPath.row == 0 {
                transitionToReviewPage()
            } else {
                transitionToOtherAppPage()
            }
            
        case 1:
            switch indexPath.row {
            case 0:
                postToTwitter()
            case 1:
                postToLINE()
            default:
                break
            }
            break
        default:
            break
        }
    }
    
    private func getSelectedBackgroundViewCell(cell cell: SettingCollectionViewCell) -> SettingCollectionViewCell {
        //通常の背景
        let backgroundView = UIView()
        backgroundView.bounds = cell.bounds
        backgroundView.backgroundColor = UIColor.cellLightBackgroundColor()
        cell.backgroundView = backgroundView
        
        //選択時の背景
        let selectedBackgroundView = UIView()
        selectedBackgroundView.bounds = cell.bounds
        selectedBackgroundView.backgroundColor = UIColor.cellSelectedBackgroundColor()
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: cellSize.width, height: 50)
    }
}