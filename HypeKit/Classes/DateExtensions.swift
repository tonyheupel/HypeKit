//
//  DateExtensions.swift
//  HypeKit
//
//  Created by Tony Heupel on 01/05/2017.
//  Copyright © 2017 Tony Heupel. All rights reserved.
//

import Foundation

extension Date {
    func singleWordStringForPastDate() -> String {
        let now = Date()
        let diff = now.timeIntervalSince(self)
        if diff < 0.0 || self == Date.distantPast {
            return ""
        }

        let calendar = Calendar.current
        let nowComponents = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute], from: now)
        let selfComponents = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .weekday], from: self)

        let nowStartOfDay = calendar.startOfDay(for: now)
        let dayInSeconds: Double = 86400
        let dateThatIsYesterday = nowStartOfDay.addingTimeInterval(-1.0 * dayInSeconds)
        let dateThatIslessThanOneWeekFromNowStartOfDay = nowStartOfDay.addingTimeInterval(-6.9999 * dayInSeconds)

        if nowComponents.year == selfComponents.year && nowComponents.month == selfComponents.month && nowComponents.day == selfComponents.day {
            if nowComponents.hour == selfComponents.hour && nowComponents.minute == nowComponents.minute {
                return "Now"
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                formatter.amSymbol = "AM"
                formatter.pmSymbol = "PM"
                return formatter.string(from: self)
            }
        } else if self.compare(dateThatIsYesterday) == .orderedDescending {
            return "Yesterday"
        } else if self.compare(dateThatIslessThanOneWeekFromNowStartOfDay) == .orderedDescending {
            let formatter = DateFormatter()
            formatter.dateFormat = "eeee" // Day name
            return formatter.string(from: self)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "M/dd/yyyy"
            return formatter.string(from: self)
        }
    }
}
