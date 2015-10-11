//
//  SettingCollectionViewController+SNS.swift
//  LegendTV
//
//  Created by naoyashiga on 2015/08/24.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import Social

extension SettingCollectionViewController {
    
    func openAppStore(urlStr:String){
        let url = NSURL(string:urlStr)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func transitionToOtherAppPage() {
        let otherAppURL = NSLocalizedString("otherAppURL", tableName: "Setting", value: AppConstraints.otherAppURLString, comment: "")
        
        openAppStore(otherAppURL)
    }
    
    func transitionToReviewPage() {
        let reviewVC = ReviewModalViewController(nibName: "ReviewModalViewController", bundle: nil)
        reviewVC.modalPresentationStyle = .Custom
        reviewVC.transitioningDelegate = self
        view.window?.rootViewController?.presentViewController(reviewVC, animated: true, completion: nil)
    }
    
    func postToTwitter(){
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        vc.setInitialText(shareText)
        presentViewController(vc,animated:true,completion:nil)
    }
    
    func postToLINE(){
        let encodedText = shareText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let shareURL = NSURL(string: "line://msg/text/" + encodedText)
        
        if UIApplication.sharedApplication().canOpenURL(shareURL!) {
            UIApplication.sharedApplication().openURL(shareURL!)
        }
    }
}