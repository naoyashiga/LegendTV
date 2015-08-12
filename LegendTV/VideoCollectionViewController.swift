//
//  VideoCollectionViewController.swift
//  housoushitsu
//
//  Created by naoyashiga on 2015/07/07.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct videoReuseId {
    static let cell = "VideoListCollectionViewCell"
}

class VideoCollectionViewController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout {
    private var stories:[Story] = [Story]() {
        didSet{
            self.collectionView?.reloadData()
        }
    }
    
    private let storiesCount = 7
    
    var searchText = ""
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStories()
        
        collectionView?.applyCellNib(cellNibName: videoReuseId.cell)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setSearchText() -> String {
        let text = searchText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        return text!
    }
    
    func setStories() {
        let searchWord = setSearchText()
        let requestURL = Config.REQUEST_SEARCH_URL + "q=\(searchWord)&part=snippet&maxResults=\(storiesCount)"
        
        Alamofire.request(.GET, requestURL).responseSwiftyJSON({ (_, _, json, error) in
            if (error != nil) {
                println("Error with registration: \(error?.localizedDescription)")
            } else {
                
                var stories = [Story]()
                
                if let items = json["items"].array {
                    for item in items {
                        let duration = Story(json: item)
                        stories.append(duration)
                    }
                    
                    self.stories = stories
                    self.activityIndicator.stopAnimating()
                }
            }
        })
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        collectionView.collectionViewLayout.invalidateLayout()
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return storiesCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(videoReuseId.cell, forIndexPath: indexPath) as! VideoListCollectionViewCell
        
        if stories.count == 0 {
            return cell
        }
        
        let story = stories[indexPath.row]
        
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
        
        cell.titleLabel.text = story.title
        
        cell.thumbNailImageView.loadingStoryImageBySDWebImage(story)
        
        VideoInfo.getDurationTimes(story.videoID){ contentDetails in
            if contentDetails.isEmpty {
                cell.durationLabel.text = "??:??"
            } else {
                let duration = contentDetails[0].duration
                cell.durationLabel.text = VideoInfo.getDurationStr(duration)
            }
        }
        
        VideoInfo.getStatistics(story.videoID){ statistics in
            if statistics.isEmpty {
                cell.viewCountLabel.text = "?"
                cell.likeCountLabel.text = "?"
            } else {
                cell.viewCountLabel.text = statistics[0].viewCount
                cell.likeCountLabel.text = statistics[0].likeCount
            }
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(homeReuseId.cell, forIndexPath: indexPath) as! VideoListCollectionViewCell
        
        let story = stories[indexPath.row]
        
        if let seriesName = navigationItem.title {
            story.seriesName = seriesName
        }
        
        var callBackCount = 0
        getDurationTimeAndStatistics(story: story, cell: cell) { cellHavingData in
            callBackCount++
            
            if callBackCount == 2 {
                if let navVC = self.navigationController?.navigationController {
                    if let topVC = navVC.childViewControllers.first as? TopViewController {
                        self.delegate = topVC
                        self.delegate?.saveHistory(story: story, cell: cellHavingData)
                        self.delegate?.sendVideoData(story: story)
                        self.delegate?.applyForControlBarData(story: story)
                    }
                }
            }
        }
    }
}
