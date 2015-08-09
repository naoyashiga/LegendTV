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
import LINEActivity

protocol TopViewControllerDelegate {
}

class TopViewController: UIViewController, BaseCollectionViewControllerDelegate, VideoPlayManagerDelegate {
    @IBOutlet var playerView: UIView!
    @IBOutlet var containerView: UIView!
    
    var videoId = ""
    var videoTitle = ""
    var videoThunmNailImageView = UIImageView()
    
    var playingCell = VideoListCollectionViewCell()
    
    var playingStory: Story? {
        didSet {
            applyFavoriteButtonState()
        }
    }
    
    var playingKikaku: Kikaku?
    
    var delegate: TopViewControllerDelegate?
//    var containerVCDelegate: ContainerViewControllerDelegate?
    
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
    
    var collectionViewHeight: CGFloat = 600
    var activityIndicatorView: NVActivityIndicatorView?
    let activityIndicatorViewTagNumber: Int = 1
    
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
        sender.playBounceAnimation()
        
        if let videoVC = VideoPlayManager.sharedManager.videoPlayerViewController {
            switch videoVC.moviePlayer.playbackState {
            case .Paused,.Stopped:
                
                videoVC.moviePlayer.play()
                sender.selected = true
                
                break
            case .Playing:
                
                videoVC.moviePlayer.pause()
                sender.selected = false
                
                break
            default:
                break
            }
        }
    }
    
    @IBAction func fullScreenButtonTapped(sender: UIButton) {
        sender.playBounceAnimation()
        
        if let videoVC = VideoPlayManager.sharedManager.videoPlayerViewController {
            videoVC.moviePlayer.setFullscreen(true, animated: true)
        }
    }
    
    @IBAction func favoriteButtonTapped(sender: UIButton) {
        sender.playBounceAnimation()
        
        if let playingStory = playingStory {
            checkFavorite(kikaku: nil, story: playingStory)
        }
        
        applyFavoriteButtonStateByPlayingKikaku()
    }
    
    func shareButtonTapped(sender:UIButton!){
        var sharedText = videoTitle
        let baseURL = "https://www.youtube.com/watch?v="
        var sharedURL = NSURL(string: baseURL + videoId)!
        
        var activityItems = [AnyObject]()
        
        if !videoId.isEmpty {
            if let sharedImage = videoThunmNailImageView.image {
                activityItems = [sharedText,sharedURL,sharedImage]
            } else {
                activityItems = [sharedText,sharedURL]
            }
        }
        
        let LineKit = LINEActivity()
        let myApplicationActivities = [LineKit]
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: myApplicationActivities)
        
        let excludedActivityTypes = [
            UIActivityTypePostToWeibo,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypePrint
        ]
        
        activityVC.excludedActivityTypes = excludedActivityTypes
        
        presentViewController(activityVC, animated: true, completion: nil)
        
    }
    
    func foldVideoControlButtonTapped(sender:UIButton!){
        
        if sender.selected {
            //Playerを開く
            sender.selected = false
            
            playerViewHeightConstraint.constant = 170
            
        } else {
            //Playerを閉じる
            sender.selected = true
            
            //TODO:もう一度プレイヤーを開くと、ローディングは非表示になる
            checkVideoPlayerState()
            
            playerViewHeightConstraint.constant = 0
        }
        
        UIView.animateWithDuration(
            0.6,
            delay: 0.1,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.0,
            options: nil,
            animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        
        resizedVC()
    }
    
    //MARK: private method
    private func addActivityIndicatorView() {
        let frame = CGRect(x: playerView.center.x - 40 / 2, y: playerView.center.y - 20, width: 40, height: 40)
        let activityType = NVActivityIndicatorType.LineScale
        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: activityType)
        
        if let activityIndicatorView = activityIndicatorView {
            activityIndicatorView.tag = activityIndicatorViewTagNumber
            view.addSubview(activityIndicatorView)
        }
    }
    
    private func startActivityIndicatorView() {
        addActivityIndicatorView()
        
        if let indicator = activityIndicatorView {
            indicator.startAnimation()
        }
    }
    
    private func stopActivityIndicatorView() {
        playOrPauseButtonVerticalConstraint.constant = 14
        
        if let indicator = activityIndicatorView {
            UIView.animateWithDuration(
                0.6,
                delay: 0.1,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.0,
                options: nil,
                animations: {
                    indicator.alpha = 0
                    indicator.layer.opacity = 0
                    
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    indicator.stopAnimation()
                    indicator.removeFromSuperview()
            })
        }
    }
    
    private func videoDisplayAnimation() {
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
            options: nil,
            animations: {
                self.view.layoutIfNeeded()
                self.resizedVC()
            }, completion: nil)
        
        startActivityIndicatorView()

    }
    
    func applyForControlBarData(#story: Story) {
        
        controlBarKikakuName.text = story.title
        controlBarSeriesName.text = story.seriesName
        controlBarThumbNaiImageView.sd_setImageWithURL(NSURL(string: story.thumbNailImageURL))
    }
    
    func applyForControlBarKikakuData<T: Kikaku>(#kikaku: T) {
        
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
            println("playingStory is nil")
        }
    }
    
    private func applyFavoriteButtonStateByPlayingKikaku() {
        
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
    
    private func checkFavorite(#kikaku: Kikaku?,story: Story?) {
        
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
    
    private func saveKikaku<T: Kikaku>(#kikaku: T, cell: VideoListCollectionViewCell, story: Story) {
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
//            realm.deleteAll()
            realm.add(kikaku, update: true)
        }
    }
    
    private func saveKikakuFromFavoriteOrHistory<T: Kikaku>(#tmpKikaku: T,savedKikaku: T) {
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
    
    func transitionViewController(#ToVC: BaseTableViewController) {
        navigationController?.pushViewController(ToVC, animated: true)
    }
    
    //MARK: BaseCollectionViewControllerDelegate
    func saveHistory(#story: Story, cell: VideoListCollectionViewCell) {
        
        playingCell = cell
        playingStory = story

        
        let history = History()
        saveKikaku(kikaku: history, cell: cell, story: story)
    }
    
    func saveHistoryFromFavoriteOrHistory(#kikaku: Kikaku, cell: VideoListCollectionViewCell) {
        playingCell = cell
        playingKikaku = kikaku
        
        if kikaku is Favorite {
            favoriteButton.selected = true
            let history = History()
            saveKikakuFromFavoriteOrHistory(tmpKikaku: history, savedKikaku: kikaku)
            
        } else if kikaku is History {
            //履歴から再生のときに、お気に入り登録されているかをチェック
            let realm = Realm()
            let predicate = NSPredicate(format: "videoID == %@", kikaku.videoID)
            
            if realm.objects(Favorite).filter(predicate).count == 0 {
                //お気に入り未登録
                favoriteButton.selected = false
            } else {
                //お気に入り登録済み
                favoriteButton.selected = true
            }
            
            //履歴の更新
            realm.write {
                kikaku.createdAt = NSDate().timeIntervalSince1970
                realm.add(kikaku, update: true)
            }
        }
    }
    
    func sendVideoData(#story: Story) {
        videoId = story.videoID
        videoTitle = story.title
        videoThunmNailImageView.sd_setImageWithURL(NSURL(string: story.thumbNailImageURL))
        
        applyVideoPlayManager()
    }
    
    func sendKikakuData<T: Kikaku>(#kikaku: T) {
        videoId = kikaku.videoID
        videoTitle = kikaku.kikakuName
        videoThunmNailImageView.sd_setImageWithURL(NSURL(string: kikaku.thumbNailImageURL))
        
        applyVideoPlayManager()
    }
    
    private func applyVideoPlayManager() {
        //videoId,videoTitleが更新済みであることに注意
        VideoPlayManager.sharedManager.setVideoPlayer(videoID: videoId, playerView: playerView)
        VideoPlayManager.sharedManager.setPlayingInfo(title: videoTitle, artWorkImage: videoThunmNailImageView.image)
        VideoPlayManager.sharedManager.delegate = self
        
        addShareButton()
        addFoldVideoControlButton()
        
        videoDisplayAnimation()
    }
    
    func showReview() {
        let reviewVC = ReviewModalViewController(nibName: "ReviewModalViewController", bundle: nil)
        reviewVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        navigationController?.presentViewController(reviewVC, animated: true, completion: nil)
    }
    
    //MARK:
    func videoPlayerDidChangeState(note: NSNotification) {
        checkVideoPlayerState()
    }
    
    private func checkVideoPlayerState() {
        if let videoVC = VideoPlayManager.sharedManager.videoPlayerViewController {
            
            switch videoVC.moviePlayer.playbackState {
            case .Paused,.Stopped:
                playOrPauseButton.selected = false
                for subView in view.subviews {
                    if let loadingView = subView.viewWithTag(activityIndicatorViewTagNumber) as? NVActivityIndicatorView {
                        loadingView.stopAnimation()
                        loadingView.removeFromSuperview()
                    }
                }
                
            case .Playing:
                playOrPauseButton.selected = true
                stopActivityIndicatorView()
                
                break
            default:
                break
            }
        }
    
    }
}

