//
//  EventList.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 08/10/2023.
//

import SwiftUI

struct EventList: View {
    
    var selectedDate: Date
    var events: [Event]
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 0) {
                Text("\(selectedDate.getFullDate()) ")
                    .foregroundStyle(Color.black)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                if(!Calendar.current.isDate(selectedDate, equalTo: Date.now, toGranularity: .year)) {
                    Text(selectedDate.getYearString())
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                }
                Spacer()
            }
            .frame(height: 30)
            ForEach(selectedDate.getDateEvents(events: events)) { event in
                EventCard(event: event)
            }
            if(selectedDate.getDateEvents(events: events).count == 0) {
                noEventsIcon
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
}

extension EventList {
    
    private var noEventsIcon: some View {
        VStack(spacing: 5) {
            Text("Nothing Planned")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.black)
            NavigationLink {
                CreateEventView(selectedDate: selectedDate)
            } label: {
                Text("Tap here to create.")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color.gray.opacity(0.1))
        )
        .padding()
    }
    
    @ViewBuilder
    private func EventCard(event: Event) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(event.name)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white)
                if(event.allDay) {
                    Text("\(event.start.getShortDate()) - \(event.end.getShortDate())")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.7))
                } else {
                    Text("\(event.start.getTimeString()) - \(event.end.getTimeString())")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.7))
                }
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(event.color)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(event.end < Date.now ? Color.white.opacity(0.3) : Color.clear)
        )
        .frame(maxWidth: .infinity)
       
    }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList(selectedDate: Date.now, events: [
            Event(id: "1", name: "Cambridge Trip", start: stringToDate(dateString: "2023-12-22T6:30:00+0000"), end: stringToDate(dateString: "2023-12-23T18:00:00+0000"), color: Color.purple, allDay: true),
            Event(id: "2", name: "Football Practice", start: stringToDate(dateString: "2023-09-14T6:30:00+0000"), end: stringToDate(dateString: "2023-09-14T8:00:00+0000"), color: Color.blue, allDay: false),
            Event(id: "3", name: "Football Practice", start: stringToDate(dateString: "2023-09-19T6:30:00+0000"), end: stringToDate(dateString: "2023-09-19T8:00:00+0000"), color: Color.red, allDay: false),
            Event(id: "4", name: "Football Practice", start: stringToDate(dateString: "2023-09-28T6:30:00+0000"), end: stringToDate(dateString: "2023-09-28T8:00:00+0000"), color: Color.blue, allDay: false),
            Event(id: "5", name: "Sprint Meeting", start: stringToDate(dateString: "2023-09-28T8:00:00+0000"), end: stringToDate(dateString: "2023-09-28T10:00:00+0000"), color: Color.green, allDay: false),
            Event(id: "6", name: "Barbers Appointment", start: stringToDate(dateString: "2023-10-1T11:00:00+0000"), end: stringToDate(dateString: "2023-10-1T11:30:00+0000"), color: Color.red, allDay: false)
        ])
    }
}

