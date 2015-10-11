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
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func transitionToReviewPage() {
        ReviewManager.updateReviewStatus()
        
        openAppStore(AppConstraints.reviewURLString)
    }
}
