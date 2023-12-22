//
//  DateTests.swift
//  CalendarInterfaceTests
//
//  Created by Matthew Smith on 08/10/2023.
//

import XCTest
import SwiftUI
@testable import CalendarInterface

final class DateTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStringToDate() throws {
        var dateComponents = DateComponents()
        dateComponents.year = 2023
        dateComponents.month = 1
        dateComponents.day = 1
        dateComponents.hour = 12
        dateComponents.minute = 0
        dateComponents.timeZone = TimeZone(abbreviation: "GMT")
        let userCalendar = Calendar(identifier: .gregorian)
        let testDate = userCalendar.date(from: dateComponents)!
        let testString = "2023-01-01T12:00:00+0000"
        let result = stringToDate(dateString: testString)
        XCTAssert(result == testDate, "\(result) should match \(testDate)")
    }
    
    func testStartOfMonth() throws {
        let testDate = stringToDate(dateString: "2023-01-02T12:00:00+0000")
        let startMonth = stringToDate(dateString: "2023-01-01T00:00:00+0000")
        let result = testDate.startOfMonth()
        XCTAssert(result == startMonth, "\(result) should match \(testDate)")
    }
    
    func testEndOfMonth() throws {
        let testDate = stringToDate(dateString: "2023-01-02T12:00:00+0000")
        let endMonth = stringToDate(dateString: "2023-01-31T00:00:00+0000")
        let result = testDate.endOfMonth()
        XCTAssert(result == endMonth, "\(result) should match \(testDate)")
    }
    
    func testGetDaysOfMonth() throws {
        let testDate = stringToDate(dateString: "2023-01-02T12:00:00+0000")
        let numberOfDays = 31
        let result = testDate.getDaysOfMonth()
        XCTAssert(result.count == numberOfDays, "\(result.count) should match \(numberOfDays)")
    }
    
    func testGetStartMonthPosition() throws {
        let testDate = stringToDate(dateString: "2023-01-02T12:00:00+0000")
        let position = 7
        let result = testDate.getStartMonthPosition()
        XCTAssert(result == position, "\(result) should match \(position)")
    }
    
    func testGetDateEvents() throws {
        let testDate = stringToDate(dateString: "2023-01-02T12:00:00+0000")
        let testEvents = [
            Event(id: "1", name: "Cambridge Trip", start: stringToDate(dateString: "2023-01-01T6:30:00+0000"), end: stringToDate(dateString: "2023-09-24T8:00:00+0000"), color: Color.purple, allDay: false),
            Event(id: "2", name: "Football Practice", start: stringToDate(dateString: "2023-09-14T6:30:00+0000"), end: stringToDate(dateString: "2023-09-14T8:00:00+0000"), color: Color.blue, allDay: false)
        ]
        let expected = [Event(id: "1", name: "Cambridge Trip", start: stringToDate(dateString: "2023-01-01T6:30:00+0000"), end: stringToDate(dateString: "2023-09-24T8:00:00+0000"), color: Color.purple, allDay: false)]
        let result = testDate.getDateEvents(events: testEvents)
        XCTAssert(result == expected, "\(result) should match \(expected)")
    }
    
    func testStartOfDay() throws {
        let testDate = stringToDate(dateString: "2023-01-02T12:00:00+0000")
        let startOfDay = stringToDate(dateString: "2023-01-02T00:00:00+0000")
        let result = testDate.startOfDay()
        XCTAssert(result == startOfDay, "\(result) should match \(startOfDay)")
    }
    
    func testEndOfDay() throws {
        let testDate = stringToDate(dateString: "2023-01-02T12:00:00+0000")
        let endOfDay = stringToDate(dateString: "2023-01-02T23:59:59+0000")
        let result = testDate.endOfDay()
        XCTAssert(result == endOfDay, "\(result) should match \(endOfDay)")
    }
    
    func testSameDay() throws {
        let testDate = stringToDate(dateString: "2023-01-02T12:00:00+0000")
        let sameDay = stringToDate(dateString: "2023-01-02T23:30:00+0000")
        let result = testDate.sameDay(date: sameDay)
        XCTAssert(result, "\(result) should return True")
    }
    
    func testGetDateString() throws {
        let testDate = stringToDate(dateString: "2023-01-02T12:00:00+0000")
        let date = "2"
        let result = testDate.getDateString()
        XCTAssert(result == date, "\(result) should match \(date)")
    }
    
    func testGetMonthString() throws {
        let testDate = stringToDate(dateString: "2023-01-02T12:00:00+0000")
        let month = "January"
        let result = testDate.getMonthString()
        XCTAssert(result == month, "\(result) should match \(month)")
    }
    
    func testGetYearString() throws {
        let testDate = stringToDate(dateString: "2023-01-02T12:00:00+0000")
        let year = "2023"
        let result = testDate.getYearString()
        XCTAssert(result == year, "\(result) should match \(year)")
    }
    
    func testGetTimeString() throws {
        let testDate = stringToDate(dateString: "2023-01-02T12:00:00+0000")
        let time = "12:00"
        let result = testDate.getTimeString()
        XCTAssert(result == time, "\(result) should match \(time)")
    }
    
    func testGetShortDate() throws {
        let testDate = stringToDate(dateString: "2023-01-02T12:00:00+0000")
        let shortDate = "Mon 2 Jan"
        let result = testDate.getShortDate()
        XCTAssert(result == shortDate, "\(result) should match \(shortDate)")
    }
    
    func testGetFullDate() throws {
        let testDate = stringToDate(dateString: "2023-01-02T12:00:00+0000")
        let fullDate = "Monday 2 January"
        let result = testDate.getFullDate()
        XCTAssert(result == fullDate, "\(result) should match \(fullDate)")
    }
    

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
