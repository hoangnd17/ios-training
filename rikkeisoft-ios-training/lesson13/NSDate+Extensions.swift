//
//  NSDate+Extensions.swift
//  lesson13
//
//  Created by Đại Nguyễn  on 8/17/21.
//

import Foundation

extension NSDate {
    static func calculateDate(day: Int, month: Int, year: Int) -> NSDate {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let calculateDate = formatter.date(from: "\(year)/\(month)/\(day) 0:0") as NSDate?
        
        return calculateDate!
    }
}
