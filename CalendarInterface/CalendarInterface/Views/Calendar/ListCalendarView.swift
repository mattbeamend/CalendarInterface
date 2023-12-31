//
//  ListCalendarView.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 30/09/2023.
//

import SwiftUI

struct ListCalendarView: View {
    
    
//    @State var testEvents = [
//        Event(id: "1", name: "Cambridge Trip", start: stringToDate(dateString: "2023-12-24T8:30:00+0000"), end: stringToDate(dateString: "2023-12-26T3:00:00+0000"), color: Color.purple.toHex() ?? "#000000", allDay: true),
//        Event(id: "10", name: "Boxing Day", start: stringToDate(dateString: "2023-12-26T8:30:00+0000"), end: stringToDate(dateString: "2023-12-26T3:00:00+0000"), color: Color.orange.toHex() ?? "#000000", allDay: true),
//        Event(id: "2", name: "Football Practice", start: stringToDate(dateString: "2023-09-14T6:30:00+0000"), end: stringToDate(dateString: "2023-09-14T8:00:00+0000"), color: Color.blue.toHex() ?? "#000000", allDay: false),
//        Event(id: "5", name: "Sprint Meeting", start: stringToDate(dateString: "2023-12-26T8:00:00+0000"), end: stringToDate(dateString: "2023-12-26T10:00:00+0000"), color: Color.green.toHex() ?? "#000000", allDay: false),
//        Event(id: "3", name: "Football Practice", start: stringToDate(dateString: "2023-09-19T6:30:00+0000"), end: stringToDate(dateString: "2023-09-19T8:00:00+0000"), color: Color.red.toHex() ?? "#000000", allDay: false),
//        Event(id: "4", name: "Football Practice", start: stringToDate(dateString: "2023-12-26T6:30:00+0000"), end: stringToDate(dateString: "2023-12-26T8:00:00+0000"), color: Color.blue.toHex() ?? "#000000", allDay: false),
//        Event(id: "6", name: "Barbers Appointment", start: stringToDate(dateString: "2023-12-28T11:00:00+0000"), end: stringToDate(dateString: "2023-12-28T11:30:00+0000"), color: Color.red.toHex() ?? "#000000", allDay: false)
//    ]
    
    
    
    @Binding var calendars: [GroupCalendar]
    @Binding var events: [Event]
    @State var defaultCalendar: GroupCalendar
    
    @State var selectedDate: Date = Date.now
    
    var body: some View {
        ZStack {
            Color(hex:"363B57").ignoresSafeArea()
            VStack {
                Spacer()
                    .ignoresSafeArea()
                    .frame(height: 0)
                ScrollView(.vertical) {
                    VStack(spacing: 5) {
                        CustomDatePicker(color: Color.white, events: events, selectedDate: $selectedDate)
                            .padding(.horizontal, 10)
                            .padding(.bottom, 5)
                        EventList(selectedDate: $selectedDate, events: $events, calendars: $calendars, defaultCalendar: calendars.first ?? GroupCalendar(id: "1", name: "Personal", color: "#FF0000"), isGroupCalendar: false)
                    }
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    addEventButton
                        .padding()
                }
            }
            
        }
    }
    
    private var addEventButton: some View {
        NavigationLink {
            CreateEventView(events: $events, calendars: $calendars, startTime: $selectedDate, selectedCalendar: defaultCalendar)
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.white)
                .padding(12)
                .background(
                    Circle()
                        .foregroundStyle(Color.accentColor)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, y: 1)
                )
                
        }
    }
}

func stringToDate(dateString: String) -> Date {
    let formatter = ISO8601DateFormatter()
    return formatter.date(from: dateString) ?? Date.now
}


//struct ListCalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListCalendarView()
//    }
//}
