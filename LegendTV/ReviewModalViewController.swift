//
//  ReviewModalViewController.swift
//  Gaki
//
//  Created by naoyashiga on 2015/08/06.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

class ReviewModalViewController: UIViewController, ReviewViewDelegate {
    @IBOutlet var reviewView: ReviewView!

    override func viewDidLoad() {
        super.viewDidLoad()
        reviewView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func closeReview() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func openAppStore(urlStr:String){
        let url = NSURL(string:urlStr)
        let app:UIApplication = UIApplication.sharedApplication()
        app.openURL(url!)
    }
    
    func transitionToReviewPage() {
        let APP_ID = "1025411227"
        
        let reviewURL = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=" + APP_ID
        
        ReviewManager.updateReviewStatus()
        
        openAppStore(reviewURL)
    }
    
}
