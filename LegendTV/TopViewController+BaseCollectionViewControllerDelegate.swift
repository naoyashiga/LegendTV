//
//  TopViewController+BaseCollectionViewControllerDelegate.swift
//  LegendTV
//
//  Created by naoyashiga on 2015/08/09.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import RealmSwift

extension TopViewController: BaseCollectionViewControllerDelegate {
    
    func saveHistory(story story: Story, cell: VideoListCollectionViewCell) {
        
        playingCell = cell
        playingStory = story

        
        let history = History()
        saveKikaku(kikaku: history, cell: cell, story: story)
    }
    
    func saveHistoryFromFavoriteOrHistory(kikaku kikaku: Kikaku, cell: VideoListCollectionViewCell) {
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
    
    func sendVideoData(story story: Story) {
        videoID = story.videoID
        videoTitle = story.title
        videoThunmNailImageView.sd_setImageWithURL(NSURL(string: story.thumbNailImageURL))
        
        applyVideoPlayManager()
    }
    
    func sendKikakuData<T: Kikaku>(kikaku kikaku: T) {
        videoID = kikaku.videoID
        videoTitle = kikaku.kikakuName
        videoThunmNailImageView.sd_setImageWithURL(NSURL(string: kikaku.thumbNailImageURL))
        
        applyVideoPlayManager()
    }
    
    private func applyVideoPlayManager() {
        //videoId,videoTitleが更新済みであることに注意
        VideoPlayManager.sharedManager.setVideoPlayer(videoID: videoID, playerView: playerView)
        VideoPlayManager.sharedManager.setPlayingInfo(title: videoTitle, artWorkImage: videoThunmNailImageView.image)
        VideoPlayManager.sharedManager.delegate = self
        
        addShareButton()
        addFoldVideoControlButton()
        
        videoDisplayAnimation()
    }
}