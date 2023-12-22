//
//  CreateEventView.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 22/12/2023.
//

import SwiftUI

struct CreateEventView: View {
    
    var selectedDate: Date
    
    var body: some View {
        VStack {
            Text(selectedDate.getFullDate())
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Create Event")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.black)
            }
        }
    }
}

#Preview {
    CreateEventView(selectedDate: stringToDate(dateString: "2023-09-24T8:00:00+0000"))
}
