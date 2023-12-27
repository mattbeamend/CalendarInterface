//
//  CreateEventView.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 22/12/2023.
//


import SwiftUI

struct CreateEventView: View {
    
    @Binding var events: [Event]
    
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var focused: Bool?
    
    @State var showSelectStart: Bool = false
    @State var showSelectFinish: Bool = false
    @State var showEventColor: Bool = false
    
    @State var startTime: Date
    @State var finishTime: Date = Date.now
    @State var isAllDay: Bool = false
    @State var eventTitle: String = ""
    @State var eventColor: Color = Color.accentColor
    
    var body: some View {
        VStack {
            heading
            ScrollView(.vertical) {
                VStack {
                    eventTextField
                    allDayToggle
                    datePicker
                    colorPicker
                }
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: {
            // change start time to have same hour/minutes as users current time and round to nearest 5 minutes
            let dateMinutes = Calendar.current.dateComponents([.hour, .minute], from: Date.now)
            self.startTime = Calendar.current.date(bySettingHour: dateMinutes.hour ?? 0, minute: dateMinutes.minute ?? 0, second: 0, of: startTime)?.roundToNearestFiveMinutes() ?? startTime
            // set default finish time to 5 minutes after start time
            self.finishTime = Calendar.current.date(byAdding: .hour, value: 1, to: startTime) ?? Date.now
        })
    }
}

extension CreateEventView {
    
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
            Text("Create Event")
                .foregroundStyle(Color.white)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            Spacer()
            Button(action: {
                self.createEvent()
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
    
    private var eventTextField: some View {
        VStack(alignment: .leading, spacing: 15) {
            TextField("Event name", text: $eventTitle)
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
    
    private var allDayToggle: some View {
        HStack {
            Text("Date")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.5))
            Spacer()
            Toggle(isOn: $isAllDay) {
                Text("All day event")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.black)
            }
        }
        .padding(10)
        .padding(.bottom, 10)
    }
    
    private var datePicker: some View {
        VStack(spacing: 20) {
            DatePicker("Start", selection: $startTime, displayedComponents: !isAllDay ? [.hourAndMinute, .date] : .date)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.black)
                .frame(height: 50)
            Divider()
            DatePicker("Finish", selection: $finishTime, in: (Calendar.current.date(byAdding: .minute, value: 5, to: startTime) ?? Date.now)..., displayedComponents: !isAllDay ? [.hourAndMinute, .date] : .date)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.black)
                .frame(height: 50)

        }
        .padding(10)
    }
    
    private var colorPicker: some View {
        ColorPicker(selection: $eventColor, label: {
            Text("Event Color")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.black)
        })
        .padding(10)
        .padding(.top, 15)
        .padding(.trailing)
    }
    
    private func createEvent() {
        // TODO: need to santise inputs, check for missing information
        
        var event = Event(id: UUID().uuidString, name: eventTitle, start: startTime, end: finishTime, color: eventColor.toHex() ?? "#000000", allDay: isAllDay)
        if(event.start > event.end) {
            event.end = event.start
        }
        print(event)
        events.append(event)
//        do {
//            // 1
//            let encodedData = try JSONEncoder().encode(events)
//            let userDefaults = UserDefaults.standard
//            // 2
//            userDefaults.set(encodedData, forKey: "events")
//
//        } catch {
//            print("failed to save to user defaults")
//        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(events) {
            UserDefaults.standard.set(encoded, forKey: "events")
        }
    }
    
}


//#Preview {
//    CreateEventView(events: [], startTime: stringToDate(dateString: "2023-09-24T8:00:00+0000"))
//}
