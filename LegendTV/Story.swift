//
//  Story.swift
//  housoushitsu
//
//  Created by naoyashiga on 2015/06/08.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import SwiftyJSON

class Story {
    var title = ""
    var thumbNailImageURL = ""
    var videoID = ""
    var seriesName = ""
    
    init(json: JSON) {
        
        if let title = json["snippet"]["title"].string {
            self.title = title
        }
    
        if let thumbNailImageURL = json["snippet"]["thumbnails"]["default"]["url"].string {
            self.thumbNailImageURL = thumbNailImageURL
        }
        
        if let videoID = json["id"]["videoId"].string {
            self.videoID = videoID
        }
    }
}