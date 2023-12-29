//
//  EventList.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 08/10/2023.
//

import SwiftUI

struct EventList: View {
    
    var selectedDate: Date
    @Binding var events: [Event]
    @Binding var calendars: [GroupCalendar]
    
    @State var personalCalendar: GroupCalendar = GroupCalendar(id: "1", name: "Personal", color: "#FF0000")
    
    var body: some View {
        VStack(spacing: 7) {
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
            .padding(.bottom, 15)
    
            // Display all day events
            ForEach(selectedDate.getDateEvents(events: events).filter { $0.allDay == true }) { event in
                EventCard(event: event)
            }
            
            // Show divider if all day & normal events on date
            if(!selectedDate.getDateEvents(events: events).filter {$0.allDay == true }.isEmpty
               && !selectedDate.getDateEvents(events: events).filter {$0.allDay == false }.isEmpty) {
                Divider()
                    .foregroundStyle(Color.black.opacity(1))
                    .frame(height: 1)
                    .padding(10)
            }
            
            // Display normal events
            ForEach(selectedDate.getDateEvents(events: events).filter { $0.allDay == false }) { event in
                EventCard(event: event)
            }
            
            
            if(selectedDate.getDateEvents(events: events).count == 0) {
                noEventsIcon
            }
            
            Spacer()
                .frame(height: 1000)
                .ignoresSafeArea()
        }
        .padding(.vertical)
        .padding(.horizontal, 10)
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
                CreateEventView(events: $events, calendars: $calendars, startTime: selectedDate)
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
        NavigationLink {
            EventDetailView(calendars: $calendars, events: events, event: event, calendar: calendars.first(where: { $0.id == event.calendarId }) ?? personalCalendar)
        } label: {
            HStack(spacing: 15) {
                Rectangle()
                    .frame(width: 10)
                    .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                    .foregroundStyle(Color(hex: event.color) ?? Color.blue)

                VStack(alignment: .leading, spacing: 5) {
                    Text(event.name)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.black)
                    if(!event.allDay) {
                        Text("\(event.start.getTimeString()) - \(event.end.getTimeString())")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.black.opacity(0.7))
                    }
                }
                .padding(.vertical)
                Spacer()
            }
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(Color(hex: event.color)?.opacity(0.2) ?? Color.blue.opacity(0.2))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle((event.allDay && (event.end.endOfDay() < Date.now)) || (!event.allDay && (event.end < Date.now)) ? Color.white.opacity(0.4) : Color.clear)
                    
            )
            .frame(maxWidth: .infinity)
        }
    }
}


