//
//  ContentDetails.swift
//  housoushitsu
//
//  Created by naoyashiga on 2015/07/04.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import SwiftyJSON

class ContentDetails {
    var duration = ""
    
    init(json: JSON) {
        
        if let duration = json["contentDetails"]["duration"].string {
            self.duration = duration
            
        }
    }
}