//
//  CustomActivityIndicatorView.swift
//  kurs
//
//  Created by Sergey Yuryev on 22/01/15.
//  Copyright (c) 2015 syuryev. All rights reserved.
//

// COPIED FROM https://raw.githubusercontent.com/snyuryev/Custom-Activity-Indicator-View/master/CustomActivityIndicatorViewTest/CustomActivityIndicatorView.swift
// BY Tony Heupel on 2017-01-05 and then modified by Tony Heupel to match my coding practices

import UIKit
import QuartzCore

@IBDesignable class CustomActivityIndicatorView: UIView {


    // MARK: - Internally visible members
    internal var isAnimating : Bool = false
    internal var hidesWhenStopped : Bool = true


    // MARK: - Private members
    lazy fileprivate var animationLayer: CALayer = {
        return CALayer()
    }()


    // MARK: - Initializers
    convenience init(image: UIImage) {
        self.init(image: image, size: image.size)
    }

    init(image: UIImage, size: CGSize) {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        super.init(frame: frame)

        animationLayer.frame = frame
        animationLayer.contents = resizeImage(image, size: size).cgImage
        animationLayer.masksToBounds = true

        self.layer.addSublayer(animationLayer)

        addRotation(forLayer: animationLayer)
        pause(animationLayer)
        self.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK - Func

    func addRotation(forLayer layer: CALayer) {
        let rotation = CABasicAnimation(keyPath:"transform.rotation.z")

        rotation.duration = 1.0
        rotation.isRemovedOnCompletion = false
        rotation.repeatCount = HUGE
        rotation.fillMode = kCAFillModeForwards
        rotation.fromValue = NSNumber(value: 0.0 as Float)
        rotation.toValue = NSNumber(value: 3.14 * 2.0 as Float)

        layer.add(rotation, forKey: "rotate")
    }

    func pause(_ layer: CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)

        layer.speed = 0.0
        layer.timeOffset = pausedTime

        isAnimating = false
    }

    func resume(_ layer: CALayer) {
        let pausedTime : CFTimeInterval = layer.timeOffset

        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0

        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause

        isAnimating = true
    }

    func startAnimating () {

        if isAnimating {
            return
        }

        if hidesWhenStopped {
            self.isHidden = false
        }
        resume(animationLayer)
    }

    func stopAnimating () {
        if hidesWhenStopped {
            self.isHidden = true
        }
        pause(animationLayer)
    }

    fileprivate func resizeImage(_ image: UIImage, size: CGSize) -> UIImage {
        var newWidth = image.size.width
        var newHeight = image.size.height
        var scale: CGFloat = 1.0

        if image.size.width > image.size.height {
            scale = size.width / image.size.width
        } else {
            scale = size.height / image.size.height
        }

        newWidth = scale * image.size.width
        newHeight = scale * image.size.height

        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
