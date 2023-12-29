//
//  Event.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 28/09/2023.
//

import Foundation
import SwiftUI

struct Event: Identifiable, Hashable, Codable {
    var id: String
    var name: String
    var start: Date
    var end: Date
    var color: String
    var allDay: Bool
    var calendarId: String
}
