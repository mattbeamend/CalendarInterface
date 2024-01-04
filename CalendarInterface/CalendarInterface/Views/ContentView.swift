//
//  ContentView.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 28/09/2023.
//

// Todo:
// Fix home page layout on smaller devices



import SwiftUI

struct ContentView: View {
    
    init() {
        UIDatePicker.appearance().minuteInterval = 5
        // if first loaded, add personal calendar to user defaults
        let encoder = JSONEncoder()
        let initCalendars = [GroupCalendar(id: "1", name: "Personal", color: "#FF0000")]
        if((UserDefaults.standard.data(forKey: "calendars") == nil)) {
            if let encoded = try? encoder.encode(initCalendars) {
                UserDefaults.standard.set(encoded, forKey: "calendars")
            }
        }
    }
    
    @State var defaultCalendar: GroupCalendar = GroupCalendar(id: "1", name: "Personal", color: "#FF0000")
    @State var calendars: [GroupCalendar] = []
    @State var events: [Event] = []
    
    var body: some View {
        NavigationStack {
            TabView {
                Group {
                    HomeView(calendars: $calendars, events: $events, defaultCalendar: defaultCalendar)
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    ListCalendarView(calendars: $calendars, events: $events, defaultCalendar: defaultCalendar)
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
                .toolbarBackground(Color.white, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
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
                        calendars =  savedCalendars
                    }
                }
                print("DATA FETCHED")
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
