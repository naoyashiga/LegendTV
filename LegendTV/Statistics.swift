//
//  Statistics.swift
//  housoushitsu
//
//  Created by naoyashiga on 2015/07/04.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import SwiftyJSON

class Statistics {
    var viewCount = ""
    var likeCount = ""
    
    init(json: JSON) {
        if let viewCount = json["statistics"]["viewCount"].string {
            self.viewCount = viewCount
        }
        
        if let likeCount = json["statistics"]["likeCount"].string {
            self.likeCount = likeCount
        }
    }
}