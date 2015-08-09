//
//  FavoriteHeaderView.swift
//  LegendTV
//
//  Created by naoyashiga on 2015/08/09.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

protocol FavoriteHeaderViewDelegate {
    func reloadPage()
}

class FavoriteHeaderView: UICollectionReusableView {
    var delegate: FavoriteHeaderViewDelegate?
    
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func reloadButtonTapped(sender: UIButton) {
        delegate?.reloadPage()
    }
}
