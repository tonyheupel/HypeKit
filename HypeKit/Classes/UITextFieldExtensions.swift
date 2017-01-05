//
//  TextFieldExtensions.swift
//  HypeKit
//
//  Created by Tony Heupel on 01/05/2017.
//  Copyright © 2017 Tony Heupel.. All rights reserved.
//

import Foundation

extension UITextField {
    func setLeftViewImage(_ image: UIImage) {
        setLeftViewImage(image, withSize: CGSize(width: 20, height: 20), andPadding: 8, andTintColor: nil)
    }

    func setLeftViewImage(_ image: UIImage, withTintColor tintColor: UIColor) {
        setLeftViewImage(image, withSize: CGSize(width: 20, height: 20), andPadding: 8, andTintColor: tintColor)
    }

    func setLeftViewImage(_ image: UIImage, withPadding padding: CGFloat, andTintColor tintColor: UIColor) {
        setLeftViewImage(image, withSize: CGSize(width: 20, height: 20), andPadding: padding, andTintColor: tintColor)
    }

    func setLeftViewImage(_ image: UIImage, withSize size: CGSize, andPadding padding: CGFloat, andTintColor tintColor: UIColor?) {
        let imageView = UIImageView.init(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: size.width, height: size.height)

        let containerView = createContainerViewForImageWithSize(size, andPadding: padding)
        containerView.addSubview(imageView)

        self.leftView = containerView

        if let tc = tintColor {
            imageView.tintColor = tc
        }
    }

    fileprivate func createContainerViewForImageWithSize(_ size: CGSize, andPadding padding: CGFloat) -> UIView {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: size.width + (padding * 2.0), height: size.height)
        return containerView
    }
}
