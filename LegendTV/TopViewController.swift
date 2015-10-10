//
//  TopViewController.swift
//  Gaki
//
//  Created by naoyashiga on 2015/07/20.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import RealmSwift
import Accounts

class TopViewController: UIViewController {
    @IBOutlet var playerView: UIView!
    @IBOutlet var containerView: UIView!
    
    var videoID = ""
    var videoTitle = ""
    var videoThunmNailImageView = UIImageView()
    
    var playingCell = VideoListCollectionViewCell()
    
    var playingStory: Story? {
        didSet {
            applyFavoriteButtonState()
        }
    }
    
    var playingKikaku: Kikaku?
    
    var collectionViewHeight: CGFloat = 600
    var activityIndicatorView: NVActivityIndicatorView?
    let activityIndicatorViewTagNumber: Int = 1
    
    @IBOutlet var playerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var controlBarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var playOrPauseButtonVerticalConstraint: NSLayoutConstraint!
    @IBOutlet var favoriteButton: UIButton!
    
    @IBOutlet var playOrPauseButton: UIButton! {
        didSet {
            playOrPauseButton.selected = true
        }
    }
    
    @IBOutlet var controlBarSeriesName: UILabel!
    @IBOutlet var controlBarKikakuName: UILabel!
    @IBOutlet var controlBarThumbNaiImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerViewHeightConstraint.constant = 0
        controlBarHeightConstraint.constant = 0
        playOrPauseButtonVerticalConstraint.constant = 74
        
        view.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        applyChildVCDelegate()
    }
    
    //MARK: action method
    @IBAction func playOrPauseButtonTapped(sender: UIButton) {
        didPlayOrPauseButtonTapped(sender)
    }
    
    @IBAction func fullScreenButtonTapped(sender: UIButton) {
        didFullScreenButtonTapped(sender)
    }
    
    @IBAction func favoriteButtonTapped(sender: UIButton) {
        didFavoriteButtonTapped(sender)
    }
    
    //MARK: private method
    
    func videoDisplayAnimation() {
        playOrPauseButtonVerticalConstraint.constant = 74
        
        checkVideoPlayerState()
        
        if playerViewHeightConstraint.constant == 0 {
            controlBarHeightConstraint.constant = 60
            playerViewHeightConstraint.constant = 170
        }
        
        UIView.animateWithDuration(
            0.6,
            delay: 0.1,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.0,
            options: [],
            animations: {
                self.view.layoutIfNeeded()
                self.resizedVC()
            }, completion: nil)
        
        startActivityIndicatorView()

    }
    
    func applyForControlBarData(story story: Story) {
        
        controlBarKikakuName.text = story.title
        controlBarSeriesName.text = story.seriesName
        controlBarThumbNaiImageView.sd_setImageWithURL(NSURL(string: story.thumbNailImageURL))
    }
    
    func applyForControlBarKikakuData<T: Kikaku>(kikaku kikaku: T) {
        
        controlBarKikakuName.text = kikaku.kikakuName
        controlBarSeriesName.text = kikaku.seriesName
        controlBarThumbNaiImageView.sd_setImageWithURL(NSURL(string: kikaku.thumbNailImageURL))
        
        //お気に入りボタンの状態を更新
        if kikaku is Favorite {
            favoriteButton.selected = true
        } else if kikaku is History {
            let realm = Realm()
            let predicate = NSPredicate(format: "videoID == %@", kikaku.videoID)
            
            if realm.objects(Favorite).filter(predicate).count == 0 {
                //お気に入り未登録
                favoriteButton.selected = false
            } else {
                //お気に入り登録済み
                favoriteButton.selected = true
            }
        }
    }
    
    private func applyFavoriteButtonState() {
        if let playingStory = playingStory {
            
            let realm = Realm()
            let predicate = NSPredicate(format: "videoID == %@", playingStory.videoID)
            
            if realm.objects(Favorite).filter(predicate).count == 0 {
                //お気に入り未登録
                favoriteButton.selected = false
            } else {
                //お気に入り登録済み
                favoriteButton.selected = true
            }
            
        } else {
            print("playingStory is nil")
        }
    }
    
    func applyFavoriteButtonStateByPlayingKikaku() {
        
        if let playingKikaku = playingKikaku {
            
            if playingKikaku is Favorite {
                let realm = Realm()
                
                realm.write {
                    //お気に入り解除
                    realm.delete(playingKikaku)
                }
                
                favoriteButton.selected = false
            }
            
            if playingKikaku is History {
                
                checkFavorite(kikaku: playingKikaku, story: nil)
            }
        }
    }
    
    func checkFavorite(kikaku kikaku: Kikaku?,story: Story?) {
        
        if favoriteButton.selected {
            let realm = Realm()
            var predicate: NSPredicate?
            
            if let kikaku = kikaku {
                predicate = NSPredicate(format: "videoID == %@", kikaku.videoID)
            }
            
            if let story = story {
                predicate = NSPredicate(format: "videoID == %@", story.videoID)
            }
            
            if let predicate = predicate {
                let deletedFav = realm.objects(Favorite).filter(predicate)[0]
                
                realm.write {
                    //お気に入り解除
                    realm.delete(deletedFav)
                }
                
                favoriteButton.selected = false
            }
            
        } else {
            favoriteButton.selected = true
            
            //お気に入り登録
            let newFavorite = Favorite()
            
            if let kikaku = kikaku {
                saveKikakuFromFavoriteOrHistory(tmpKikaku: newFavorite, savedKikaku: kikaku)
            }
            
            if let story = story {
                saveKikaku(kikaku: newFavorite, cell: playingCell, story: story)
            }
        }
    }
    
    func saveKikaku<T: Kikaku>(kikaku kikaku: T, cell: VideoListCollectionViewCell, story: Story) {
        kikaku.videoID = story.videoID
        kikaku.kikakuName = story.title
        kikaku.seriesName = story.seriesName
        kikaku.thumbNailImageURL = story.thumbNailImageURL
        
        kikaku.duration = cell.durationLabel.text!
        kikaku.viewCount = cell.viewCountLabel.text!
        kikaku.likeCount = cell.likeCountLabel.text!
        
        kikaku.createdAt = NSDate().timeIntervalSince1970
        
        let realm = Realm()
        realm
        realm.write {
            realm.add(kikaku, update: true)
        }
    }
    
    func saveKikakuFromFavoriteOrHistory<T: Kikaku>(tmpKikaku tmpKikaku: T,savedKikaku: T) {
        tmpKikaku.videoID = savedKikaku.videoID
        tmpKikaku.kikakuName = savedKikaku.kikakuName
        tmpKikaku.seriesName = savedKikaku.seriesName
        tmpKikaku.thumbNailImageURL = savedKikaku.thumbNailImageURL
        
        tmpKikaku.duration = savedKikaku.duration
        tmpKikaku.viewCount = savedKikaku.viewCount
        tmpKikaku.likeCount = savedKikaku.likeCount
        
        tmpKikaku.createdAt = NSDate().timeIntervalSince1970
        
        let realm = Realm()
        realm.write {
            realm.add(tmpKikaku, update: true)
        }
    }
}
