//
//  FavoriteCollectionViewController+DZNEmptyDataSet.swift
//  LegendTV
//
//  Created by naoyashiga on 2015/08/10.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import DZNEmptyDataSet

extension FavoriteCollectionViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // MARK: DZNEmptyDataSetSource
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "like.png")
    }
    
    func imageTintColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return UIColor.grayColor()
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "お気に入りは0件です"
        let font = UIFont(name: FontSet.bold, size: 30)!
        return NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "最大30件まで登録できます"
        let font = UIFont(name: FontSet.medium, size: 14)!
        return NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
    }
    
    func buttonImageForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> UIImage! {
        return UIImage(named: "reload_gray.png")
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        collectionView?.reloadData()
    }
}
