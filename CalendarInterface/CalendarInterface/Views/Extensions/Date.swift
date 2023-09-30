//
//  Date.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 30/09/2023.
//

import SwiftUI

extension Date {
    
    func startOfMonth() -> Date {
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month], from: self)
        return cal.date(from: comps)!
    }
    
    func endOfMonth() -> Date {
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month], from: self)
        let date = cal.date(from: comps)!
        let lastDayOfMonth = cal.date(byAdding: DateComponents(month: 1, day: -1), to: date)!
        return lastDayOfMonth
    }
    
    func getDaysOfMonth() -> [Date] {
        let cal = Calendar.current
        let monthRange = cal.range(of: .day, in: .month, for: self)!
        let comps = cal.dateComponents([.year, .month], from: self)
        var date = cal.date(from: comps)!
        var dates: [Date] = []

        for _ in monthRange {
            dates.append(date)
            date = cal.date(byAdding: .day, value: 1, to: date)!
        }
        return dates
    }
    
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }
    
    func getMonthString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
    
    func getYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        return formatter.string(from: self)
    }
    
    func getStartMonthPosition() -> Int {
        let start = self.startOfMonth()
        let day = Calendar.current.component(.weekday, from: start)
        return day == 1 ? 6 : day - 1
    }
    
    func getDateEvents(events: [Event]) -> [Event] {
        let events = events.filter { event in
            let range = event.start.startOfDay()...event.end.endOfDay()
            return range.contains(self)
        }
        return events
    }
    
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func endOfDay() -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: self.startOfDay())!
    }
    
}
