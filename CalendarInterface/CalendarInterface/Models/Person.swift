//
//  Person.swift
//  CalendarInterface
//
//  Created by Matthew Smith on 02/01/2024.
//

import Foundation

struct Person: Identifiable, Hashable, Codable {
    var id: String
    var username: String
    var name: String
}
