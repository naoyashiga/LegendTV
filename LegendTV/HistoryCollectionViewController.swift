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
    static let headerView = "HistoryHeaderView"
    static let footerView = "HistoryFooterView"
}

class HistoryCollectionViewController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout, HistoryHeaderViewDelegate {
    private var histories: Results<History> {
        get {
            let realm = Realm()
            return realm.objects(History).sorted("createdAt", ascending: false)
        }
    }
    
    var maxKikakuCount = 30
    var isReview = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView?.registerNib(UINib(nibName: historyReuseId.footerView, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: historyReuseId.footerView)
        
        collectionView?.applyHeaderNib(headerNibName: historyReuseId.headerView)
        collectionView?.applyCellNib(cellNibName: historyReuseId.cell)
        
        setIsReview()
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setIsReview(){
        let ud = NSUserDefaults.standardUserDefaults()
        if(ud.objectForKey("isReview") == nil){
            isReview = false
            ud.setObject(isReview, forKey: "isReview")
        }else{
            isReview = ud.boolForKey("isReview")
        }
        
        println("isReview")
        println(isReview)
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //TODO: 期間によって区分けする
//        let now = NSDate().timeIntervalSince1970
//        let DAY_IN_SECONDS = 60 * 60 * 24
//        let threeDaysAgo = now - Double(DAY_IN_SECONDS * 3)
//        
//        let predicate = NSPredicate(format: "createdAt < %@ ","threeDaysAgo")
//        let threeDaysAgoHistories = histories.filter(predicate)
//        
//        println(threeDaysAgoHistories.count)
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isReview {
            //レビュー済み
            if histories.count < maxKikakuCount {
                return histories.count
            } else {
                return maxKikakuCount
            }
        } else {
            //レビューまだ
            var maxInitialHistoryCount = 3
            
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
            var headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: historyReuseId.headerView, forIndexPath: indexPath) as! HistoryHeaderView
            
            headerView.delegate = self
            
            if isReview {
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(historyReuseId.cell, forIndexPath: indexPath) as! VideoListCollectionViewCell
        
        
        let history = histories[indexPath.row]
        
        cell.titleLabel.text = history.kikakuName
        
        cell.durationLabel.text = history.duration
        cell.likeCountLabel.text = history.likeCount
        cell.viewCountLabel.text = history.viewCount
        
        cell.thumbNailImageView.loadingImageBySDWebImage(history)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(historyReuseId.cell, forIndexPath: indexPath) as! VideoListCollectionViewCell
        
        let history = histories[indexPath.row]
        delegate?.sendKikakuData(kikaku: history)
        delegate?.applyForControlBarKikakuData(kikaku: history)
        delegate?.saveHistoryFromFavoriteOrHistory(kikaku: history, cell: cell)
        
//        delegate?.showReview()
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
        
        if !isReview {
            delegate?.showReview()
        }
    }
    
    //private method
}
