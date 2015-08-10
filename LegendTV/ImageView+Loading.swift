//
//  ImageView+Loading.swift
//  Gaki
//
//  Created by naoyashiga on 2015/08/05.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadingImageBySDWebImage<S: Kikaku>(kikaku: S) {
        
        sd_setImageWithURL(
            NSURL(string: kikaku.thumbNailImageURL),
            completed: { image, error, type, URL in
                
                self.alpha = 0
                
                UIView.animateWithDuration(0.25,
                    animations: {
                        self.alpha = 1
                })
        })
    }
    
    func loadingStoryImageBySDWebImage(story: Story) {
        
        sd_setImageWithURL(
            NSURL(string: story.thumbNailImageURL),
            completed: { image, error, type, URL in
                
                self.alpha = 0
                
                UIView.animateWithDuration(0.25,
                    animations: {
                        self.alpha = 1
                })
        })
    }
}