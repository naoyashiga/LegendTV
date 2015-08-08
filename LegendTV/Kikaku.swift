//
//  Kikaku.swift
//  Gaki
//
//  Created by naoyashiga on 2015/07/25.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import RealmSwift

class Kikaku: Object {
    dynamic var videoID = ""
    dynamic var kikakuName = ""
    dynamic var seriesName = ""
    dynamic var thumbNailImageURL = ""
    
    dynamic var duration = ""
    dynamic var viewCount = ""
    dynamic var likeCount = ""
    
    dynamic var createdAt:Double = 0
    
    override static func primaryKey() -> String? {
        return "videoID"
    }
}