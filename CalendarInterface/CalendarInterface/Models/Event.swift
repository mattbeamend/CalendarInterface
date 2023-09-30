//
//  Event.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 28/09/2023.
//

import Foundation
import SwiftUI

struct Event: Identifiable, Hashable {
    var id: String
    var name: String
    var start: Date
    var end: Date
    var color: Color
    var allDay: Bool
}
