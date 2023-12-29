//
//  CreateCalendarView.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 29/12/2023.
//

import SwiftUI

struct AddCalendarView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var focused: Bool?
    
    @Binding var calendars: [GroupCalendar]
    
    @State var calendarName: String = ""
    @State var calendarColor: Color = Color.accentColor
    
    
    var body: some View {
        VStack {
            heading
            calendarTextField
            colorPicker
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

extension AddCalendarView {
    
    private var heading: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.white)
            })
            .frame(width: 50, alignment: .leading)
            Spacer()
            Text("Add Calendar")
                .foregroundStyle(Color.white)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            Spacer()
            Button(action: {
                self.createCalendar()
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Done")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white)
            })
            .frame(width: 50, alignment: .trailing)
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
    
    private var calendarTextField: some View {
        VStack(alignment: .leading, spacing: 15) {
            TextField("Calendar name", text: $calendarName)
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .padding()
                .submitLabel(.done)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4))
                )
                .focused($focused, equals: true)
                .onAppear {
                    self.focused = true
                }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 20)
    }
    
    private var colorPicker: some View {
        ColorPicker(selection: $calendarColor, label: {
            Text("Calendar Theme")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.black)
        })
        .padding(10)
        .padding(.trailing)
    }
    
    private func createCalendar() {
        let calendar = GroupCalendar(id: UUID().uuidString, name: calendarName, color: calendarColor.toHex() ?? "#000000")
        if(calendar.name.isEmpty) { return }
        print(calendar)
        calendars.append(calendar)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(calendars) {
            UserDefaults.standard.set(encoded, forKey: "calendars")
        }
    }
}


