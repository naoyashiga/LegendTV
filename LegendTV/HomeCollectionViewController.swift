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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKikakuData()
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
        
        println(sections.count)
        setKikakuData()
        setStories()
        callback()
    }
    
    func setKikakuData() {
        let path:NSString = NSBundle.mainBundle().pathForResource("Kikaku", ofType: "plist")!
        kikakuData = NSDictionary(contentsOfFile: path as String)!
    }
    
    func getSeriesName(index: Int) -> String {
        let index_name: String = "item" + String(index)
        let item: AnyObject = kikakuData[index_name]!
        return item["seriesName"] as! String
    }
    
    func getKikakuDescription(index: Int) -> String {
        let index_name: String = "item" + String(index)
        let item: AnyObject = kikakuData[index_name]!
        return item["desc"] as! String
    }
    
    func getKikakuList(index: Int) -> NSArray {
        let index_name: String = "item" + String(index)
        let item: AnyObject = kikakuData[index_name]!
        return item["kikakuList"] as! [String]
    }
    
    func getQueries(index: Int) -> NSArray {
        let index_name: String = "item" + String(index)
        let item: AnyObject = kikakuData[index_name]!
        return item["queries"] as! [String]
    }
    
    func setSearchText() -> String {
        //0~kikakuData.countまでの乱数
        let randomKikakuIndex = Int(arc4random_uniform(UInt32(kikakuData.count - 1)))
        
        //Kikakuに基づくクエリを取得
        let queryArray = getQueries(randomKikakuIndex)
        let queryCount = queryArray.count - 1
        var queryIndex = Int(arc4random_uniform(UInt32(queryCount)))
        
        var randomQuery = queryArray[queryIndex] as! String
        
//        println(randomQuery)
        
        while randomQuery == "準備中" {
//            println("ng")
            queryIndex = Int(arc4random_uniform(UInt32(queryCount)))
            randomQuery = queryArray[queryIndex] as! String
//            println(randomQuery)
        }
        
        let encodingRandomQuery = randomQuery.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let kikakuList = getKikakuList(randomKikakuIndex)
        let randomKikaku = kikakuList[queryIndex] as! String
        let encodingRandomKikaku = randomKikaku.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        queries.append(encodingRandomKikaku)
        seriesNames.append(getSeriesName(randomKikakuIndex))
        kikakuNames.append(randomKikaku)
        
        return encodingRandomQuery
    }
    
    func setStories() {
        let searchWord = setSearchText()
        let requestURL = Config.REQUEST_SEARCH_URL + "q=\(searchWord)&part=snippet&maxResults=\(sectionStoriesCount)"
        
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
