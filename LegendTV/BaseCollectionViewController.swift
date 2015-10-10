//
//  BaseCollectionViewController.swift
//  housoushitsu
//
//  Created by naoyashiga on 2015/07/04.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

protocol BaseCollectionViewControllerDelegate {
    func sendVideoData(story story: Story)
    func sendKikakuData<T: Kikaku>(kikaku kikaku: T)
    func applyForControlBarData(story story: Story)
    func applyForControlBarKikakuData<T: Kikaku>(kikaku kikaku: T)
    func saveHistory(story story: Story, cell: VideoListCollectionViewCell)
    func saveHistoryFromFavoriteOrHistory(kikaku kikaku: Kikaku, cell: VideoListCollectionViewCell)
}

struct cellSize {
    static var width:CGFloat = 0.0
    static var height:CGFloat = getCellHeight()
}

func getCellHeight() -> CGFloat {
    switch iOSDevice() {
    case "4":
        return 95
    case "5":
        return 95
    case "6":
        return 80
    case "6Plus":
        return 90
    default:
        return 80
    }
}

struct cellMargin {
    static let vertical:CGFloat = 2.0
    static let horizontal:CGFloat = 20.0
}

class BaseCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var activityIndicator = UIActivityIndicatorView()
    var delegate: BaseCollectionViewControllerDelegate?
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let edgeInsetBottom:CGFloat = 20
        let edgeInsetTop:CGFloat = 10
        
        setBackButton()
        
        cellSize.width = view.bounds.width
        
        if let collectionView = collectionView {
            collectionView.contentInset = UIEdgeInsetsMake(edgeInsetTop, cellMargin.horizontal / 2, edgeInsetBottom, cellMargin.horizontal / 2)
            
            collectionView.backgroundColor = UIColor.viewBackgroundColor()
            
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
            collectionView.addSubview(refreshControl)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refresh() {
        collectionView?.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func setBackButton() {
        let backButton = UIBarButtonItem(title: "< 戻る", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: FontSet.medium, size: 15)!], forState: UIControlState.Normal)
    }
    
    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    func showActivityIndicator(uiView: UIView) {
        activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        activityIndicator.center = uiView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.WhiteLarge
        uiView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    func setCornerRadius<T: UICollectionReusableView>(headerView headerView:T) -> T {
        let cornerRadius: CGFloat = 5.0
        let maskPath = UIBezierPath(roundedRect: headerView.bounds, byRoundingCorners: ([UIRectCorner.TopLeft, UIRectCorner.TopRight]), cornerRadii: CGSizeMake(cornerRadius, cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = headerView.bounds
        maskLayer.path = maskPath.CGPath
        headerView.layer.mask = maskLayer
        
        return headerView
    }
    
    func getDurationTimeAndStatistics(story story: Story, cell: VideoListCollectionViewCell, myCallback: (VideoListCollectionViewCell) -> ()) {
        
        VideoInfo.getDurationTimes(story.videoID){ contentDetails in
            if contentDetails.isEmpty {
                cell.durationLabel.text = "??:??"
            } else {
                let duration = contentDetails[0].duration
                cell.durationLabel.text = VideoInfo.getDurationStr(duration)
            }
            myCallback(cell)
        }
        
        VideoInfo.getStatistics(story.videoID){ statistics in
            if statistics.isEmpty {
                cell.viewCountLabel.text = "?"
                cell.likeCountLabel.text = "?"
            } else {
                cell.viewCountLabel.text = statistics[0].viewCount
                cell.likeCountLabel.text = statistics[0].likeCount
            }
            myCallback(cell)
        }
    }
    
    // MARK: UICollectionViewDataSource

//    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let reuseIdentifier = "Cell"
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
//    
//        return cell
//    }
//    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: cellSize.width - cellMargin.horizontal, height: cellSize.height)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellMargin.vertical
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}
