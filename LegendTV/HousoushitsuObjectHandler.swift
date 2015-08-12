//
//  HousoushitsuObjectHandler.swift
//  housoushitsu
//
//  Created by naoyashiga on 2015/06/08.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class HousoushitsuObjectHandler {
    
    class func getStories(url: String, callback:(([Story]) -> Void)){
        var stories = [Story]()
        
        HttpService.getJSON(url){ jsonItems in
            
            for item in jsonItems {
                let story = Story(json: item)
                stories.append(story)
            }
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0), { () -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    callback(stories)
                })
            })
        }
    }
}