//
//  HousoushitsuObjectHandler.swift
//  housoushitsu
//
//  Created by naoyashiga on 2015/06/08.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import UIKit

class HousoushitsuObjectHandler {
    
    class func getStories(url: String, callback:(([Story]) -> Void)){
        var stories = [Story]()
//        println(url)
        
        HttpService.getJSON(url){ jsonItems in
            
            for item in jsonItems {
//                let story = Story(data: storyData as! NSDictionary)
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
    
    class func getContentDetails(url: String, callback:(([ContentDetails]) -> Void)){
        var contentDetails = [ContentDetails]()
        
        HttpService.getJSON(url){ jsonItems in
            
            for item in jsonItems {
                let duration = ContentDetails(json: item)
                contentDetails.append(duration)
            }
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0), { () -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    callback(contentDetails)
                })
            })
        }
    }
    
    class func getStatistics(url: String, callback:(([Statistics]) -> Void)){
        var statistics = [Statistics]()
        
        HttpService.getJSON(url){ jsonItems in
            
            for item in jsonItems {
                let result = Statistics(json: item)
                statistics.append(result)
            }
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0), { () -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    callback(statistics)
                })
            })
        }
    }
}