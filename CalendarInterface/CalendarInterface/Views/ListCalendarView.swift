//
//  ListCalendarView.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 28/09/2023.
//

import SwiftUI

struct ListCalendarView: View {
    
    let days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    @State var date: Date = Date.now
    @State var selectedDate: Date = Date.now
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                calendarHeading
                calendarDays
                datesGrid
                Spacer()
            }
        }
    }
}

extension ListCalendarView {
    
    private var calendarHeading: some View {
        HStack {
            Text(date.getMonthString())
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(Color.white)
            if(!Calendar.current.isDate(date, equalTo: Date.now, toGranularity: .year)) {
                Text(date.getYearString())
                    .font(.system(size: 24, weight: .regular, design: .rounded))
                    .foregroundColor(Color.white)
            }
            Spacer()
            changeMonths
        }
        .padding(.horizontal, 5)
        .padding(.bottom)
    }
    
    private var changeMonths: some View {
        HStack(spacing: 40) {
            Button {
                var component = DateComponents()
                component.month = -1
                date = Calendar.current.date(byAdding: component, to: date)!
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.white)
            }
            Button {
                var component = DateComponents()
                component.month = 1
                date = Calendar.current.date(byAdding: component, to: date)!
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.white)
            }
        }
    }
    
    private var calendarDays: some View {
        HStack {
            ForEach(days, id: \.self) { day in
                Text(day)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.3))
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var datesGrid: some View {
        LazyVGrid(columns: columns) {
            // Offset start of month to correct weekday position
            if date.getStartMonthPosition() > 0 {
                ForEach(1 ..< date.getStartMonthPosition(), id: \.self) { _ in
                    Text("")
                }
            }
            ForEach(date.getDaysOfMonth(), id: \.self) { date in
                DateIcon(date: date)
            }
        }
    }
    
    @ViewBuilder
    private func DateIcon(date: Date) -> some View {
        Button {
            selectedDate = date
        } label: {
            if(Calendar.current.isDate(date, equalTo: selectedDate, toGranularity: .day)) {
                Text(date.getDateString())
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Color.black)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .foregroundColor(Color.white)
                            .shadow(radius: 3)
                    )
            } else {
                Text(date.getDateString())
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .stroke(Calendar.current.isDate(date, equalTo: Date.now, toGranularity: .day) ? Color.white : Color.clear, lineWidth: 1)
                            .shadow(radius: 3)
                    )

            }
        }
    }
}

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
}










struct ListCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ListCalendarView()
    }
}
