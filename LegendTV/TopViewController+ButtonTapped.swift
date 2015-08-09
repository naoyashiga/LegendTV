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

    func shareButtonTapped(sender:UIButton!){
        var sharedText = videoTitle
        let baseURL = "https://www.youtube.com/watch?v="
        var sharedURL = NSURL(string: baseURL + videoID)!
        
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
            options: nil,
            animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        
        resizedVC()
    }
}