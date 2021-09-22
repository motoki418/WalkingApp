//
//  Date+Extension.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/22.
//


import Foundation
extension Date{
    static func mondayAt12AM() -> Date{
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}
