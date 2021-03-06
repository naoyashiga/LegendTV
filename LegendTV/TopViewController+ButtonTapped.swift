//
//  TopViewController+ButtonTapped.swift
//  LegendTV
//
//  Created by naoyashiga on 2015/08/09.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import LINEActivity

extension TopViewController {
    
    func didPlayOrPauseButtonTapped(sender: UIButton) {
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

    func didFullScreenButtonTapped(sender: UIButton) {
        
        sender.playBounceAnimation()
        
        if let videoVC = VideoPlayManager.sharedManager.videoPlayerViewController {
            videoVC.moviePlayer.setFullscreen(true, animated: true)
        }
    }
    
    func didFavoriteButtonTapped(sender: UIButton) {
        
        sender.playBounceAnimation()
        
        if let playingStory = playingStory {
            checkFavorite(kikaku: nil, story: playingStory)
        }
        
        applyFavoriteButtonStateByPlayingKikaku()
    }
    
    func shareButtonTapped(sender:UIButton!){
        let sharedText = videoTitle
        let baseURL = "https://www.youtube.com/watch?v="
        
        let sharedURL = NSURL(string: baseURL + videoID)!
        
        var activityItems = [AnyObject]()
        
        if !videoID.isEmpty {
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
            options: [],
            animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        
        resizedVC()
    }
}