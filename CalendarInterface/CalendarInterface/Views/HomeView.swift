//
//  HomeView.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 29/12/2023.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var calendars: [GroupCalendar]
    @Binding var events: [Event]
    @State var defaultCalendar: GroupCalendar
    @State var currentTime: Date = Date.now
//    @State var calendars: [GroupCalendar] = [GroupCalendar(id: "2", name: "Work", color: "EC991C"), GroupCalendar(id: "3", name: "Family", color: "5D4591"), GroupCalendar(id: "4", name: "Tennis Club", color: "459173")]
//    @State var events: [Event] = [
//        
//    ]
//    @State var defaultCalendar: GroupCalendar = GroupCalendar(id: "1", name: "Personal", color: "#FF0000")
    
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack {
                heading
                ScrollView(.vertical) {
                    HStack(spacing: 15) {
                        addEventButton
                        addCalendarButton
                    }
                    .padding(10)
                    upcomingEvents
                    groupCalendarList
                }
                
            }
        }
    }
}

extension HomeView {
    private var heading: some View {
        HStack {
            Text("Collaborate")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white)
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .padding(.bottom, 15)
        .background(
            Image("HomeGraphic")
                .resizable()
                .ignoresSafeArea()
        )
        .padding(.bottom, 10)
    }
    
    private var addEventButton: some View {
        NavigationLink(destination: {
            CreateEventView(events: $events, calendars: $calendars, startTime: $currentTime, selectedCalendar: defaultCalendar)
        }, label: {
            VStack {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
                Text("Add event")
                    .foregroundStyle(Color.accentColor)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }
            .frame(height: 90)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, y: 1)
            )
        })
    }
    
    private var addCalendarButton: some View {
        NavigationLink(destination: {
            AddCalendarView(calendars: $calendars)
        }, label: {
            VStack {
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
                Text("Add calendar")
                    .foregroundStyle(Color.accentColor)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }
            .frame(height: 90)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, y: 1)
            )
        })
    }
    
    private var upcomingEvents: some View {
        VStack(alignment: .center) {
            HStack {
                Text("UPCOMING EVENTS")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.black.opacity(0.4))
                    .padding(.bottom, 10)
                Spacer()
            }
            if(events.isEmpty) {
                VStack(spacing: 5) {
                    NavigationLink(destination: {
                        CreateEventView(events: $events, calendars: $calendars, startTime: $currentTime, selectedCalendar: defaultCalendar)
                    }, label: {
                        Text("Add an event!")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.blue)
                    })
                    Text("You have no events coming up.")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, y: 1)
                )
            } else {
                ForEach(events.sorted(by: {$0.start.compare($1.start) == .orderedAscending}).filter({ $0.end > Date.now }).prefix(3), id: \.self) { event in
                    EventCard(event: event)
                }
            }
        }
        
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    private func EventCard(event: Event) -> some View {
        NavigationLink {
            EventDetailView(calendars: $calendars, events: $events, event: event, calendar: calendars.first(where: { $0.id == event.calendarId }) ?? defaultCalendar)
        } label: {
            HStack(spacing: 15) {
                Rectangle()
                    .frame(width: 16)
                    .cornerRadius(5, corners: [.topLeft, .bottomLeft])
                    .foregroundStyle(Color(hex: event.color) ?? Color.blue)

                VStack(alignment: .leading, spacing: 5) {
                    Text(event.name)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.black)
                    Text((calendars.first(where: { $0.id == event.calendarId }) ?? defaultCalendar).name)
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.black.opacity(0.5))
                    
                }
                .padding(.vertical)
                Spacer()
                VStack(spacing: 5) {
                    Text(event.allDay ? "All day" : event.start.getTimeString())
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.black)
                    if(Date.now.isDateInRange(start: event.start.startOfDay(), end: event.end.endOfDay())) {
                        Text("Today")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.black.opacity(0.5))
                    } else if(event.start.isTomorrow()) {
                        Text("Tomorrow")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.black.opacity(0.5))
                    } else {
                        Text(event.start.getShortDate())
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.black.opacity(0.5))
                    }
                    
                }
                .padding(10)
                .padding(.trailing, 5)
            }
            .frame(height: 68)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle((event.allDay && (event.end.endOfDay() < Date.now)) || (!event.allDay && (event.end < Date.now)) ? Color.white.opacity(0.4) : Color.clear)
                    
            )
            .frame(maxWidth: .infinity)
            .shadow(color: Color.black.opacity(0.1), radius: 10, y: 1)
            .padding(.vertical, 3)
        
            
        }
    }
    
    private var groupCalendarList: some View {
        VStack(alignment: .leading) {
            Text("CALENDARS")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.4))
                .padding(.horizontal, 10)
            
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    GroupCalendarCard(calendar: defaultCalendar, event: events.filter({ $0.calendarId == defaultCalendar.id }).sorted(by: {$0.start.compare($1.start) == .orderedAscending}).filter({ $0.end > Date.now }).first)
                    ForEach(calendars.filter({ $0.id != "1" }), id: \.self) { calendar in
                        GroupCalendarCard(calendar: calendar, event: events.filter({ $0.calendarId == calendar.id }).sorted(by: {$0.start.compare($1.start) == .orderedAscending}).filter({ $0.end > Date.now }).first)
                    }
                }
                .padding(.vertical)
                .padding(.horizontal, 10)
            }
            .scrollIndicators(.hidden)
        }
        .padding(.vertical, 10)
        
    }
    
    @ViewBuilder
    private func GroupCalendarCard(calendar: GroupCalendar, event: Event?) -> some View {
        NavigationLink {
            GroupCalendarView(calendars: $calendars, events: $events, calendar: calendar)
        } label: {
            VStack {
                Text(calendar.name)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.white)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .padding(5)
                    .background(
                        Rectangle()
                            .cornerRadius(10, corners: [.topLeft, .topRight])
                            .frame(width: 150, height: 35)
                            .foregroundStyle(Color(hex: calendar.color) ?? Color.accentColor)
                    )
                VStack(spacing: 7) {
                    
                    if(event == nil) {
                        Text("No Events")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.black)
                            .padding(10)
                    } else {
                        Text(event?.name ?? "")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.black)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        HStack(spacing: 3) {
                            if(!(event?.allDay ?? false)) {
                                Text("\(event?.start.getTimeString() ?? "") •")
                                    .font(.system(size: 11, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.black.opacity(0.5))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            Text(event?.start.getShortDate() ?? "")
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.black.opacity(0.5))
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        
                    }
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .frame(width: 150, height: 95)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, y: 1)
            )
        }
    }
    
}

//#Preview {
//    HomeView()
//}
