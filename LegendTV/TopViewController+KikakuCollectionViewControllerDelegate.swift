//
//  TopViewController+KikakuCollectionViewControllerDelegate.swift
//  LegendTV
//
//  Created by naoyashiga on 2015/08/09.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation

extension TopViewController {
    //MARK: KikakuCollectionViewControllerDelegate
    func transitionViewController(#ToVC: BaseTableViewController) {
        navigationController?.pushViewController(ToVC, animated: true)
    }
}