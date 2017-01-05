//
//  CGPointExtensions.swift
//  HypeKit
//
//  Created by Tony Heupel on 01/05/2017.
//  Copyright © Tony Heupel.  All Rights Reserved.
//

import Foundation

public extension CGPoint {

    public func distance(to: CGPoint) -> CGFloat {
        return sqrt(self.distanceSquared(to: to))
    }

    fileprivate func distanceSquared(to: CGPoint) -> CGFloat {
        return (self.x - to.x) * (self.x - to.x) + (self.y - to.y) * (self.y - to.y)
    }
}
