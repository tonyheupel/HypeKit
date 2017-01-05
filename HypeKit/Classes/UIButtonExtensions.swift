//
//  UIButtonExtensions.swift
//  HypeKit
//
//  Created by Tony Heupel on 01/05/2017.
//  Copyright © 2017 Tony Heupel.. All rights reserved.
//

import Foundation

extension UIButton {
    internal func putIconOnRight() {
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
}
