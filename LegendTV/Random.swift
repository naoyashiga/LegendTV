//
//  Random.swift
//  LegendTV
//
//  Created by naoyashiga on 2015/08/13.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import Darwin

extension Int {
    static func random() -> Int {
        return Int(arc4random())
    }
    
    static func random(range: Range<Int>) -> Int {
        return Int(arc4random_uniform(UInt32(range.endIndex - range.startIndex))) + range.startIndex
    }
}

extension Double {
    static func random() -> Double {
        return drand48()
    }
}

extension Array {
    /**
    * Shuffles the array elements.
    */
    mutating func shuffle() {
        if count > 1 {
            let iLast = count - 1
            for i in 0..<iLast {
                let iRandom = Int.random(i...iLast)
                let temp = self[i]
                self[i] = self[iRandom]
                self[iRandom] = temp
            }
        }
    }
    
    /**
    * Returns a copy of the array with the elements shuffled.
    */
    func shuffled() -> [Element] {
        var newArray = [Element](self)
        newArray.shuffle()
        return newArray
    }
}