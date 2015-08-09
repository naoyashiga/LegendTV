//
//  HttpService.swift
//  housoushitsu
//
//  Created by naoyashiga on 2015/06/08.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class HttpService {
    class func getJSON(url: String, callback:([JSON]) -> Void) {
        
        if let nsURL = NSURL(string: url) {
            var session = NSURLSession.sharedSession()
            
            var task = session.dataTaskWithURL(nsURL){ data, response, error in
                if error != nil{
                    println("error")
                }
                
                let json = JSON(data: data)
                if let items = json["items"].array {
                    callback(items)
                }
                
                session.invalidateAndCancel()
                
            }
            
            task.resume()
        }
    }
}