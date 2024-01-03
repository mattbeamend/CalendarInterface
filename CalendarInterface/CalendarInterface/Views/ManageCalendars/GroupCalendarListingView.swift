//
//  GroupCalendarListingView.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 29/12/2023.
//

import SwiftUI

struct GroupCalendarListingView: View {
    
    @Binding var events: [Event]
    @Binding var calendars: [GroupCalendar]
    @State var editMode: Bool = false
    @State var isPending: Bool = false
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack {
                heading
                ScrollView(.vertical) {
                    if(isPending) {
                        pendingListing
                    } else {
                        calendarListing
                    }
                    
                }
                Spacer()
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    addCalendarButton
                }
            }
            
        }
        
    }
}

extension GroupCalendarListingView {
    private var heading: some View {
        VStack {
            HStack {
                Text("Group Calendars")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                Spacer()
                
                
                Button(action: {
                    withAnimation(.easeInOut) {
                        editMode.toggle()
                    }
                }, label: {
                    Text(!editMode ? "Edit" : "Done")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white)
                })
                .frame(width: 55, alignment: .trailing)
            }
            .padding(15)
            .padding(.bottom, 10)
            .padding(.top, 5)
            
            HStack {
                Button(action: {
                    isPending = false
                }, label: {
                    VStack(spacing: 10) {
                        Text("Joined")
                            .font(.system(size: 14, weight: isPending ? .regular : .semibold))
                            .foregroundStyle(Color.white)
                        Rectangle()
                            .foregroundStyle(isPending ? Color.clear : Color.white)
                            .frame(height: 6)
                            .frame(width: 160)
                    }
                })
                .padding(.horizontal)
                Spacer()
                Button(action: {
                    isPending = true
                }, label: {
                    VStack(spacing: 10) {
                        Text("Pending")
                            .font(.system(size: 14, weight: isPending ? .semibold : .regular))
                            .foregroundStyle(Color.white)
                        Rectangle()
                            .foregroundStyle(isPending ? Color.white : Color.clear)
                            .frame(height: 6)
                            .frame(width: 160)
                    }
                })
                .padding(.horizontal)
            }
        }
        .background(
            Rectangle()
                .foregroundStyle(Color.accentColor)
                .shadow(color: Color.black.opacity(0.3), radius: 10, y: 2)
                .ignoresSafeArea()
                
        )
        
        
        
    }
    
    private var calendarListing: some View {
        VStack(spacing: 5) {
            ForEach(calendars, id: \.self) { calendar in
                CalendarCard(calendar: calendar)
            }
        }
        .padding(10)
    }
    
    private var pendingListing: some View {
        VStack {
            Text("Pending")
                .padding()
        }
    }
    
    @ViewBuilder
    private func CalendarCard(calendar: GroupCalendar) -> some View {
        HStack {
            if(editMode && (calendar.id != "1")) {
                Button(action: {
                    withAnimation(.easeInOut) {
                        // delete calendar from user defaults
                        if let index = calendars.firstIndex(where: { $0.id == calendar.id}) {
                            calendars.remove(at: index)
                        }
                        let encoder = JSONEncoder()
                        if let encoded = try? encoder.encode(calendars) {
                            UserDefaults.standard.set(encoded, forKey: "calendars")
                        }
                        // remove any events associated to deleted calendar
                        events = events.filter({ $0.calendarId != calendar.id })
                        if let encoded = try? encoder.encode(events) {
                            UserDefaults.standard.set(encoded, forKey: "events")
                        }
                    }
                }, label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.red)
                })
            }
            NavigationLink {
                GroupCalendarView(calendars: $calendars, events: $events, calendar: calendar)
            } label: {
                HStack(spacing: 15) {
                    Rectangle()
                        .frame(width: 16)
                        .cornerRadius(5, corners: [.topLeft, .bottomLeft])
                        .foregroundStyle(Color(hex: calendar.color) ?? Color.accentColor)
                    VStack(alignment: .leading, spacing: 5) {
                        Text(calendar.name)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.black)
                        Text("4 Members")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.black.opacity(0.5))
                    }
                    .padding(.vertical)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color(hex: calendar.color) ?? Color.accentColor)
                        .padding()
                }
                .frame(height: 68)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, y: 1)
                )
            }
            .padding(.vertical, 5)
        }
        
    }
    
    private var addCalendarButton: some View {
        NavigationLink {
            AddCalendarView(calendars: $calendars)
        } label: {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.white)
                .padding(10)
                .background(
                    Circle()
                        .foregroundStyle(Color.accentColor)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, y: 1)
                )
        }
        .padding()
    }
    
}

//#Preview {
//    GroupCalendarListingView()
//}
