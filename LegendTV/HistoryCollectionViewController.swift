//
//  HistoryCollectionViewController.swift
//  Gaki
//
//  Created by naoyashiga on 2015/07/21.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import RealmSwift

struct historyReuseId {
    static let cell = "VideoListCollectionViewCell"
    static let reviewCell = "RequireReviewCollectionViewCell"
    static let headerView = "HistoryHeaderView"
    static let footerView = "HistoryFooterView"
}

class HistoryCollectionViewController: BaseCollectionViewController, HistoryHeaderViewDelegate {
    private var histories: Results<History> {
        get {
            do {
                let realm = try Realm()
                return realm.objects(History).sorted("createdAt", ascending: false)
                
            } catch {
                fatalError("error histories")
            }
        }
    }
    
    var maxKikakuCount = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView?.registerNib(UINib(nibName: historyReuseId.footerView, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: historyReuseId.footerView)
        
        collectionView?.emptyDataSetDelegate = self
        collectionView?.emptyDataSetSource = self
        
        collectionView?.applyHeaderNib(headerNibName: historyReuseId.headerView)
        collectionView?.applyCellNib(cellNibName: historyReuseId.cell)
        collectionView?.applyCellNib(cellNibName: historyReuseId.reviewCell)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //TODO: 期間によって区分けする
//        let now = NSDate().timeIntervalSince1970
//        let DAY_IN_SECONDS = 60 * 60 * 24
//        let hours = 60 * 60
//        
//        let yesterday: Double = now - Double(DAY_IN_SECONDS)
//        let threeDaysAgo: Double = now - Double(DAY_IN_SECONDS * 3)
//        let threeHoursAgo: Double = now - Double(hours * 3)
//        
//        println(now)
//        println(threeHoursAgo)
//        
////        let predicate = NSPredicate(format: "createdAt < %d", threeDaysAgo)
//        let predicate = NSPredicate(format: "createdAt > %d", yesterday)
//        let threeDaysAgoHistories = histories.filter(predicate)
//        
//        println(threeDaysAgoHistories.count)
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if ReviewManager.isReview {
            //レビュー済み
            if histories.count < maxKikakuCount {
                return histories.count
            } else {
                return maxKikakuCount
            }
        } else {
            //レビューまだ
            let maxInitialHistoryCount = 4
            
            if maxInitialHistoryCount > histories.count {
                //3件未満のとき
                return histories.count
            } else {
                return maxInitialHistoryCount
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: historyReuseId.headerView, forIndexPath: indexPath) as! HistoryHeaderView
            
            headerView.delegate = self
            
            if ReviewManager.isReview {
                headerView.moreLoadButton.setTitle("", forState: .Normal)
                
                if histories.count < maxKikakuCount {
                    headerView.titleLabel.text = "最新\(histories.count)/30件"
                } else {
                    headerView.titleLabel.text = "最新30/30件"
                }
                
            } else {
                if histories.count <= 3 {
                    headerView.titleLabel.text = "最新\(histories.count)/30件"
                } else {
                    headerView.titleLabel.text = "最新3/30件"
                }
            }
            

            return setCornerRadius(headerView: headerView)

//            case UICollectionElementKindSectionFooter:
//                let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseId.kikakuFooterView, forIndexPath: indexPath) as! KikakuFooterView
//    
//                return footerView

        default:
            assert(false, "error")
            return UICollectionReusableView()
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if !ReviewManager.isReview && indexPath.length != 0 && indexPath.row == indexPath.length + 1 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(historyReuseId.reviewCell, forIndexPath: indexPath) as! RequireReviewCollectionViewCell
            return cell
        }
        
        //レビュー済み
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(historyReuseId.cell, forIndexPath: indexPath) as! VideoListCollectionViewCell
        
        
        let history = histories[indexPath.row]
        
        cell.titleLabel.text = history.kikakuName
        
        cell.durationLabel.text = history.duration
        cell.likeCountLabel.text = history.likeCount
        cell.viewCountLabel.text = history.viewCount
        
        cell.thumbNailImageView.loadingImageBySDWebImage(history)
        
        return cell
    }
    
    func getVideoListCollectionViewCell(indexPath: NSIndexPath) {
        
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if !ReviewManager.isReview && indexPath.length != 0 && indexPath.row == indexPath.length + 1 {
            didMoreLoadButtonTapped()
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(historyReuseId.cell, forIndexPath: indexPath) as! VideoListCollectionViewCell
            
            let history = histories[indexPath.row]
            delegate?.sendKikakuData(kikaku: history)
            delegate?.applyForControlBarKikakuData(kikaku: history)
            delegate?.saveHistoryFromFavoriteOrHistory(kikaku: history, cell: cell)
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: cellSize.width, height: 50)
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: cellWidth, height: 55)
//    }
    
    // MARK: HistoryHeaderViewDelegate
    func reloadPage() {
        collectionView?.reloadData()
    }
    
    func didMoreLoadButtonTapped() {
        
        if !ReviewManager.isReview {
            let reviewVC = ReviewModalViewController(nibName: "ReviewModalViewController", bundle: nil)
            reviewVC.modalPresentationStyle = .Custom
            reviewVC.transitioningDelegate = self
            view.window?.rootViewController?.presentViewController(reviewVC, animated: true, completion: nil)
        }
    }
    
}
