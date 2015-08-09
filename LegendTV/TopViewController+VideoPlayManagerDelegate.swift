//
//  TopViewController+VideoPlayManagerDelegate.swift
//  LegendTV
//
//  Created by naoyashiga on 2015/08/09.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation

extension TopViewController: VideoPlayManagerDelegate {

    func videoPlayerDidChangeState(note: NSNotification) {
        checkVideoPlayerState()
    }
    
    func checkVideoPlayerState() {
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