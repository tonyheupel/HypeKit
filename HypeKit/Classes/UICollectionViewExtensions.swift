//
//  UICollectionViewExtensions.swift
//  HypeKit
//
//  Created by Tony Heupel on 01/05/2017.
//  Copyright © 2017 Tony Heupel.. All rights reserved.
//

import Foundation

class CellDistanceToPointResult : CustomStringConvertible {
    let point: CGPoint
    let collectionView: UICollectionView
    let cell: UICollectionViewCell


    // MARK: - Points for cell
    var cellCenter: CGPoint {
        get { return cell.center }
    }

    var cellTopLeftCorner: CGPoint {
        get { return cell.frame.origin }
    }

    var cellBottomRightCorner: CGPoint {
        get { return CGPoint(x: self.cellTopLeftCorner.x + self.cell.frame.width, y: self.cellTopLeftCorner.y + self.cell.frame.height) }
    }

    var cellTopRightCorner: CGPoint {
        get { return CGPoint(x: self.cellTopLeftCorner.x + self.cell.frame.width, y: self.cellTopLeftCorner.y) }
    }


    var cellBottomLeftCorner: CGPoint {
        get { return CGPoint(x: self.cellTopLeftCorner.x, y: self.cellTopLeftCorner.y + self.cell.frame.height) }
    }


    // MARK: - Distance From Point to Point on Cell
    var pointDistanceToCellCenter: CGFloat {
        get { return self.point.distance(to: self.cell.center) }
    }


    var pointDistanceToCellTopLeftCorner: CGFloat {
        get { return self.point.distance(to: cellTopLeftCorner) }
    }


    var pointDistanceToCellBottomRightCorner: CGFloat {
        get { return point.distance(to: self.cellBottomRightCorner) }
    }


    var pointDistanceToCellBottomLeftCorner: CGFloat {
        get { return point.distance(to: self.cellBottomLeftCorner) }
    }

    var pointDistanceToCellTopRightCorner: CGFloat {
        get { return point.distance(to: self.cellTopRightCorner) }
    }


    // MARK: - Distance From Cell Center to Cell Corners
    var cellCenterDistanceToCellTopLeftCorner: CGFloat {
        get { return self.cellCenter.distance(to: self.cellTopLeftCorner) }
    }


    var cellCenterDistanceToCellBottomRightCorner: CGFloat {
        get { return self.cellCenter.distance(to: self.cellBottomRightCorner) }
    }


    var cellCenterDistanceToCellTopRightCorner: CGFloat {
        get { return point.distance(to: self.cellTopRightCorner) }
    }


    var cellCenterDistanceToCellBottomLeftCorner: CGFloat {
        get { return self.cellCenter.distance(to: self.cellBottomLeftCorner) }
    }


    // MARK: - IndexPath
    var cellIndexPath: IndexPath? {
        get { return collectionView.indexPath(for: self.cell) }
    }

    init(collectionView: UICollectionView, cell: UICollectionViewCell, point: CGPoint) {
        self.point = point
        self.collectionView = collectionView
        self.cell = cell
    }


    var description: String {
        return "{ point: \(self.point), cell: \(self.cell), indexPath: \(self.cellIndexPath), distance to cell center: \(self.pointDistanceToCellCenter) }"
    }
}


extension UICollectionView {
    /// Calculates the width of a single column given a number of columns and the minimum space between each item.
    /// (Assumes a vertical scroll direction).
    func calculateColumnWidthForNumberOfColumns(_ columns: Int, withMinimumSpaceBetweenItems minSpace: CGFloat) -> CGFloat {
        return self.calculateColumnWidthForNumberOfColumns(columns, withMinimumSpaceBetweenItems: minSpace, withContentInsets: self.contentInset)
    }

    func calculateColumnWidthForNumberOfColumns(_ columns: Int, withMinimumSpaceBetweenItems minSpace: CGFloat, withContentInsets insets: UIEdgeInsets) -> CGFloat {
        let screenSize = self.bounds.size
        let insetWidth = insets.left + insets.right
        let availableTotalWidth = screenSize.width - insetWidth
        let width = (columns <= 1) ? availableTotalWidth : (availableTotalWidth/CGFloat(columns)) - ((minSpace/CGFloat(columns - 1))/CGFloat(columns))

        return width
    }


    /// Returns the closest visible cell's IndexPath or nil if none found.
    func indexPathForVisibleItemClosestTo(point: CGPoint) -> IndexPath? {
        return cellDistanceToPointResultForVisibleItemClosestTo(point: point)?.cellIndexPath
    }


    /// Returns the closest visible cell's IndexPath, ecluding the passed in IndexPath values, or nil if none found.
    func indexPathForVisibleItemClosestTo(point: CGPoint, excludingIndexPaths exclude: [IndexPath]) -> IndexPath? {
        return cellDistanceToPointResultForVisibleItemClosestTo(point: point, excludingIndexPaths: exclude)?.cellIndexPath
    }


    /// Returns the closest visible cell's information relative to the point, or nil if none found.
    func cellDistanceToPointResultForVisibleItemClosestTo(point: CGPoint) -> CellDistanceToPointResult? {
        return cellDistanceToPointResultForVisibleItemClosestTo(point: point, excludingIndexPaths: [IndexPath]())
    }


    /// Returns the closest visible cell's IndexPath, exluding the index paths passed in, or nil if none found.
    func cellDistanceToPointResultForVisibleItemClosestTo(point: CGPoint, excludingIndexPaths exclude: [IndexPath]) -> CellDistanceToPointResult? {
        if let indexPath = self.indexPathForItem(at: point), let cell = self.dataSource?.collectionView(self, cellForItemAt: indexPath), !exclude.contains(indexPath) {
            let result = CellDistanceToPointResult(collectionView: self, cell: cell, point: point)
            return result
        }

        var closestCellResult: CellDistanceToPointResult? = nil

        for cell in self.visibleCells {
            let currentCellInfo = CellDistanceToPointResult(collectionView: self, cell: cell, point: point)

            if let currentCellIndexPath = currentCellInfo.cellIndexPath, !exclude.contains(currentCellIndexPath) {
                let closestCellDelta = closestCellResult?.pointDistanceToCellCenter ?? CGFloat.greatestFiniteMagnitude
                let currentCellDelta = currentCellInfo.pointDistanceToCellCenter

                if currentCellDelta < closestCellDelta {
                    closestCellResult = currentCellInfo
                }
            }
        }

        return closestCellResult
    }

}
