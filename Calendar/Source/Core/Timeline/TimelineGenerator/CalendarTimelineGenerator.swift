//
//  CalendarTimelineGenerator.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 08.11.2019.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

extension Calendar: TimeLineGenerator {

  // MARK: - TimelineDataProvidable

  var underlineCalendar: Calendar {
    self
  }

  var underlineLocale: Locale {
    self.locale ?? Locale(identifier: "en")
  }

  // MARK: - Date processing

  func isDateInTodayDate(_ date: Date) -> Bool {
    underlineCalendar.isDateInToday(date)
  }

  func dateFromComponents(_ dateComponents: DateComponents) -> Date? {
    underlineCalendar.date(from: dateComponents)
  }

  func weekdayIndexFromDate(_ date: Date) -> Int {
    underlineCalendar.component(.weekday, from: date)
  }

  // MARK: - Generation

  func prevMonthRange(_ currentDate: Date) -> Range<Int>? {
    if let prevMonthDate = underlineCalendar.prevMonth(from: currentDate) {
      return underlineCalendar.range(of: .day, in: .month, for: prevMonthDate)
    }

    return nil
  }

  func prevMonthDateComponents(_ currentDate: Date) -> DateComponents? {
    if let prevMonthDate = underlineCalendar.prevMonth(from: currentDate) {
      let componentsToReturn = componentsFromDate(prevMonthDate)
      return componentsToReturn
    }

    return nil
  }

  func currentMonthRange(_ currentDate: Date) -> Range<Int>? {
    underlineCalendar.range(of: .day, in: .month, for: currentDate)
  }

  func currentMonthDateComponents(_ currentDate: Date) -> DateComponents {
    let componentsToReturn = componentsFromDate(currentDate)
    return componentsToReturn
  }

  func nextMonthRange(_ currentDate: Date) -> Range<Int>? {
    if let nextMonthDate = underlineCalendar.nextMonth(from: currentDate) {
      return underlineCalendar.range(of: .day, in: .month, for: nextMonthDate)
    }

    return nil
  }

  func nextMonthDateComponents(_ currentDate: Date) -> DateComponents? {
    if let nextMonthDate = underlineCalendar.nextMonth(from: currentDate) {
      let componentsToReturn = componentsFromDate(nextMonthDate)
      return componentsToReturn
    }

    return nil
  }

  // MARK: - TimeLineDataProviderDebugInfoProvidable

  func debugDateDescription(_ interestedDate: Date) -> String {
    let dateFormatter = debugDateFormatter()
    let stringValue = dateFormatter.string(from: interestedDate)

    dateFormatter.calendar = Calendar(identifier: .gregorian)
    let gregStringValue = dateFormatter.string(from: interestedDate)

    let debugString = "\n\nclicked on - \n\(underlineCalendar.identifier) -> \(stringValue)\n\(Calendar.Identifier.gregorian) -> \(gregStringValue)"
    return debugString
  }

  // MARK: - Support

  private func debugDateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en")
    dateFormatter.timeZone = underlineCalendar.timeZone
    dateFormatter.dateFormat = "dd-MMMM-yyyy-EEEE"
    dateFormatter.calendar = underlineCalendar
    return dateFormatter
  }

  private func componentsFromDate(_ date: Date) -> DateComponents {
    var componentsToReturn = underlineCalendar.dateComponents([.day, .month, .year, .era, .weekday], from: date)
    componentsToReturn.timeZone = underlineCalendar.timeZone

    componentsToReturn.hour = 0
    componentsToReturn.minute = 0
    componentsToReturn.second = 0
    return componentsToReturn
  }
}
