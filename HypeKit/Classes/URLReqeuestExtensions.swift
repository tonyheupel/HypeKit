//
//  URLReqeuestExtensions.swift
//  HypeKit
//
//  Created by Tony Heupel on 01/05/2017.
//  Copyright © 2017 Tony Heupel. All rights reserved.
//

import Foundation

extension URLRequest {
    func dataTaskUsingDefaultSessionConfigurationWithCompletion(_ completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) -> URLSessionDataTask {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let apiTask = session.dataTask(with: self, completionHandler: completion )
        return apiTask
    }
}
