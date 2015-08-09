//
//  TopViewController+Settings.swift
//  Gaki
//
//  Created by naoyashiga on 2015/08/01.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation

extension TopViewController {
    func resizedVC() {
        if let navVC = childViewControllers.first as? UINavigationController {
            if let containerVC = navVC.childViewControllers.first as? ContainerViewController {
                let navHeight: CGFloat = 44
                let menuHeight: CGFloat = 30
                let controlBarHeight: CGFloat = 60
                
                let resizedHeight: CGFloat = view.frame.size.height - playerView.frame.height - controlBarHeight - navHeight - menuHeight
                
                if let homeVC = containerVC.controllerArray[0] as? HomeCollectionViewController {
                    homeVC.collectionView?.frame.size.height = resizedHeight
                }
                
                if let kikakuVC = containerVC.controllerArray[1] as? KikakuCollectionViewController {
                    kikakuVC.collectionView?.frame.size.height = resizedHeight
                }
                
                if let favVC = containerVC.controllerArray[2] as? FavoriteCollectionViewController {
                    favVC.collectionView?.frame.size.height = resizedHeight
                }
                
                if let historyVC = containerVC.controllerArray[3] as? HistoryCollectionViewController {
                    historyVC.collectionView?.frame.size.height = resizedHeight
                }
            }
        }
    }
    
    func applyChildVCDelegate() {
        if let navVC = childViewControllers.first as? UINavigationController {
            if let containerVC = navVC.childViewControllers.first as? ContainerViewController {
                let navHeight: CGFloat = 44
                let menuHeight: CGFloat = 30
                let resizedHeight: CGFloat = view.frame.size.height - navHeight - menuHeight
                
                if let homeVC = containerVC.controllerArray[0] as? HomeCollectionViewController {
                    homeVC.delegate = self
                    homeVC.collectionView?.frame.size.height = resizedHeight
                }
                
                if let kikakuVC = containerVC.controllerArray[1] as? KikakuCollectionViewController {
                    kikakuVC.delegate = self
                    kikakuVC.collectionView?.frame.size.height = resizedHeight
                }
                
                if let favVC = containerVC.controllerArray[2] as? FavoriteCollectionViewController {
                    favVC.delegate = self
                    favVC.collectionView?.frame.size.height = resizedHeight
                }
                
                if let historyVC = containerVC.controllerArray[3] as? HistoryCollectionViewController {
                    historyVC.delegate = self
                    historyVC.collectionView?.frame.size.height = resizedHeight
                }
                
                let videoCollectionVC = VideoCollectionViewController()
                videoCollectionVC.delegate = self
            }
        }
    }
    
    func addFoldVideoControlButton() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        
        let foldVideoControlButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        foldVideoControlButton.frame = CGRectMake(0, 0, 40, 40)
        foldVideoControlButton.setImage(UIImage(named:ButtonSet.foldVideo), forState: UIControlState.Normal)
        foldVideoControlButton.setImage(UIImage(named:ButtonSet.unfoldVideo), forState: UIControlState.Selected)
        foldVideoControlButton.tintColor = UIColor.whiteColor()
        
        foldVideoControlButton.selected = false
        
        foldVideoControlButton.addTarget(self, action: "foldVideoControlButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem(customView: foldVideoControlButton)
        
        navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
    }
    
    func addShareButton() {
        navigationItem.rightBarButtonItem = nil
        
        let shareButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        shareButton.frame = CGRectMake(0, 0, 40, 40)
        shareButton.setImage(UIImage(named:ButtonSet.share), forState: UIControlState.Normal)
        shareButton.tintColor = UIColor.whiteColor()
        
        shareButton.addTarget(self, action: "shareButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightBarButtonItem = UIBarButtonItem(customView: shareButton)
        
        navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: true)
    }
}