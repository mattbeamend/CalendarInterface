//
//  Date.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 30/09/2023.
//

import SwiftUI

extension Date {
    
    // Returns start of month
    func startOfMonth() -> Date {
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month], from: self)
        return cal.date(from: comps)!
    }
    
    // Returns end of month
    func endOfMonth() -> Date {
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month], from: self)
        let date = cal.date(from: comps)!
        let lastDayOfMonth = cal.date(byAdding: DateComponents(month: 1, day: -1), to: date)!
        return lastDayOfMonth
    }
    
    // Returns all days within a month
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
    
    // Returns weekday index for start of month (Wednesday = 3)
    func getStartMonthPosition() -> Int {
        let start = self.startOfMonth()
        let day = Calendar.current.component(.weekday, from: start)
        return day == 1 ? 7 : day - 1
    }
    
    // Returns all events occurring on a specific date
    func getDateEvents(events: [Event]) -> [Event] {
        var events = events.filter { event in
            let range = event.start.startOfDay()...event.end.endOfDay()
            return range.contains(self)
        }
        events = events.sorted(by: {$0.start.compare($1.start) == .orderedAscending})
        return events
    }
    
    // Returns the start of day
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    // Returns the end of the day
    func endOfDay() -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: self.startOfDay())!
    }
    
    // Returns true if dates are same day
    func sameDay(date: Date) -> Bool {
        return Calendar.current.isDate(date, equalTo: self, toGranularity: .day)
    }
    
    // Returns date digit string, e.g. "15"
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }
    
    // Returns month string, e.g. "July"
    func getMonthString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
    
    // Returns year string, e.g. "2020"
    func getYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        return formatter.string(from: self)
    }
    
    // Returns time string, e.g. "12:30"
    func getTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    // Returns shortened date, e.g. "Wed 15 Sep"
    func getShortDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E d MMM"
        return formatter.string(from: self)
    }
    
    // Returns full date string, e.g. Wednesday 15th September 2022
    func getFullDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM"
        return formatter.string(from: self)
    }
    
    func roundToNearestFiveMinutes() -> Date {
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: self)
        let roundedMinutes = 5 * Int(round(Double(minutes) / 5.0))
        let roundedDate = calendar.date(bySetting: .minute, value: roundedMinutes, of: self) ?? self
        return roundedDate
    }
    
    // Returns true if date is tomorrow
    func isTomorrow() -> Bool {
        var component = DateComponents()
        component.day = -1
        let date = Calendar.current.date(byAdding: component, to: self)!
        return date.sameDay(date: Date.now)
    }
    
    // Returns true if date is within range of two other dates
    func isDateInRange(start: Date, end: Date) -> Bool {
        let range = start...end
        return range.contains(self)
    }

}
