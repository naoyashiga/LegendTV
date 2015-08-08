//
//  DeviceUtils.swift
//  Gaki
//
//  Created by naoyashiga on 2015/08/05.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation

func iOSDevice() -> String {
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
        if 1.0 < UIScreen.mainScreen().scale {
            let size = UIScreen.mainScreen().bounds.size
            let scale = UIScreen.mainScreen().scale
            let result = CGSizeMake(size.width * scale, size.height * scale)
            switch result.height {
            case 960:
                return "4"
            case 1136:
                return "5"
            case 1334:
                return "6"
            case 2208:
                return "6Plus"
            default:
                return "unknown"
            }
        } else {
            return "iPhone3"
        }
    } else {
        if 1.0 < UIScreen.mainScreen().scale {
            return "iPad Retina"
        } else {
            return "iPad"
        }
    }
}