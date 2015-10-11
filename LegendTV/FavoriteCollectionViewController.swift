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
    static let headerView = "FavoriteHeaderView"
}

class FavoriteCollectionViewController: BaseCollectionViewController, FavoriteHeaderViewDelegate {
    private var favorites: Results<Favorite> {
        get {
            do {
                let realm = try Realm()
                //新しい順に並べる
                return realm.objects(Favorite).sorted("createdAt", ascending: false)
                
            } catch {
                fatalError("cant set favorites")
            }
        }
    }
    
    var maxKikakuCount = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.emptyDataSetDelegate = self
        collectionView?.emptyDataSetSource = self
        
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
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: favoriteReuseId.headerView, forIndexPath: indexPath) as! FavoriteHeaderView
            
            headerView.delegate = self
            
            if favorites.count < 30 {
                headerView.titleLabel.text = "最新\(favorites.count)/30件"
            } else {
                headerView.titleLabel.text = "最新30/30件"
            }
            
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
    
    // MARK: FavoriteHeaderViewDelegate
    func reloadPage() {
        collectionView?.reloadData()
    }
}
