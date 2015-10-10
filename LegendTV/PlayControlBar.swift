//
//  PlayControlBar.swift
//  Gaki
//
//  Created by naoyashiga on 2015/07/19.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

struct PlayControlBarImage {
    static let play = "play.png"
    static let pause = "pause.png"
}

class PlayControlBar: UIView {
    static var thumbNailImageView = UIImageView()
    static var kikakuNameLabel = UILabel()
    static var seriesNameLabel = UILabel()
    static var playOrPauseButton = UIButton(type: UIButtonType.System)
    
    static var playingView = UIView()
    
    static let height: CGFloat = 60
    static let sharedManager = PlayControlBar()
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        PlayControlBar.thumbNailImageView.translatesAutoresizingMaskIntoConstraints = false
        PlayControlBar.kikakuNameLabel.translatesAutoresizingMaskIntoConstraints = false
        PlayControlBar.seriesNameLabel.translatesAutoresizingMaskIntoConstraints = false
        PlayControlBar.playOrPauseButton.translatesAutoresizingMaskIntoConstraints = false
        
        PlayControlBar.playOrPauseButton.tintColor = UIColor.clearColor()
        PlayControlBar.playOrPauseButton.addTarget(self, action: "playOrPauseButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        PlayControlBar.playOrPauseButton.setBackgroundImage(UIImage(named: PlayControlBarImage.pause), forState: UIControlState.Normal)
        
        PlayControlBar.kikakuNameLabel.font = UIFont(name: FontSet.medium, size: 15)
        PlayControlBar.seriesNameLabel.font = UIFont(name: FontSet.light, size: 12.0)
        
        PlayControlBar.kikakuNameLabel.textColor = UIColor.controlBarTextColor()
        PlayControlBar.seriesNameLabel.textColor = UIColor.controlBarTextColor()
        
        backgroundColor = UIColor.controlBarBackgroundColor()
        
        addSubview(PlayControlBar.seriesNameLabel)
        addSubview(PlayControlBar.kikakuNameLabel)
        addSubview(PlayControlBar.thumbNailImageView)
        addSubview(PlayControlBar.playOrPauseButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func setProperty(thumbNailImageView thumbNailImageView: UIImageView,kikakuName: String, seriesName: String) {
        
        PlayControlBar.thumbNailImageView.image = thumbNailImageView.image
        PlayControlBar.kikakuNameLabel.text = kikakuName
        PlayControlBar.seriesNameLabel.text = seriesName
        
        addConstraints(setThumbNailImageViewContraints() + setKikakuNameLabelContraints() + setSeriesNameLabelContraints() + setPlayOrPauseButtonContraints())
    }
    
    private func playOrPauseButtonTapped() {
        
        if let videoVC = VideoPlayManager.sharedManager.videoPlayerViewController {
            switch videoVC.moviePlayer.playbackState {
            case .Paused,.Stopped:
                videoVC.moviePlayer.play()
                break
            case .Playing:
                videoVC.moviePlayer.pause()
                break
            default:
                break
            }
        }
    }
    
    private func setPlayingViewConstraints() -> [NSLayoutConstraint] {
        let marginTop: CGFloat = 0
        let marginBottom: CGFloat = 0
        let marginLeft: CGFloat = 0
        let imageWidth: CGFloat = 60
        
        let top = NSLayoutConstraint(
            item: PlayControlBar.playingView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Top,
            multiplier: 1.0,
            constant: marginTop
        )
        
        let bottom = NSLayoutConstraint(
            item: self,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: PlayControlBar.playingView,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: marginBottom
        )
        
        let left = NSLayoutConstraint(
            item: PlayControlBar.playingView,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Left,
            multiplier: 1.0,
            constant: marginLeft
        )
        
        let width = NSLayoutConstraint(
            item: PlayControlBar.playingView,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .Width,
            multiplier: 1.0,
            constant: imageWidth
        )
        
        return [top, left, bottom, width]
    }
    
    private func setThumbNailImageViewContraints() -> [NSLayoutConstraint] {
        let marginTop: CGFloat = 0
        let marginBottom: CGFloat = 0
        let marginLeft: CGFloat = 0
        let imageWidth: CGFloat = 60
        
        let top = NSLayoutConstraint(
            item: PlayControlBar.thumbNailImageView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Top,
            multiplier: 1.0,
            constant: marginTop
        )
        
        let bottom = NSLayoutConstraint(
            item: self,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: PlayControlBar.thumbNailImageView,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: marginBottom
        )
        
        let left = NSLayoutConstraint(
            item: PlayControlBar.thumbNailImageView,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Left,
            multiplier: 1.0,
            constant: marginLeft
        )
        
        let width = NSLayoutConstraint(
            item: PlayControlBar.thumbNailImageView,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .Width,
            multiplier: 1.0,
            constant: imageWidth
        )
        
        return [top, left, bottom, width]
    }
    
    private func setKikakuNameLabelContraints() -> [NSLayoutConstraint] {
        let marginTop: CGFloat = 10.0
        let marginLeft: CGFloat = 8.0
        let marginRight: CGFloat = 8.0
        
        let top = NSLayoutConstraint(
            item: PlayControlBar.kikakuNameLabel,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Top,
            multiplier: 1.0,
            constant: marginTop
        )
        
        let left = NSLayoutConstraint(
            item: PlayControlBar.kikakuNameLabel,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: PlayControlBar.thumbNailImageView,
            attribute: .Right,
            multiplier: 1.0,
            constant: marginLeft
        )
        
        return [top, left]
    }
    
    private func setSeriesNameLabelContraints() -> [NSLayoutConstraint] {
        let marginTop: CGFloat = 33.0
        let marginLeft: CGFloat = 8.0
        let marginRight: CGFloat = 8.0
        
        let top = NSLayoutConstraint(
            item: PlayControlBar.seriesNameLabel,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Top,
            multiplier: 1.0,
            constant: marginTop
        )
        
        let left = NSLayoutConstraint(
            item: PlayControlBar.seriesNameLabel,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: PlayControlBar.thumbNailImageView,
            attribute: .Right,
            multiplier: 1.0,
            constant: marginLeft
        )
        
        return [top, left]
    }
    
    private func setPlayOrPauseButtonContraints() -> [NSLayoutConstraint] {
        let marginTop: CGFloat = 13.0
        let marginLeft: CGFloat = 4.0
        let marginRight: CGFloat = 16.0
        let marginBottom: CGFloat = 7.0
        let imageWidth: CGFloat = 35
        let imageHeight: CGFloat = 35
        
        let top = NSLayoutConstraint(
            item: PlayControlBar.playOrPauseButton,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Top,
            multiplier: 1.0,
            constant: marginTop
        )
        
        let bottom = NSLayoutConstraint(
            item: PlayControlBar.playOrPauseButton,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: marginBottom
        )
        
        let left = NSLayoutConstraint(
            item: PlayControlBar.playOrPauseButton,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: PlayControlBar.kikakuNameLabel,
            attribute: .Right,
            multiplier: 1.0,
            constant: marginLeft
        )
        
        let left2 = NSLayoutConstraint(
            item: PlayControlBar.playOrPauseButton,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: PlayControlBar.seriesNameLabel,
            attribute: .Right,
            multiplier: 1.0,
            constant: marginLeft
        )
        
        let right = NSLayoutConstraint(
            item: self,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: PlayControlBar.playOrPauseButton,
            attribute: .Right,
            multiplier: 1.0,
            constant: marginRight
        )
        
        let width = NSLayoutConstraint(
            item: PlayControlBar.playOrPauseButton,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .Width,
            multiplier: 1.0,
            constant: imageWidth
        )
        
        let height = NSLayoutConstraint(
            item: PlayControlBar.playOrPauseButton,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .Height,
            multiplier: 1.0,
            constant: imageHeight
        )
        
        return [top, left, left2, right, width, height]
    }
}
