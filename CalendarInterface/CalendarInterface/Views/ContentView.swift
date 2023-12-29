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
    
    var body: some View {
        ListCalendarView()
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
