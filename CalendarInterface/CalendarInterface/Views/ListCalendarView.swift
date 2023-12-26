//
//  ListCalendarView.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 30/09/2023.
//

import SwiftUI

struct ListCalendarView: View {
    
    let testEvents = [
        Event(id: "1", name: "Cambridge Trip", start: stringToDate(dateString: "2023-12-24T8:30:00+0000"), end: stringToDate(dateString: "2023-12-26T3:00:00+0000"), color: Color.purple, allDay: true),
        Event(id: "10", name: "Boxing Day", start: stringToDate(dateString: "2023-12-26T8:30:00+0000"), end: stringToDate(dateString: "2023-12-26T3:00:00+0000"), color: Color.orange, allDay: true),
        Event(id: "2", name: "Football Practice", start: stringToDate(dateString: "2023-09-14T6:30:00+0000"), end: stringToDate(dateString: "2023-09-14T8:00:00+0000"), color: Color.blue, allDay: false),
        Event(id: "5", name: "Sprint Meeting", start: stringToDate(dateString: "2023-12-26T8:00:00+0000"), end: stringToDate(dateString: "2023-12-26T10:00:00+0000"), color: Color.green, allDay: false),
        Event(id: "3", name: "Football Practice", start: stringToDate(dateString: "2023-09-19T6:30:00+0000"), end: stringToDate(dateString: "2023-09-19T8:00:00+0000"), color: Color.red, allDay: false),
        Event(id: "4", name: "Football Practice", start: stringToDate(dateString: "2023-12-26T6:30:00+0000"), end: stringToDate(dateString: "2023-12-26T8:00:00+0000"), color: Color.blue, allDay: false),
        Event(id: "6", name: "Barbers Appointment", start: stringToDate(dateString: "2023-12-27T11:00:00+0000"), end: stringToDate(dateString: "2023-12-27T11:30:00+0000"), color: Color.red, allDay: false)
    ]
    
    @State var selectedDate: Date = Date.now
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.9).ignoresSafeArea()
                ScrollView(.vertical) {
                    VStack(spacing: 5) {
                        CustomDatePicker(color: Color.white, events: testEvents, selectedDate: $selectedDate)
                            .padding(10)
                        Spacer().frame(height: 3)
                        EventList(selectedDate: selectedDate, events: testEvents)
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
    }
    
    private var addEventButton: some View {
        NavigationLink {
            CreateEventView(startTime: selectedDate)
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(Color.white)
                .padding(10)
                .background(
                    Circle()
                        .foregroundStyle(Color.black.opacity(0.9))
                )
        }
    }
}

func stringToDate(dateString: String) -> Date {
    let formatter = ISO8601DateFormatter()
    return formatter.date(from: dateString) ?? Date.now
}


struct ListCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ListCalendarView()
    }
}
