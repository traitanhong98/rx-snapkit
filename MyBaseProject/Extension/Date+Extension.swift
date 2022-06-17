//
//  Date-Extension.swift
//  Pmobile3
//
//  Created by ECO0527_HOANGNM on 03/06/2021.
//

import Foundation

extension Date {
    func toString(withFormat format: String = "dd-MMM-YYYY") -> String {
        let formater = DateFormatter()
        formater.dateFormat = format
        formater.timeZone = TimeZone.current
        return formater.string(from: self)
    }
    
    static func getDates(forLastNDays nDays: Int, isPrevious: Bool, format: String = "yyyyMMdd") -> String {
        let cal = NSCalendar.current
        var date = cal.startOfDay(for: Date())
        if isPrevious {
            date = cal.date(byAdding: Calendar.Component.day, value: -nDays, to: date)!
        }else {
            date = cal.date(byAdding: Calendar.Component.day, value: +nDays, to: date)!
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    var startOfWeek: String? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: gregorian.date(byAdding: .day, value: 1, to: sunday) ?? Date())
    }
    
    var endOfWeek: String? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: gregorian.date(byAdding: .day, value: 7, to: sunday) ?? Date())
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var startOfMonth: Date {

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    var year: Int {
        return Calendar(identifier: .gregorian).component(.year, from: self)
    }
    var moth: Int {
        return Calendar(identifier: .gregorian).component(.month, from: self)
    }

    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func age() -> Int {
        return Int(Calendar.current.dateComponents([.year], from: self, to: Date()).year!)
    }
}

extension TimeInterval {
    func extractTimeSinceNow() -> (hour: Int, min: Int, second: Int) {
        let time = NSInteger(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return (hours, minutes, seconds)
    }
}

extension Int64 {
    func convertTimeIntervalToString(_ format: String = "YYYY-MM-dd HH:mm:ss") -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self)/1000)
        return date.toString(withFormat: format)
    }
}
