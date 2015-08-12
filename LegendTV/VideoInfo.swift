//
//  VideoInfo.swift
//  housoushitsu
//
//  Created by naoyashiga on 2015/07/06.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class VideoInfo {
    class func getDurationTimes(videoID: String, callback:(([ContentDetails]) -> Void)) {
        let contentsDetailURL = Config.REQUEST_CONTENT_DETAILS_URL + "id=\(videoID)"
        
        Alamofire.request(.GET, contentsDetailURL).responseSwiftyJSON({ (_, _, json, error) in
            if (error != nil) {
                println("Error with registration: \(error?.localizedDescription)")
            } else {
                println("Success!")
                
                var contentDetails = [ContentDetails]()
                
                if let items = json["items"].array {
                    for item in items {
                        let duration = ContentDetails(json: item)
                        contentDetails.append(duration)
                    }
                    
                    callback(contentDetails)
                }
            }
        })
    }
    
    class func getStatistics(videoID: String, callback:(([Statistics]) -> Void)) {
        let statisticsURL = Config.REQUEST_STATISTICS_URL + "id=\(videoID)"
        
        HousoushitsuObjectHandler.getStatistics(statisticsURL){ statistics in
            callback(statistics)
        }
    }
    
    class func getDurationStr(nonFormatStr: String) -> String {
        let pH = "H"
        let pM = "M"
        let pS = "S"
        
        let pattern = "[PT|S]"
        
        let rH = "時間"
        let rM = "分"
        let rS = "秒"
        let replace = ""
        
        var replaceString = doReplace(str: nonFormatStr, pattern: pH, replaceStr: rH)
        replaceString = doReplace(str: replaceString, pattern: pM, replaceStr: rM)
        replaceString = doReplace(str: replaceString, pattern: pS, replaceStr: rS)
        replaceString = doReplace(str: replaceString, pattern: pattern, replaceStr: replace)
        
        return replaceString
    }
    
    class func doReplace(#str:String, pattern: String, replaceStr: String) -> String {
        return str.stringByReplacingOccurrencesOfString(pattern, withString: replaceStr, options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        
    }
}

// MARK: Alamofire_SwiftyJSON
extension Request {
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the SwiftyJSON enum, if one could be created from the URL response and data, and any error produced while creating the SwiftyJSON enum.
    
    :returns: The request.
    */
    public func responseSwiftyJSON(completionHandler: (NSURLRequest, NSHTTPURLResponse?, SwiftyJSON.JSON, NSError?) -> Void) -> Self {
        return responseSwiftyJSON(queue:nil, options:NSJSONReadingOptions.AllowFragments, completionHandler:completionHandler)
    }
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: queue The queue on which the completion handler is dispatched.
    :param: options The JSON serialization reading options. `.AllowFragments` by default.
    :param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the SwiftyJSON enum, if one could be created from the URL response and data, and any error produced while creating the SwiftyJSON enum.
    
    :returns: The request.
    */
    public func responseSwiftyJSON(queue: dispatch_queue_t? = nil, options: NSJSONReadingOptions = .AllowFragments, completionHandler: (NSURLRequest, NSHTTPURLResponse?, JSON, NSError?) -> Void) -> Self {
        
        return response(queue: queue, responseSerializer: Request.JSONResponseSerializer(options: options), completionHandler: { (request, response, object, error) -> Void in
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                var responseJSON: JSON
                if error != nil || object == nil{
                    responseJSON = JSON.nullJSON
                } else {
                    responseJSON = SwiftyJSON.JSON(object!)
                }
                
                dispatch_async(queue ?? dispatch_get_main_queue(), {
                    completionHandler(self.request, self.response, responseJSON, error)
                })
            })
        })
    }
}

