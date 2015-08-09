//
//  TopViewController+ActivityIndicatorView.swift
//  LegendTV
//
//  Created by naoyashiga on 2015/08/09.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation

extension TopViewController {
    
    private func addActivityIndicatorView() {
        let frame = CGRect(x: playerView.center.x - 40 / 2, y: playerView.center.y - 20, width: 40, height: 40)
        let activityType = NVActivityIndicatorType.LineScale
        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: activityType)
        
        if let activityIndicatorView = activityIndicatorView {
            activityIndicatorView.tag = activityIndicatorViewTagNumber
            view.addSubview(activityIndicatorView)
        }
    }
    
    func startActivityIndicatorView() {
        addActivityIndicatorView()
        
        if let indicator = activityIndicatorView {
            indicator.startAnimation()
        }
    }
    
    func stopActivityIndicatorView() {
        playOrPauseButtonVerticalConstraint.constant = 14
        
        if let indicator = activityIndicatorView {
            UIView.animateWithDuration(
                0.6,
                delay: 0.1,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.0,
                options: nil,
                animations: {
                    indicator.alpha = 0
                    indicator.layer.opacity = 0
                    
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    indicator.stopAnimation()
                    indicator.removeFromSuperview()
            })
        }
    }
}