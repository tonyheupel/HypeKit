//
//  UIImageExtensions.swift
//  HypeKit
//
//  Created by Tony Heupel on 01/05/2017.
//  Copyright © 2017 Tony Heupel.. All rights reserved.
//

import Foundation

extension UIImage {
    /// Create an image that is all one color from scratch
    class func imageWithColor(_ color: UIColor?) -> UIImage! {

        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

        let context = UIGraphicsGetCurrentContext();

        if let color = color {
            color.setFill()
        } else {
            UIColor.white.setFill()
        }

        context!.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image;
    }


    func grayscaleOfImage() -> UIImage {
        let image = self
        let imageRect:CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height

        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

        context!.draw(image.cgImage!, in: imageRect)
        let imageRef = context!.makeImage()
        let newImage = UIImage(cgImage: imageRef!)

        return newImage
    }

    func inverseColorOfImage() -> UIImage {
        let coreImage = CIImage(image: self)

        if let filter = CIFilter(name: "CIColorInvert") {
            filter.setValue(coreImage, forKey:kCIInputImageKey)
            if let result = filter.outputImage {
                let context = CIContext(options: nil)
                let cgResultImage = context.createCGImage(result, from: result.extent)

                return UIImage(cgImage: cgResultImage!)
            }
        }

        return UIImage()

    }

    func monochromeOfImage() -> UIImage {
        let coreImage = CIImage(image: self)

        if let filter = CIFilter(name: "CIColorMonochrome") {
            filter.setValue(coreImage, forKey:kCIInputImageKey)
            if let result = filter.outputImage {
                let context = CIContext(options: nil)
                let cgResultImage = context.createCGImage(result, from: result.extent)

                return UIImage(cgImage: cgResultImage!)
            }
        }

        return UIImage()

    }

    func imageWithTintColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()

        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        context.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()

        return newImage
    }
}
