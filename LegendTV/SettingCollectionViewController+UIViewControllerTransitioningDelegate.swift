//
//  SettingCollectionViewController+UIViewControllerTransitioningDelegate.swift
//  LegendTV
//
//  Created by naoyashiga on 2015/08/24.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation

extension SettingCollectionViewController: UIViewControllerTransitioningDelegate {
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return BackgroundPresentationController(presentedViewController: presented, presentingViewController: self)
        
    }
}