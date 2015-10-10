//
//  HomeCollectionViewController.swift
//  housoushitsu
//
//  Created by naoyashiga on 2015/07/04.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct homeReuseId {
    static let cell = "VideoListCollectionViewCell"
    static let headerView = "HomeHeaderView"
}

class HomeCollectionViewController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout {
    private var sections = [[Story]]()
    private var queries = [String]()
    private var seriesNames = [String]()
    private var kikakuNames = [String]()
    
    private var searchText = ""
    private var sectionIndex = 0
    
    private let sectionStoriesCount = 3
    private let sectionCount = 3
    
    private var headerIndex = 0
    
    var kikakuData: NSDictionary = NSDictionary()
    var kikakuJSON: JSON = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKikakuJSON()
        setStories()
        
        collectionView?.applyHeaderNib(headerNibName: homeReuseId.headerView)
        collectionView?.applyCellNib(cellNibName: homeReuseId.cell)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: private method
    override func refresh() {
        finishReloadData() {
            self.refreshControl.endRefreshing()
        }
    }
    
    private func finishReloadData(callback:() -> ()) {
        sections = [[Story]]()
        queries = [String]()
        seriesNames = [String]()
        kikakuNames = [String]()
        
        sectionIndex = 0
        
        print(sections.count)
        setKikakuJSON()
        setStories()
        callback()
    }
    
    func setKikakuJSON() {
        if let path = NSBundle.mainBundle().pathForResource("Kikaku", ofType: "json") {
            if let data = NSData(contentsOfFile: path) {
                let json = JSON(data: data, options: NSJSONReadingOptions.AllowFragments, error: nil)
                kikakuJSON = json
            }
        }
    }
    
    func setSearchText() -> String {
        let itemCount = kikakuJSON["items"].count
        let item = kikakuJSON["items"][Int.random(0...(itemCount - 1))]
        let kikakuList = item["kikakuList"]
        var randomKikaku = kikakuList[Int.random(0...(kikakuList.count - 1))]
        
        if let randomKikakuNotOptional = randomKikaku["query"].string {
            if randomKikakuNotOptional.isEmpty {
                randomKikaku = kikakuList[Int.random(0...kikakuList.count)]
                print("empty")
                
                if let second = randomKikaku["query"].string {
                    if second.isEmpty {
                        //2回目も空
                        randomKikaku["query"] = randomKikaku["name"]
//                        println("queryをnameと同じにする")
                    }
                }
            }
        } else {
            
//            println("query optional")
//            println("queryをnameと同じにする")
            randomKikaku["query"] = randomKikaku["name"]
        }
        
        if let query = randomKikaku["query"].string {
            
            let encodingRandomQuery = query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            queries.append(encodingRandomQuery)
            
            if let seriesName = item["seriesName"].string {
                seriesNames.append(seriesName)
            }
            
            if let kikakuName = randomKikaku["name"].string {
                kikakuNames.append(kikakuName)
            }
            
            return encodingRandomQuery
            
        } else {
            print("query error")
            return "ガキの使い".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        }
    }
    
    func setStories() {
        let searchWord = setSearchText()
        let requestURL = Config.REQUEST_SEARCH_URL + "q=\(searchWord)&part=snippet&maxResults=\(sectionStoriesCount)"
        
        Alamofire.request(.GET, requestURL).responseSwiftyJSON({ (_, _, json, error) in
            if (error != nil) {
                print("Error with registration: \(error?.localizedDescription)")
            } else {
                
                var stories = [Story]()
                
                if let items = json["items"].array {
                    for item in items {
                        let duration = Story(json: item)
                        stories.append(duration)
                    }
                    
                    self.sectionIndex++
                    self.sections.append(stories)
                    
                    if self.sectionIndex < self.sectionCount {
                        self.setStories()
                    } else {
                        self.collectionView?.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                    
                }
            }
        })
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sectionCount
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionStoriesCount
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: homeReuseId.headerView, forIndexPath: indexPath) as! HomeHeaderView
            
            if queries.count == sectionCount {
                headerView.headerTitleLabel.text = kikakuNames[indexPath.section]
            }
            
            return setCornerRadius(headerView: headerView)
            
        default:
            assert(false, "error")
            return UICollectionReusableView()
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(homeReuseId.cell, forIndexPath: indexPath) as! VideoListCollectionViewCell
    
        if sections.count != sectionCount {
//            println("not fill sectionCount")
            return cell
        }
        
        let sectionStories = sections[indexPath.section]
        let story = sectionStories[indexPath.row]
        
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
        
        let sectionStories = sections[indexPath.section]
        let story = sectionStories[indexPath.row]
        
        story.seriesName = seriesNames[indexPath.section]
        
//        let vc = TransitionManager.sharedManager.getDetailViewController(story: story)
//        navigationController?.pushViewController(vc, animated: true)
        
        //get Data for History
        var callBackCount = 0
        getDurationTimeAndStatistics(story: story, cell: cell) { cellHavingData in
            callBackCount++
            
            if callBackCount == 2 {
                self.delegate?.saveHistory(story: story, cell: cellHavingData)
                self.delegate?.sendVideoData(story: story)
                self.delegate?.applyForControlBarData(story: story)
            }
        }
        
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: cellSize.width, height: 45)
    }
    
}
