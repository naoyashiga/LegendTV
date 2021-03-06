//
//  UITableView+ApplyNib.swift
//  LegendTV
//
//  Created by naoyashiga on 2015/08/09.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
    public func applyCellNib(#cellNibName: String) {
        registerNib(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellNibName)
    }
}