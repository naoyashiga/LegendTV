//
//  FavoriteCollectionViewController.swift
//  Gaki
//
//  Created by naoyashiga on 2015/07/21.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import RealmSwift

struct favoriteReuseId {
    static let cell = "VideoListCollectionViewCell"
    static let headerView = "HistoryHeaderView"
//    static let footerView = "FavoriteFooterView"
}

class FavoriteCollectionViewController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout, HistoryHeaderViewDelegate {
    private var favorites: Results<Favorite> {
        get {
            let realm = Realm()
            //新しい順に並べる
            return realm.objects(Favorite).sorted("createdAt", ascending: false)
        }
    }
    
    var maxKikakuCount = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.applyHeaderNib(headerNibName: favoriteReuseId.headerView)
        collectionView?.applyCellNib(cellNibName: favoriteReuseId.cell)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if favorites.count < maxKikakuCount {
            return favorites.count
        } else {
            return maxKikakuCount
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            var headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: favoriteReuseId.headerView, forIndexPath: indexPath) as! HistoryHeaderView
            
            headerView.delegate = self
            headerView.titleLabel.text = "お気に入り"
            
            return setCornerRadius(headerView: headerView)
        default:
            assert(false, "error")
            return UICollectionReusableView()
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(favoriteReuseId.cell, forIndexPath: indexPath) as! VideoListCollectionViewCell
        
        let favorite = favorites[indexPath.row]
        
        cell.titleLabel.text = favorite.kikakuName
//        cell.thumbNailImageView.sd_setImageWithURL(NSURL(string: favorite.thumbNailImageURL))
        
        cell.durationLabel.text = favorite.duration
        cell.likeCountLabel.text = favorite.likeCount
        cell.viewCountLabel.text = favorite.viewCount
        
        cell.thumbNailImageView.loadingImageBySDWebImage(favorite)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(favoriteReuseId.cell, forIndexPath: indexPath) as! VideoListCollectionViewCell
        
        let favorite = favorites[indexPath.row]
        delegate?.sendKikakuData(kikaku: favorite)
        delegate?.applyForControlBarKikakuData(kikaku: favorite)
        delegate?.saveHistoryFromFavoriteOrHistory(kikaku: favorite, cell: cell)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: cellSize.width, height: 50)
    }
    
    // MARK: HistoryHeaderViewDelegate
    func reloadPage() {
        collectionView?.reloadData()
    }
    
    //private method
}
