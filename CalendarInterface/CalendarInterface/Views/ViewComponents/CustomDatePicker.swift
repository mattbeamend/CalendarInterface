//
//  CustomDatePicker.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 28/09/2023.
//

import SwiftUI

struct CustomDatePicker: View {
    
    var color: Color
    var events: [Event]
    
    let days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    @State var date: Date = Date.now
    @Binding var selectedDate: Date
    
    
    var body: some View {
        VStack {
            calendarHeading
            calendarDays
            datesGrid
        }
    }
}

extension CustomDatePicker {
    
    private var calendarHeading: some View {
        HStack {
            Text(date.getMonthString())
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(color)
            if(!Calendar.current.isDate(date, equalTo: Date.now, toGranularity: .year)) {
                Text(date.getYearString())
                    .font(.system(size: 24, weight: .regular, design: .rounded))
                    .foregroundColor(color)
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
                    .foregroundColor(color)
            }
            Button {
                var component = DateComponents()
                component.month = 1
                date = Calendar.current.date(byAdding: component, to: date)!
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(color)
            }
        }
    }
    
    private var calendarDays: some View {
        HStack {
            ForEach(days, id: \.self) { day in
                Text(day)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(color.opacity(0.3))
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
        VStack(spacing: 3) {
            Button {
                selectedDate = date
            } label: {
                if(Calendar.current.isDate(date, equalTo: selectedDate, toGranularity: .day)) {
                    Text(date.getDateString())
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color.black)
                        .frame(width: 40, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color.white)
                                .shadow(radius: 3)
                        )
                } else {
                    Text(date.getDateString())
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(color)
                        .frame(width: 40, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Calendar.current.isDate(date, equalTo: Date.now, toGranularity: .day) ? color : Color.clear, lineWidth: 1)
                                .shadow(radius: 3)
                        )
                }
            }

            HStack(spacing: 4) {
                ForEach(getDateCalendarIcons(date: date, events: events).prefix(4), id: \.self) { color in
                    Circle()
                        .foregroundColor(color)
                        .frame(width: 5, height: 5)
                }
            }
            .frame(width: 30, height: 8, alignment: .top)
        }
    }
    
    // Get all the calendar icon colour for that date
    private func getDateCalendarIcons(date: Date, events: [Event]) -> [Color] {
        let events = date.getDateEvents(events: events)
        var colours = [Color]()
        for event in events {
            colours.contains(event.color) ? nil : colours.append(event.color)
        }
        return colours
    }
}



struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            CustomDatePicker(color: Color.white , events: [
                Event(id: "1", name: "Cambridge Trip", start: stringToDate(dateString: "2023-09-22T6:30:00+0000"), end: stringToDate(dateString: "2023-09-24T8:00:00+0000"), color: Color.purple, allDay: false),
                Event(id: "2", name: "Football Practice", start: stringToDate(dateString: "2023-09-14T6:30:00+0000"), end: stringToDate(dateString: "2023-09-14T8:00:00+0000"), color: Color.blue, allDay: false),
                Event(id: "3", name: "Football Practice", start: stringToDate(dateString: "2023-09-19T6:30:00+0000"), end: stringToDate(dateString: "2023-09-19T8:00:00+0000"), color: Color.red, allDay: false),
                Event(id: "4", name: "Football Practice", start: stringToDate(dateString: "2023-09-28T6:30:00+0000"), end: stringToDate(dateString: "2023-09-28T8:00:00+0000"), color: Color.blue, allDay: false),
                Event(id: "5", name: "Sprint Meeting", start: stringToDate(dateString: "2023-09-28T8:00:00+0000"), end: stringToDate(dateString: "2023-09-28T10:00:00+0000"), color: Color.green, allDay: false),
                Event(id: "6", name: "Barbers Appointment", start: stringToDate(dateString: "2023-09-29T11:00:00+0000"), end: stringToDate(dateString: "2023-09-29T11:30:00+0000"), color: Color.red, allDay: false),
            ], selectedDate: .constant(Date.now))
        }
    }
}