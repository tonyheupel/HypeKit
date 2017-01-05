//
//  UINavigationBarExtensions.swift
//  HypeKit
//
//  Created by Tony Heupel on 01/05/2017.
//  Copyright © 2017 Tony Heupel. All rights reserved.
//

import Foundation

extension UINavigationBar {
    func makeTranslucent() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.backgroundColor = UIColor.clear
        self.isTranslucent = true
    }
}
