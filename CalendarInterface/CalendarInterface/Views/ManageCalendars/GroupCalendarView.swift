//
//  GroupCalendarView.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 30/12/2023.
//

import SwiftUI

struct GroupCalendarView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var calendars: [GroupCalendar]
    @Binding var events: [Event]
    @State var calendar: GroupCalendar
    
    @State var selectedDate: Date = Date.now
    
    var body: some View {
        ZStack {
            Color.accentColor.ignoresSafeArea()
            VStack {
                heading
                ScrollView(.vertical) {
                    VStack(spacing: 5) {
                        CustomDatePicker(color: Color.white, events: events.filter({ $0.calendarId == calendar.id }), selectedDate: $selectedDate)
                            .padding(.horizontal, 10)
                            .padding(.bottom, 5)
                            .padding(.top, 10)
                        EventList(selectedDate: selectedDate, events: $events, calendars: $calendars, defaultCalendar: calendar, isGroupCalendar: true)
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
        .navigationBarBackButtonHidden()
    }
    
    private var heading: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.white)
            })
            .frame(width: 50, alignment: .leading)
            Spacer()
            Text(calendar.name)
                .foregroundStyle(Color.white)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color(hex: calendar.color) ?? Color.accentColor)
                )
            
            Spacer()
            Button(action: {
                // open manage mode
            }, label: {
                Image(systemName: "gear")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white)
            })
            .frame(width: 50, alignment: .trailing)
        }
        .padding(.horizontal, 15)
        .background(
            Rectangle()
                .foregroundStyle(Color.clear)
                .ignoresSafeArea()
        )
        
    }
    
    private var addEventButton: some View {
        NavigationLink {
            CreateEventView(events: $events, calendars: $calendars, startTime: selectedDate, selectedCalendar: calendar)
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

