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
        .highPriorityGesture(DragGesture().onEnded({ gesture in
            if gesture.translation.width > 0 { // swipe right
                var component = DateComponents()
                component.month = -1
                withAnimation(.default) {
                    date = Calendar.current.date(byAdding: component, to: date)!
                }
                selectedDate = Calendar.current.date(byAdding: component, to: selectedDate) ?? Date.now
            }
            if gesture.translation.width < 0 { // swipe left
                var component = DateComponents()
                component.month = 1
                withAnimation(.default) {
                    date = Calendar.current.date(byAdding: component, to: date)!
                }
                selectedDate = Calendar.current.date(byAdding: component, to: selectedDate) ?? Date.now
            }
        }))
//        .onAppear(perform: {
//            date = Date.now
//        })
    }
}

extension CustomDatePicker {
    
    private var calendarHeading: some View {
        HStack {
            Text(date.getMonthString())
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(color)
            if(!Calendar.current.isDate(date, equalTo: Date.now, toGranularity: .year)) {
                Text(date.getYearString())
                    .font(.system(size: 24, weight: .regular, design: .rounded))
                    .foregroundStyle(color)
            }
            Spacer()
            
            backToDate
            changeMonths
            
        }
        .padding(.horizontal, 5)
        .padding(.bottom)
    }
    
    private var backToDate: some View {
        Button {
            withAnimation(.default) {
                date = Date.now
                selectedDate = Date.now
            }
        } label: {
            Image(systemName: "calendar")
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(color)
        }
        .padding(.horizontal, 20)
    }
    
    private var changeMonths: some View {
        HStack(spacing: 40) {
            Button {
                var component = DateComponents()
                component.month = -1
                withAnimation(.default) {
                    date = Calendar.current.date(byAdding: component, to: date)!
                }
                selectedDate = Calendar.current.date(byAdding: component, to: selectedDate) ?? Date.now
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(color)
            }
            Button {
                var component = DateComponents()
                component.month = 1
                withAnimation(.default) {
                    date = Calendar.current.date(byAdding: component, to: date)!
                }
                selectedDate = Calendar.current.date(byAdding: component, to: selectedDate) ?? Date.now
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(color)
            }
        }
    }
    
    private var calendarDays: some View {
        HStack {
            ForEach(days, id: \.self) { day in
                Text(day)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(color.opacity(0.3))
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var datesGrid: some View {
        LazyVGrid(columns: columns, spacing: 5) {
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
            VStack(spacing: 4) {
                if(Calendar.current.isDate(date, equalTo: selectedDate, toGranularity: .day)) {
                    Text(date.getDateString())
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.black)
                        .frame(width: 40, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(Color.white)
                        )
                } else {
                    Text(date.getDateString())
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(color)
                        .frame(width: 40, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Calendar.current.isDate(date, equalTo: Date.now, toGranularity: .day) ? color : Color.clear, lineWidth: 1)
                        )
                }
                HStack(spacing: 4) {
                    ForEach(getDateCalendarIcons(date: date, events: events).prefix(4), id: \.self) { color in
                        Circle()
                            .foregroundStyle(color)
                            .frame(width: 5, height: 5)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.5), lineWidth: 0.5)
                                    .frame(width: 5, height: 5)
                            )
                    }
                }
                .frame(width: 30, height: 10, alignment: .top)
            }
            
        }
    }
    
    // Get all the calendar icon colour for that date
    private func getDateCalendarIcons(date: Date, events: [Event]) -> [Color] {
        let events = date.getDateEvents(events: events)
        var colours = [Color]()
        for event in events {
            colours.contains(Color(hex: event.color ) ?? Color.blue) ? nil : colours.append(Color(hex: event.color ) ?? Color.blue)
        }
        return colours
    }
}


//
//struct CustomDatePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            Color.black.ignoresSafeArea()
//            CustomDatePicker(color: Color.white , events: [
//                Event(id: "1", name: "Cambridge Trip", start: stringToDate(dateString: "2023-09-22T6:30:00+0000"), end: stringToDate(dateString: "2023-09-24T8:00:00+0000"),
//                      color: Color.purple, allDay: false),
//                Event(id: "2", name: "Football Practice", start: stringToDate(dateString: "2023-09-14T6:30:00+0000"), end: stringToDate(dateString: "2023-09-14T8:00:00+0000"),
//                      color: Color.blue, allDay: false),
//                Event(id: "3", name: "Football Practice", start: stringToDate(dateString: "2023-09-19T6:30:00+0000"), end: stringToDate(dateString: "2023-09-19T8:00:00+0000"),
//                      color: Color.red, allDay: false),
//                Event(id: "4", name: "Football Practice", start: stringToDate(dateString: "2023-09-28T6:30:00+0000"), end: stringToDate(dateString: "2023-09-28T8:00:00+0000"),
//                      color: Color.blue, allDay: false),
//                Event(id: "5", name: "Sprint Meeting", start: stringToDate(dateString: "2023-09-28T8:00:00+0000"), end: stringToDate(dateString: "2023-09-28T10:00:00+0000"),
//                      color: Color.green, allDay: false),
//                Event(id: "6", name: "Barbers Appointment", start: stringToDate(dateString: "2023-09-29T11:00:00+0000"), end: stringToDate(dateString: "2023-09-29T11:30:00+0000"),
//                      color: Color.red, allDay: false),
//            ], selectedDate: .constant(Date.now))
//        }
//    }
//}
