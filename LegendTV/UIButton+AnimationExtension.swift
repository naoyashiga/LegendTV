//
//  UIButton+AnimationExtension.swift
//  Gaki
//
//  Created by naoyashiga on 2015/08/03.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func playBounceAnimation() {

        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = NSTimeInterval(0.5)
        bounceAnimation.calculationMode = kCAAnimationCubic

        layer.addAnimation(bounceAnimation, forKey: "bounceAnimation")
    }
}