//
//  DataExtensions.swift
//  HypeKit
//
//  Created by Tony Heupel on 01/05/2017.
//  Copyright © 2017 Tony Heupel. All rights reserved.
//

import Foundation

extension Data {
    func jsonDataAsDictionary() throws -> [String: AnyObject]? {
        return try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject]
    }
}
