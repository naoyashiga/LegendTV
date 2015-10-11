//
//  Color.swift
//  housoushitsu
//
//  Created by naoyashiga on 2015/06/08.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func hexStr (var hexStr : NSString, alpha : CGFloat) -> UIColor {
        hexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
        let scanner = NSScanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string", terminator: "")
            return UIColor.whiteColor();
        }
    }
    
    class func viewBackgroundColor() -> UIColor {
        return UIColor.hexStr("e5e5e5", alpha: 1)
    }
    
    class func navigationTitleColor() -> UIColor {
        return UIColor.hexStr("ffffff", alpha: 1)
    }
    
    class func navigationBackgroundColor() -> UIColor {
        return UIColor.hexStr("ffa633", alpha: 1)
    }
    
    class func tabBarItemTintColor() -> UIColor {
        return UIColor.hexStr("EF6C00", alpha: 1)
    }
    
    class func tableViewSeparatorColor() -> UIColor {
        return UIColor.hexStr("212121", alpha: 1)
    }
    
    class func cellLightBackgroundColor() -> UIColor {
        return UIColor.hexStr("ffffff", alpha: 1)
    }
    
    class func cellSelectedBackgroundColor() -> UIColor {
        return UIColor.hexStr("ffa633", alpha: 1)
    }
    
    class func kikakuTitleInPreparationColor() -> UIColor {
        return UIColor.hexStr("efefef", alpha: 1)
    }
    
    class func kikakuTitleColor() -> UIColor {
        return UIColor.hexStr("ffa633", alpha: 1)
    }
    
    class func controlBarBackgroundColor() -> UIColor {
        return UIColor.hexStr("faa01e", alpha: 1)
    }
    
    class func controlBarTextColor() -> UIColor {
        return UIColor.hexStr("ffffff", alpha: 1)
    }
    
    //MARK: Tab Color
    class func scrollMenuBackgroundColor() -> UIColor {
        return UIColor.hexStr("ffa633", alpha: 1)
    }
    
    class func selectionIndicatorColor() -> UIColor {
        return UIColor.hexStr("ffffff", alpha: 1)
    }
    
    class func bottomMenuHairlineColor() -> UIColor {
        return UIColor.hexStr("402908", alpha: 1)
    }
    
    class func selectedMenuItemLabelColor() -> UIColor {
        return UIColor.hexStr("402908", alpha: 1)
    }
    
    class func unselectedMenuItemLabelColor() -> UIColor {
        return UIColor.hexStr("ffffff", alpha: 1)
    }
}