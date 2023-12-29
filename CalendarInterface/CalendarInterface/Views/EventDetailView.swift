//
//  EventDetailView.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 27/12/2023.
//


import SwiftUI

struct EventDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var editMode: Bool = false
    
    @State var events: [Event]
    @State var event: Event
    
    @State var editEventName: String = ""
    @State var editEventStart: Date = Date.now
    @State var editEventEnd: Date = Date.now
    @State var editEventColor: Color = Color.accentColor
    @State var editEventAllDay: Bool = false
    
    
    var body: some View {
        VStack {
            heading
        }
        ScrollView(.vertical) {
            if(editMode) {
                VStack {
                    editName
                    editAllDay
                    editTimings
                    editColor
                    deleteEventButton
                    Spacer()
                }
            } else {
                VStack {
                    eventName
                    timings
                    Spacer()
                }
                .highPriorityGesture(DragGesture().onEnded({ gesture in
                    if gesture.translation.width > 0 { // swipe back (right)
                        presentationMode.wrappedValue.dismiss()
                    }
                }))
            }
        }
        .navigationBarBackButtonHidden()
    }
}

extension EventDetailView {
    
    private var heading: some View {
        HStack {
            if(!editMode) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.white)
                })
                .frame(width: 55, alignment: .leading)
            } else {
                Button(action: {
                    withAnimation(.easeInOut) {
                        editMode = false
                    }
                }, label: {
                    Text("Cancel")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white)
                })
                .frame(width: 55, alignment: .leading)
            }
            
            Spacer()
            Text("Event")
                .foregroundStyle(Color.white)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            Spacer()
            
            
            if(editMode) {
                // Save Button
                Button(action: {
                    withAnimation(.easeInOut) {
                        event.name = editEventName
                        event.start = editEventStart
                        event.end = editEventEnd
                        event.color = editEventColor.toHex() ?? "#00000"
                        event.allDay = editEventAllDay
                        editMode = false
                        if let index = events.firstIndex(where: { $0.id == event.id}) {
                            events[index] = event
                        }
                        let encoder = JSONEncoder()
                        if let encoded = try? encoder.encode(events) {
                            UserDefaults.standard.set(encoded, forKey: "events")
                        }
                    }
                }, label: {
                    Text("Save")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white)
                })
                .frame(width: 55, alignment: .trailing)
            } else {
                // Edit Button
                Button(action: {
                    withAnimation(.easeInOut) {
                        editEventName = event.name
                        editEventStart = event.start
                        editEventEnd = event.end
                        editEventColor = Color(hex: event.color) ?? Color.accentColor
                        editEventAllDay = event.allDay
                        editMode = true
                    }
                }, label: {
                    Text("Edit")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white)
                })
                .frame(width: 55, alignment: .trailing)
            }
            
        
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
    
    private var eventName: some View {
        HStack(spacing: 5) {
            Circle()
                .foregroundStyle(Color(hex: event.color) ?? Color.accentColor)
                .frame(width: 25, height: 25)
                .padding(15)
            Text(event.name)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .padding(.vertical)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(hex: event.color)?.opacity(0.2) ?? Color.accentColor.opacity(0.2))
        )
        .padding(10)
    }
    
    private var timings: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("From")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.black.opacity(0.5))
            HStack(spacing: 20) {
                Text(event.start.getFullDate())
                    .font(.system(size: 18, weight: .medium))
                Spacer()
                if(!event.allDay) {
                    Text(event.start.getTimeString())
                        .font(.system(size: 18, weight: .medium))
                }
            }
            Divider().frame(height: 40)
            Text("To")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.black.opacity(0.5))
            HStack(spacing: 20) {
                Text(event.end.getFullDate())
                    .font(.system(size: 18, weight: .medium))
                Spacer()
                if(!event.allDay) {
                    Text(event.end.getTimeString())
                        .font(.system(size: 18, weight: .medium))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(15)
    }
    
    private var editName: some View {
        TextField("Event name", text: $editEventName)
            .font(.system(size: 18, weight: .regular, design: .rounded))
            .padding()
            .submitLabel(.done)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.4))
            )
            .padding(10)
    }
    
    private var editColor: some View {
        ColorPicker(selection: $editEventColor, label: {
            Text("Event Color")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.black)
        })
        .padding(10)
        .padding(.top, 15)
        .padding(.trailing)
    }
    
    private var editAllDay: some View {
        HStack {
            Text("Date")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.5))
            Spacer()
            Toggle(isOn: $editEventAllDay) {
                Text("All day event")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.black)
            }
        }
        .padding(10)
        .padding(.bottom, 10)
    }
    
    private var editTimings: some View {
        VStack(spacing: 20) {
            DatePicker("Start", selection: $editEventStart, displayedComponents: !editEventAllDay ? [.hourAndMinute, .date] : .date)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.black)
                .frame(height: 50)
            Divider()
            DatePicker("Finish", selection: $editEventEnd, in: (Calendar.current.date(byAdding: .minute, value: 5, to: editEventStart) ?? Date.now)..., displayedComponents: !editEventAllDay ? [.hourAndMinute, .date] : .date)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.black)
                .frame(height: 50)

        }
        .padding(10)
    }
    
    private var deleteEventButton: some View {
        Button(action: {
            if let index = events.firstIndex(where: { $0.id == event.id}) {
                events.remove(at: index)
            }
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(events) {
                UserDefaults.standard.set(encoded, forKey: "events")
            }
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Delete Event")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.red)
                )
                .padding(30)
        })
    }
}

//#Preview {
//    EventDetailView(event: Event(id: "2", name: "Football Practice", start: stringToDate(dateString: "2023-12-14T6:30:00+0000"), end: stringToDate(dateString: "2023-12-14T8:00:00+0000"), color: Color.blue.toHex() ?? "#000000", allDay: false))
//}
