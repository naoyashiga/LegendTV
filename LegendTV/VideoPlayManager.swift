//
//  VideoPlayManager.swift
//  Gaki
//
//  Created by naoyashiga on 2015/07/19.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import XCDYouTubeKit

protocol VideoPlayManagerDelegate {
    func videoPlayerDidChangeState(note: NSNotification)
}

class VideoPlayManager: NSObject {
    
    static let sharedManager = VideoPlayManager()
    var videoPlayerViewController: XCDYouTubeVideoPlayerViewController?
    var smallVideoPlayerViewController: XCDYouTubeVideoPlayerViewController?
    
    var playerView = UIView()
    
    var delegate: VideoPlayManagerDelegate?
    
    override init() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        do {
            try audioSession.setActive(true)
        } catch _ {
        }
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    func setVideoPlayer(videoID videoID: String, playerView: UIView) {
        videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: videoID)
        
        videoPlayerViewController!.moviePlayer.backgroundPlaybackEnabled = true
        videoPlayerViewController!.presentInView(playerView)
        videoPlayerViewController!.moviePlayer.controlStyle = MPMovieControlStyle.Embedded
        videoPlayerViewController!.moviePlayer.play()
        
//        videoPlayerViewController!.moviePlayer.prepareToPlay()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayerDidChangeState:", name: MPMoviePlayerPlaybackStateDidChangeNotification, object: videoPlayerViewController!.moviePlayer)
    }
    
    func moviePlayerDidChangeState(note: NSNotification) {
        delegate?.videoPlayerDidChangeState(note)
    }
    
    func setPlayingInfo(title title: String, artWorkImage: UIImage?) {
        let artistName = "ガキの使いやあらへんで!"
        if let artWorkImage = artWorkImage {
            
            let albumArt = MPMediaItemArtwork(image: artWorkImage)
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [MPMediaItemPropertyArtist : artistName,  MPMediaItemPropertyTitle : title, MPMediaItemPropertyArtwork : albumArt]
        } else {
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [MPMediaItemPropertyArtist : artistName,  MPMediaItemPropertyTitle : title]
        }
    }
    
    func remoteControlReceivedWithEvent(event: UIEvent) {
        
        if event.type == UIEventType.RemoteControl {
            switch event.subtype {
            case .RemoteControlPlay:
                videoPlayerViewController?.moviePlayer.play()
            case .RemoteControlPause:
                videoPlayerViewController?.moviePlayer.pause()
            case .RemoteControlTogglePlayPause:
                break
            default:
                break
            }
        }
    }
}
