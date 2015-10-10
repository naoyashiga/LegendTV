//
//  UICollectionView+RoppongiExtensions.swift
//  Gaki
//
//  Created by naoyashiga on 2015/07/25.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import UIKit

public extension UICollectionView {
    public func applyCellNib(cellNibName cellNibName: String) {
        registerNib(UINib(nibName: cellNibName, bundle: nil), forCellWithReuseIdentifier: cellNibName)
    }
    
    public func applyHeaderNib(headerNibName headerNibName: String) {
        registerNib(UINib(nibName: headerNibName, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerNibName)
    }
    
    public func applyFooterNib(footerNibName footerNibName: String) {
        registerNib(UINib(nibName: footerNibName, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerNibName)
    }
}