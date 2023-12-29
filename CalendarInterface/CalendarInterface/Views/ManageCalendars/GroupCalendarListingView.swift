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
    
    var body: some View {
        VStack {
            heading
            ScrollView(.vertical) {
                calendarListing
            }
            Spacer()
            HStack {
                Spacer()
                addCalendarButton
            }
            
        }
    }
}

extension GroupCalendarListingView {
    private var heading: some View {
        HStack {
            Spacer()
                .frame(width: 55)
            Spacer()
            Text("Your Calendars")
                .foregroundStyle(Color.white)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
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
        .padding(.bottom, 5)
        .background(
            Rectangle()
                .foregroundStyle(Color.black.opacity(0.9))
                .ignoresSafeArea()
        )
        .padding(.bottom, 5)
    }
    
    private var calendarListing: some View {
        VStack(spacing: 5) {
            ForEach(calendars, id: \.self) { calendar in
                CalendarCard(calendar: calendar)
            }
        }
        .padding(10)
    }
    
    @ViewBuilder
    private func CalendarCard(calendar: GroupCalendar) -> some View {
        HStack {
            if(editMode) {
                Button(action: {
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
                }, label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.red)
                })
            }
            HStack {
                Rectangle()
                    .frame(width: 20)
                    .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                    .foregroundStyle(Color(hex: calendar.color) ?? Color.blue)
                VStack(alignment: .leading) {
                    Text(calendar.name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.black)
                }
                Spacer()
            }
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.black.opacity(0.05))
            )
            .padding(.vertical, 5)
        }
        
    }
    
    private var addCalendarButton: some View {
        NavigationLink {
            AddCalendarView(calendars: $calendars)
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
        .padding()
    }
    
}

//#Preview {
//    GroupCalendarListingView()
//}
