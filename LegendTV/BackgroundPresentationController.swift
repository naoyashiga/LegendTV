//
//  BackgroundPresentationController.swift
//  LegendTV
//
//  Created by naoyashiga on 2015/08/24.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

class BackgroundPresentationController: UIPresentationController {
    var dimmingView: UIView!
    
    override init(presentedViewController: UIViewController!, presentingViewController: UIViewController!) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        setupDimmingView()
    }
    
    func setupDimmingView() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dimmingViewTapped:")
        dimmingView = UIView()
        dimmingView.backgroundColor = UIColor.blackColor()
        dimmingView.addGestureRecognizer(tapRecognizer)
    }
    
    func dimmingViewTapped(tapRecognizer: UITapGestureRecognizer) {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView.bounds
        
        presentedView().frame = frameOfPresentedViewInContainerView()
        presentedView().layer.borderWidth = 0.0
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        let presentedViewFrame = CGRectZero
        
        var width:CGFloat = containerView.bounds.size.width * 0.85
        var height:CGFloat = containerView.bounds.size.height  * 0.8
        
        presentedViewFrame.size = CGSizeMake(width,height)
        presentedViewFrame.origin = CGPointMake(containerView.bounds.size.width / 2.0, containerView.bounds.size.height / 2.0)
        
        presentedViewFrame.origin.x -= presentedViewFrame.size.width / 2.0;
        presentedViewFrame.origin.y -= presentedViewFrame.size.height / 2.0;
        
        return presentedViewFrame
    }
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView.bounds
        dimmingView.alpha = 0.0
        
        containerView.insertSubview(dimmingView, atIndex: 0)
        
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (context) -> Void in
            self.dimmingView.alpha = 0.8
            }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (context) -> Void in
            self.dimmingView.alpha = 0.0
            }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
}
