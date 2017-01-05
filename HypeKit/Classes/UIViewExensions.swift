//
//  UIViewExensions.swift
//  HypeKit
//
//  Created by Tony Heupel on 01/05/2017.
//  Copyright © 2017 Tony Heupel. All rights reserved.
//

import Foundation

extension UIView {
    
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    func bindFrameToSuperviewBounds() {
        // From: http://stackoverflow.com/questions/18756640/width-and-height-equal-to-its-superview-using-autolayout-programmatically
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["subview": self]))
    }

    
    /// Allows programmatic embedding of a view controller without using an embed segue.  Great for when the UIViewController you
    /// want to embed is in another storyboard (or is not in a storyboard at all).
    func embedViewController(_ viewController: UIViewController, andSetParentViewControllerAs parentViewController: UIViewController) {
        embedViewController(viewController, andSetParentViewControllerAs: parentViewController, insertAtSubviewIndex: nil)
    }

    func embedViewController(_ viewController: UIViewController, andSetParentViewControllerAs parentViewController: UIViewController, insertAtSubviewIndex index: Int?) {
        //viewController.willMoveToParentViewController(parentViewController)

        parentViewController.addChildViewController(viewController)
        if let i = index {
            self.insertSubview(viewController.view, at: i)
        } else {
            self.addSubview(viewController.view)
        }

        viewController.didMove(toParentViewController: parentViewController)

        viewController.view.bindFrameToSuperviewBounds()
    }

    /// Makes the current view a circle.  Requires that the view has equal width and height, otherwise it does nothing
    func makeCircle() {
        DispatchQueue.main.async {
            let width = self.bounds.width
            let height = self.bounds.height

            if abs(width - height) > 0.01 {  // Allow for tolerance in CGFloat
                return // DO NOTHING  // TODO: Throw an exception?
            }

            self.makeRounded(cornerRadius: width / 2.0)
        }
    }


    /// Makes the current view have rounded corners of the specified corner radius.
    func makeRounded(cornerRadius: CGFloat = 6) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }

    /// Adds a shadow to the view
    func applyShadowWithColor(_ color: CGColor, withOffsetSize offset: CGSize, andRadius radius: CGFloat, atOpacity opacity: CGFloat) {
        let layer = self.layer

        layer.shadowColor = color
        layer.shadowOffset = offset
        layer.shadowOpacity = Float(opacity)
        layer.shadowRadius = radius
    }


    /// Removes the shadow from the view
    func removeShadow() {
        let layer = self.layer

        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
    }


    /// If the user taps anywhere in the view, end editing with text fields, etc. within the view.
    /// - returns: the UIGestureRecognizer that was added to the view
    func hideKeyboardWhenTappedAround() -> UIGestureRecognizer {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tap)

        return tap
    }

    /// Used by `hideKeyboardWhenTappedAround` to dismiss the keyboard
    func dismissKeyboard() {
        endEditing(true)
    }

    /// Adds a constraint to center the view relative to the superview
    func centerInSuperview() {
        self.centerHorizontallyInSuperview()
        self.centerVerticallyInSuperview()
    }

    /// Adds a constraint to center the view horizontally relative to the superview
    func centerHorizontallyInSuperview(){
        if let sv = self.superview {
            let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: sv, attribute: .centerX, multiplier: 1, constant: 0)
            sv.addConstraint(c)
        }
    }

    /// Adds a constraint to center the view vertically relative to the superview
    func centerVerticallyInSuperview(){
        if let sv = self.superview {
            let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: sv, attribute: .centerY, multiplier: 1, constant: 0)
            sv.addConstraint(c)
        }
    }


    /// Print the entire UIView heirarchy starting with current view as the base
    func printSubviewsOfView() {
        let subviews = self.subviews

        for subview in subviews {
            print("\(subview)")

            subview.printSubviewsOfView()
        }
    }


    /// Take a screenshot of the view and return the image
    func screenshotImage() -> UIImage? {
        //Create the UIImage
        UIGraphicsBeginImageContextWithOptions(self.frame.size, true, 0.0) // 0.0 uses the main screen resolution scale

        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return image
        }

        UIGraphicsEndImageContext()

        return nil
    }

    
    /// Take a screenshot of the view and return the image, optionally saving it to the photo alubum
    func screenshotImageAndSaveToPhotos(_ saveToPhotos: Bool) -> UIImage? {
        if let image = self.screenshotImage() , saveToPhotos {
            //Save it to the camera roll
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

            return image
        }

        return nil
    }
}
