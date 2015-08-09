//
//  HistoryHeaderView.swift
//  Gaki
//
//  Created by naoyashiga on 2015/07/23.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

protocol HistoryHeaderViewDelegate {
    func reloadPage()
    func didMoreLoadButtonTapped()
}

class HistoryHeaderView: UICollectionReusableView {
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var moreLoadButton: UIButton!
    var delegate: HistoryHeaderViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func moreLoadButtonTapped(sender: UIButton) {
        delegate?.didMoreLoadButtonTapped()
    }
    
    @IBAction func reloadButtonTapped(sender: UIButton) {
        delegate?.reloadPage()
    }
}
