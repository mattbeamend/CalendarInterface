//
//  ContentView.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 28/09/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ListCalendarView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
