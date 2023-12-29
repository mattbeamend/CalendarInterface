//
//  ContentView.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 28/09/2023.
//

// TODO:
// - Add swipe gestures to the app, especially when changing the different months on the calendar.
// - Add a go back to current date button

import SwiftUI

struct ContentView: View {
    
    init() {
        UIDatePicker.appearance().minuteInterval = 5
    }
    
    
    @State var calendars: [GroupCalendar] = []
    @State var events: [Event] = []
    
    var body: some View {
        NavigationStack {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                ListCalendarView(calendars: $calendars, events: $events)
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                GroupCalendarListingView(events: $events, calendars: $calendars)
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Listing")
                    }
            }
            .onAppear(perform: {
                if let savedEventsData = UserDefaults.standard.data(forKey: "events") {
                    let decoder = JSONDecoder()
                    if let savedEvents = try? decoder.decode([Event].self, from: savedEventsData) {
                        events = savedEvents
                    }
                }
                if let savedEventsData = UserDefaults.standard.data(forKey: "calendars") {
                    let decoder = JSONDecoder()
                    if let savedCalendars = try? decoder.decode([GroupCalendar].self, from: savedEventsData) {
                        calendars = savedCalendars
                    }
                }
            })
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
