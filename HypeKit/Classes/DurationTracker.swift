//
//  DurationTracker.swift
//  HypeKit
//
//  Created by Tony Heupel on 01/05/2017.
//  Copyright © 2017 Tony Heupel. All rights reserved.
//

import Foundation

enum DurationTrackerError: Error {
    case notTrackingDuration
}


class DurationTracker {
    let label: String
    var startDate: Date?
    var endDate: Date?

    var isTracking: Bool = false

    init(_ label: String) {
        self.label = label
    }

    func start() -> DurationTracker {
        startDate = Date()
        isTracking = true

        return self
    }

    func end() throws -> DurationTracker {
        if isTracking {
            endDate = Date()
            return self

        } else {
            throw DurationTrackerError.notTrackingDuration
        }
    }

    var duration: TimeInterval {
        get {
            if let s = startDate, let e = endDate {
                return e.timeIntervalSince(s)
            } else {
                return 0
            }
        }
    }

    var durationInMilliseconds: Double {
        get { return duration * 1000 }
    }
}

extension DurationTracker: CustomStringConvertible {
    var description: String {
        get { return "\(label): \(durationInMilliseconds) ms\nstart: \(startDate)\tend: \(endDate)" }
    }
}
