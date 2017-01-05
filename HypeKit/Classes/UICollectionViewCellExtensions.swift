//
//  UICollectionViewCellExtensions.swift
//  HypeKit
//
//  Created by Tony Heupel on 01/05/2017.
//  Copyright © 2017 Tony Heupel. All rights reserved.
//

import Foundation

extension UICollectionViewCell {
    /// To help with choppy scrolling, you can "rasterize" a cell
    /// by calling this immediately after it has been dequeued.
    /// This is currently using a rasterizationScale of the
    /// `UIScreen.mainScreen().scale` by default
    func rasterize() {
        rasterizeAtScale(UIScreen.main.scale)
    }

    /// To help with choppy scrolling, you can "rasterize" a cell
    /// by calling this immediately after it has been dequeued.
    /// - parameter scale: the scale of the containing view or screen
    func rasterizeAtScale(_ scale: CGFloat) {
        layer.shouldRasterize = true
        layer.rasterizationScale = scale
    }
}
