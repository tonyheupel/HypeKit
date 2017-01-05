//
//  StackedCollectionViewLayout.swift
//  HypeKit
//
//  Created by Tony Heupel on 01/05/2017.
//  Copyright © 2017 Tony Heupel.. All rights reserved.
//

import Foundation

protocol StackedCollectionViewLayoutDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath:IndexPath, withWidth:CGFloat) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layoutAttributesForCellAtIndexPath indexPath: IndexPath, withFrame: CGRect) -> UICollectionViewLayoutAttributes

    func collectionView(_ collectionView: UICollectionView, collectionViewLayout layout: UICollectionViewLayout, referenceSizeForHeaderInSection section :Int) -> CGSize
    func layoutAttributesForSupplementaryViewOfKind(_ elementKind: String, atIndexPath indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
}


class StackedCollectionViewLayout: UICollectionViewFlowLayout {

    // MARK: - Properties
    var delegate: StackedCollectionViewLayoutDelegate?

    var numberOfColumns = 2
    var spaceBetweenCellsOnSameLine: CGFloat = 8
    var spaceBetweenLines: CGFloat = 8
    var spaceBetweenHeaderAndResults: CGFloat = 8

    var defaultCellHeight: CGFloat = 100
    var customLayoutAttributesClass: AnyClass? = nil

    let indexPathItemForHeader = 0
    let indexPathItemForFooter = 0

    // MARK: - Private properties
    fileprivate var layoutAttributesCache = [IndexPath: UICollectionViewLayoutAttributes]()
    fileprivate var headerLayoutAttributesCache = [IndexPath: UICollectionViewLayoutAttributes]()

    fileprivate var contentWidth: CGFloat = 0.0
    fileprivate var contentHeight: CGFloat = 0.0

    // MARK: - Overrides - Instance
    override var collectionViewContentSize : CGSize {
        // These are calculated in prepareLayout
        return CGSize(width: contentWidth, height: contentHeight)
    }


    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesCache[indexPath]
    }


    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == UICollectionElementKindSectionHeader {
            return headerLayoutAttributesCache[indexPath]
        }

        return nil
    }


    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // The cache is populated as part of prepareLayout
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        var allLayoutAttributes: Array<UICollectionViewLayoutAttributes> = Array(layoutAttributesCache.values)
        allLayoutAttributes.append(contentsOf: headerLayoutAttributesCache.values)

        for attributes in allLayoutAttributes {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }

        return layoutAttributes
    }


    override func prepare() {
        // Specifically only check the cell layout attributes cache and not
        // the header and footers since the results determine whether there
        // are any headers and footers
        if !layoutAttributesCache.isEmpty {
            return
        }

        calculateLayoutAttributes()
    }

    override func invalidateLayout() {
        super.invalidateLayout()
        layoutAttributesCache.removeAll()
        headerLayoutAttributesCache.removeAll()
    }

    // MARK: - Private helpers
    fileprivate func calculateXOffsetsWithLeftInset(_ leftInset: CGFloat, andColumnWidth columnWidth: CGFloat) -> [CGFloat] {
        var offsets = [CGFloat]()

        for columnIndex in 0..<numberOfColumns {
            offsets.append(CGFloat(columnIndex) * (columnWidth + CGFloat(spaceBetweenCellsOnSameLine)))
        }

        return offsets
    }

    fileprivate func calculateLayoutAttributes() {
        let insets = collectionView!.contentInset
        contentWidth = (collectionView!.bounds.width - (insets.left + insets.right))
        contentHeight = 0

        let columnWidth = (contentWidth - (CGFloat(numberOfColumns - 1) * spaceBetweenCellsOnSameLine)) / CGFloat(numberOfColumns)

        var xOffsets = calculateXOffsetsWithLeftInset(insets.left, andColumnWidth: columnWidth)

        let numberOfSections = collectionView?.numberOfSections ?? 0

        var needSpaceBetweenLines = false

        for sectionIndex in 0..<numberOfSections {

            var headerSize = CGSize.zero
            if let d = delegate {
                headerSize = d.collectionView(self.collectionView!, collectionViewLayout: self, referenceSizeForHeaderInSection: sectionIndex)

                if headerSize.height > 0 || headerSize.width > 0 {
                    let indexPathForSectionHeader = IndexPath(item: indexPathItemForHeader, section: sectionIndex)

                    if let headerAttributes = d.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: indexPathForSectionHeader) {
                        // Adjust the origin.y value to account for where this WILL be:
                        headerAttributes.frame = CGRect(origin: CGPoint(x: headerAttributes.frame.origin.x, y: contentHeight), size: headerAttributes.frame.size)
                        headerLayoutAttributesCache[indexPathForSectionHeader] = headerAttributes
                        contentHeight += headerAttributes.bounds.height + spaceBetweenHeaderAndResults

                        needSpaceBetweenLines = true
                    }
                }
            }

            var yOffsets = [CGFloat](repeating: contentHeight, count: numberOfColumns)

            var columnIndex = 0

            let numberOfItemsInCurrentSection = collectionView?.numberOfItems(inSection: sectionIndex) ?? 0
            for itemIndex in 0..<numberOfItemsInCurrentSection {
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)

                let width = columnWidth
                var innerContentHeight: CGFloat {
                    if let d = delegate {
                        return d.collectionView(collectionView!, heightForCellAtIndexPath: indexPath, withWidth: width)
                    }

                    return defaultCellHeight
                }

                let height = innerContentHeight
                let cellFrame = CGRect(x: xOffsets[columnIndex], y: yOffsets[columnIndex], width: columnWidth, height: height)

                var attributes: UICollectionViewLayoutAttributes? = nil

                if let d = delegate {
                    attributes = d.collectionView(collectionView!, layoutAttributesForCellAtIndexPath: indexPath, withFrame: cellFrame)
                } else {
                    attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes!.frame = cellFrame
                }

                layoutAttributesCache[indexPath] = attributes!


                contentHeight = max(contentHeight, cellFrame.maxY)
                yOffsets[columnIndex] = yOffsets[columnIndex] + height + spaceBetweenLines


                columnIndex = calculateNextColumnIndexBasedOnCurrentYOffsets(yOffsets)

                needSpaceBetweenLines = true
            }

            // Make sure that as we start a new section, we retain our margin between lines
            if needSpaceBetweenLines {
                contentHeight += spaceBetweenLines
            }
        }

        contentHeight += insets.bottom
    }

    fileprivate func calculateNextColumnIndexBasedOnCurrentYOffsets(_ yOffsets: [CGFloat]) -> Int {
        // Return the column that has the top-most offset to fill that in next
        var minOffset = CGFloat.greatestFiniteMagnitude
        var minOffsetIndex = 0
        for (index, offset) in yOffsets.enumerated() {
            if offset < minOffset {
                minOffsetIndex = index
                minOffset = offset
            }
        }

        return minOffsetIndex
    }
}
