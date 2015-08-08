//
//  ReviewView.swift
//  Gaki
//
//  Created by naoyashiga on 2015/08/06.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

protocol ReviewViewDelegate {
    func transitionToReviewPage()
    func closeReview()
}

class ReviewView: UIView {
    var delegate: ReviewViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        comminInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        comminInit()
    }
    
    private func comminInit() {
        let reviewViewNibName = NSStringFromClass(ReviewView.self)
        if let view = UINib(nibName: reviewViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as? UIView {
            addSubview(view)
        }
    }
    
    @IBAction func reviewButtonTapped(sender: UIButton) {
        delegate?.transitionToReviewPage()
    }
    
    @IBAction func atodeButtonTapped(sender: UIButton) {
        delegate?.closeReview()
    }
    
    @IBAction func closeButtonTapped(sender: UIButton) {
        delegate?.closeReview()
    }
}
