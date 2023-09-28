//
//  CalendarView.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 28/09/2023.
//

import SwiftUI

struct CalendarView: View {
    
    // NOTE: You should convert start/end times from local to UTC timezone before storing.
    // Swift will then automatically convert back to local timezone when Date object is created.
    
    // Test data must also use UTC timezone
    let events = [
        Event(id: "1", name: "Football Practice", start: stringToDate(dateString: "2023-09-28T10:00:00+0000"), end: stringToDate(dateString: "2023-09-28T11:45:00+0000"))
    ]
    
    var body: some View {
        ScrollView {
            ZStack {
                grid
                VStack {
                    EventBlock(event: events.first!)
                    Spacer()
                }
                .offset(y: 10)
                
            }
        }
    }
}

extension CalendarView {
    
    private var grid: some View {
        VStack {
            ForEach(0..<24) { i in
                HourCell(hour: i)
            }
        }
    }
    
    @ViewBuilder
    private func HourCell(hour: Int) -> some View {
        VStack {
            HStack {
                Text("\(hour < 10 ? "0" : "")\(hour):00")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color.black.opacity(0.4))
                    .frame(width: 50, height: 20, alignment: .center)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.black.opacity(0.1))
            }
            Spacer()
                .frame(height: 40)
        }
    }
    
    @ViewBuilder
    private func EventBlock(event: Event) -> some View {
        Rectangle()
            .frame(width: 150, height: calculateDuration(event: event))
            .foregroundColor(Color.blue)
            .offset(y: calculatePosition(event: event))
    }
}

func stringToDate(dateString: String) -> Date {
    let formatter = ISO8601DateFormatter()
    return formatter.date(from: dateString) ?? Date.now
}

func calculatePosition(event: Event) -> CGFloat {
    let hour = Calendar.current.component(.hour, from: event.start)
    let minutes = Calendar.current.component(.minute, from: event.start)
    return CGFloat((hour * 60) + minutes)
}

func calculateDuration(event: Event) -> CGFloat {
    // event duration in minutes
    let duration = event.end.timeIntervalSince(event.start)/60
    return CGFloat(duration)
}


struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
