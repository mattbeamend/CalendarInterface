//
//  ListCalendarView.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 30/09/2023.
//

import SwiftUI

struct ListCalendarView: View {
    
    let testEvents = [
        Event(id: "1", name: "Cambridge Trip", start: stringToDate(dateString: "2023-09-22T6:30:00+0000"), end: stringToDate(dateString: "2023-09-24T8:00:00+0000"), color: Color.purple, allDay: true),
        Event(id: "2", name: "Football Practice", start: stringToDate(dateString: "2023-09-14T6:30:00+0000"), end: stringToDate(dateString: "2023-09-14T8:00:00+0000"), color: Color.blue, allDay: false),
        Event(id: "3", name: "Football Practice", start: stringToDate(dateString: "2023-09-19T6:30:00+0000"), end: stringToDate(dateString: "2023-09-19T8:00:00+0000"), color: Color.red, allDay: false),
        Event(id: "4", name: "Football Practice", start: stringToDate(dateString: "2023-09-28T6:30:00+0000"), end: stringToDate(dateString: "2023-09-28T8:00:00+0000"), color: Color.blue, allDay: false),
        Event(id: "5", name: "Sprint Meeting", start: stringToDate(dateString: "2023-09-28T8:00:00+0000"), end: stringToDate(dateString: "2023-09-28T10:00:00+0000"), color: Color.green, allDay: false),
        Event(id: "6", name: "Barbers Appointment", start: stringToDate(dateString: "2023-09-30T11:00:00+0000"), end: stringToDate(dateString: "2023-09-30T11:30:00+0000"), color: Color.red, allDay: false)
    ]
    
    @State var selectedDate: Date = Date.now
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9).ignoresSafeArea()
            ScrollView(.vertical) {
                VStack(spacing: 5) {
                    CustomDatePicker(color: Color.white, events: testEvents, selectedDate: $selectedDate)
                        .padding(10)
                    Spacer().frame(height: 3)
                    eventList
                }
            }
        }
    }
}

extension ListCalendarView {
    
    private var eventList: some View {
        VStack(spacing: 15) {
            ForEach(selectedDate.getDateEvents(events: testEvents)) { event in
                EventCard(event: event)
            }
            Spacer()
                .frame(height: 1000)
                .ignoresSafeArea()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            Rectangle()
                .cornerRadius(10, corners: [.topLeft, .topRight])
                .foregroundColor(Color.white)
                .ignoresSafeArea()
        )
    }
    
    @ViewBuilder
    private func EventCard(event: Event) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(event.name)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(Color.white)
                if(event.allDay) {
                    Text("\(event.start.getFullDateString()) - \(event.end.getFullDateString())")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.7))
                } else {
                    Text("\(event.start.getTimeString()) - \(event.end.getTimeString())")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.7))
                }
                
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(event.color)
        )
        .frame(maxWidth: .infinity)
       
    }
}

struct ListCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ListCalendarView()
    }
}
