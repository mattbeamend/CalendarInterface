//
//  CreateEventView.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 22/12/2023.
//


import SwiftUI

struct CreateEventView: View {
    
    
    @Binding var events: [Event]
    @Binding var calendars: [GroupCalendar]
    
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var focused: Bool?
    @State var initHasRun = false
    
    @State var showSelectStart: Bool = false
    @State var showSelectFinish: Bool = false
    @State var showEventColor: Bool = false
    
    @State var startTime: Date {
        didSet {
            print("updated")
            self.finishTime = Calendar.current.date(byAdding: .hour, value: 1, to: startTime) ?? Date.now
        }
    }
    @State var finishTime: Date = Date.now
    @State var isAllDay: Bool = false
    @State var eventTitle: String = ""
    @State var eventColor: Color = Color(hex: "#FF0000") ?? Color.accentColor
    
    @State var selectedCalendar: GroupCalendar = GroupCalendar(id: "1", name: "Personal", color: "#FF0000")
    
    var body: some View {
        VStack {
            heading
            ScrollView(.vertical) {
                VStack {
                    eventTextField
                    allDayToggle
                    datePicker
                    Divider().padding(10)
                    calendarSelector
                    Divider().padding(10)
                    colorPicker
                }
                .highPriorityGesture(DragGesture().onEnded({ gesture in
                    if gesture.translation.width > 0 { // swipe back (right)
                        presentationMode.wrappedValue.dismiss()
                    }
                }))
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: {
            if(!initHasRun) { // stops the values being reset when you visit a navigation link (i.e. calendar listing)
                // change start time to have same hour/minutes as users current time and round to nearest 5 minutes
                let dateMinutes = Calendar.current.dateComponents([.hour, .minute], from: Date.now)
                self.startTime = Calendar.current.date(bySettingHour: dateMinutes.hour ?? 0, minute: dateMinutes.minute ?? 0, second: 0, of: startTime)?.roundToNearestFiveMinutes() ?? startTime
                initHasRun = true
            }
        })
        .onChange(of: startTime) { newValue in
            self.finishTime = Calendar.current.date(byAdding: .hour, value: 1, to: startTime) ?? Date.now
        }
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
        .padding(.trailing)
    }
    
    private var calendarSelector: some View {
        VStack(alignment: .leading) {
            Text("Calendar")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.5))
                .padding(.bottom, 15)
            NavigationLink {
                CalendarListView(calendars: $calendars, selectedCalendar: $selectedCalendar, selectedColor: $eventColor)
            } label: {
                HStack(spacing: 5) {
                    Text("Select Calendar")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.black)
                    Spacer()
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(Color(hex: selectedCalendar.color) ?? Color.accentColor)
                    Text(selectedCalendar.name)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.black)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4))
                )
            }
        }
        .padding(10)
    }
    
    
    private func createEvent() {
        // TODO: need to santise inputs, check for missing information
        var event = Event(id: UUID().uuidString, name: eventTitle, start: startTime, end: finishTime, color: eventColor.toHex() ?? "#000000", allDay: isAllDay, calendarId: selectedCalendar.id)
        if(event.name.isEmpty) { return }
        if(event.start > event.end) {
            event.end = event.start
        }
        print(event)
        events.append(event)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(events) {
            UserDefaults.standard.set(encoded, forKey: "events")
        }
    }
    
}

struct CalendarListView: View {
    
    // need to fetch the calendars the user is a member of
    @Binding var calendars: [GroupCalendar]
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedCalendar: GroupCalendar
    @Binding var selectedColor: Color
    
    var body: some View {
        VStack {
            heading
            List(calendars) { calendar in
                Button {
                    selectedCalendar = calendar
                    selectedColor = Color(hex: calendar.color) ?? Color.accentColor
                } label: {
                    HStack(spacing: 10) {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundStyle(Color(hex: calendar.color) ?? Color.accentColor)
                        Text(calendar.name)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.black)
                        Spacer()
                        if(selectedCalendar == calendar) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(Color.black)
                        }
                    }
                }
            }
            .listStyle(.grouped)
        }
        .navigationBarBackButtonHidden()
        .highPriorityGesture(DragGesture().onEnded({ gesture in
            if gesture.translation.width > 0 { // swipe back (right)
                presentationMode.wrappedValue.dismiss()
            }
        }))
    }
    
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
            Text("Your Calendars")
                .foregroundStyle(Color.white)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            Spacer()
            Spacer()
            .frame(width: 50, alignment: .trailing)
        }
        .padding(15)
        .padding(.bottom, 5)
        .background(
            Rectangle()
                .foregroundStyle(Color.black.opacity(0.9))
                .ignoresSafeArea()
        )
        
    }
}




//#Preview {
//    CreateEventView(events: [], startTime: stringToDate(dateString: "2023-09-24T8:00:00+0000"))
//}
