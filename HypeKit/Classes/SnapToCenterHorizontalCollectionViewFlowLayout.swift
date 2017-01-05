//
//  SnapToCenterHorizontalCollectionViewFlowLayout.swift
//  HypeKit
//
//  Created by Tony Heupel on 01/05/2017.
//  Copyright © 2017 Tony Heupel.. All rights reserved.
//

import Foundation

protocol SnapToCenterHorizontalCollectionViewFlowLayoutDelegate {
    func targetingIndexPath(_ indexPath: IndexPath)
}

class SnapToCenterHorizontalCollectionViewFlowLayout: UICollectionViewFlowLayout {
    internal var snapToCenterDelegate: SnapToCenterHorizontalCollectionViewFlowLayoutDelegate? = nil

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let layout = self

        if let collectionView = layout.collectionView {
            let point = proposedContentOffset
            let destinationRect = CGRect(x: point.x, y: point.y, width: collectionView.frame.width, height: collectionView.frame.height)
            let willBeVisibleItemsLayoutAttributes: [UICollectionViewLayoutAttributes]? = layout.layoutAttributesForElements(in: destinationRect)
            var centersByIndexPath = [IndexPath: CGPoint]()

            willBeVisibleItemsLayoutAttributes?.forEach {
                centersByIndexPath[$0.indexPath] = $0.center
            }

            let centerOfScrollViewAsContentOffset = CGPoint(x: (collectionView.frame.width / 2.0) + point.x, y: collectionView.frame.height / 2)
            let closestToCenterIndexPath = centersByIndexPath.keys.reduce(IndexPath(row: collectionView.numberOfItems(inSection: 0), section: 0)) {
                let zeroValue = centersByIndexPath[$0] ?? CGPoint(x: CGFloat.greatestFiniteMagnitude, y: CGFloat.greatestFiniteMagnitude)
                let oneValue = centersByIndexPath[$1] ?? CGPoint(x: CGFloat.greatestFiniteMagnitude, y: CGFloat.greatestFiniteMagnitude)
                return (zeroValue.distance(to: centerOfScrollViewAsContentOffset) < oneValue.distance(to: centerOfScrollViewAsContentOffset)) ? $0 : $1
            }


            if let stcd = snapToCenterDelegate {
                stcd.targetingIndexPath(closestToCenterIndexPath)
            }

            if let itemToSnapToLayoutAttributes = layout.layoutAttributesForItem(at: closestToCenterIndexPath) {
                let offsetXAdjustment = itemToSnapToLayoutAttributes.center.x - centerOfScrollViewAsContentOffset.x
                let finalContentOffset = CGPoint(x: point.x + offsetXAdjustment, y: point.y)

                return finalContentOffset
            }
        }

        return proposedContentOffset
    }
}
