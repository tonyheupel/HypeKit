//
//  SharedActivityIndicatorView.swift
//  HypeKit
//
//  Created by Tony Heupel on 01/05/2017.
//  Copyright © 2017 Tony Heupel. All rights reserved.
//

import Foundation

@IBDesignable class SharedActivityIndicatorView: CustomActivityIndicatorView {
    fileprivate static var starts = 0

    fileprivate var reusedInstanceMode = false

    init(reusedInstanceMode: Bool) {
        self.reusedInstanceMode = reusedInstanceMode
        // TODO: Use a default image with the assets in this pod or with static style members
        let image = UIImage(named: "activityIndicator")!.withRenderingMode(.alwaysTemplate).imageWithTintColor(UIColor.gray)
        super.init(image: image, size: CGSize(width: image.size.width * 1.5, height: image.size.height * 1.5))
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func startAnimating() {
        if reusedInstanceMode {
            SharedActivityIndicatorView.starts += 1
        }

        super.startAnimating()
    }

    override func stopAnimating() {
        if reusedInstanceMode {
            SharedActivityIndicatorView.starts -= 1

            // It's OK to have too many stops, but make sure
            // we stop animating and get the count no lower than zero
            if SharedActivityIndicatorView.starts <= 0 {
                SharedActivityIndicatorView.starts = 0
                super.stopAnimating()
            }
        } else {
            super.stopAnimating()
        }
    }
}
