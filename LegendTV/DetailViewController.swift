//
//  DetailViewController.swift
//  housoushitsu
//
//  Created by naoyashiga on 2015/06/11.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {
    @IBOutlet weak var playerView: UIView!
    var videoId = ""
    var videoTitle = ""
    var videoThunmNailImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackButton()
        
        //TODO 読み込み失敗したときの対応
        setPlayControlBar()
    }
    
    override func viewWillDisappear(animated: Bool) {
        println(VideoPlayManager.sharedManager.videoPlayerViewController?.moviePlayer.initialPlaybackTime)
        VideoPlayManager.sharedManager.playerView = playerView
    }
    
    func setPlayControlBar() {
        let playControlBarView = PlayControlBar.sharedManager
        //TODO control barから戻れるようにする
        //TODO 再生してる感じを出す　タイトルが動く
        
        //幅は要調整
        playControlBarView.frame = CGRect(
            x: 0,
            y: view.frame.height - PlayControlBar.height + UIApplication.sharedApplication().statusBarFrame.height,
            width: view.frame.width * 0.63,
            height: PlayControlBar.height
        )
        
        playControlBarView.setProperty(thumbNailImageView: videoThunmNailImageView, kikakuName: videoTitle, seriesName: "世界のヘイポーシリーズ")
//        playControlBarView.setProperty(thumbNailImageView: videoThunmNailImageView, kikakuName: videoTitle, seriesName: "世界のヘイポーシリーズ", playingView: playerView)
        view.addSubview(playControlBarView)
    }
    
    func setBackButton() {
        let backButton = UIBarButtonItem(title: "< 戻る", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: FontSet.medium, size: 15)!], forState: .Normal)
    }
    
    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }

    override func viewDidAppear(animated: Bool) {
        
        if let videoVC = VideoPlayManager.sharedManager.videoPlayerViewController {
            playerView = VideoPlayManager.sharedManager.playerView
        } else {
            VideoPlayManager.sharedManager.setVideoPlayer(videoID: videoId, playerView: playerView)
            VideoPlayManager.sharedManager.setPlayingInfo(title: videoTitle, artWorkImage: videoThunmNailImageView.image)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
