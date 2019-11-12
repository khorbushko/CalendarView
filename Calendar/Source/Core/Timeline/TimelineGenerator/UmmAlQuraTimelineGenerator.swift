//
//  UmmAlQuraTimelineGenerator.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 08.11.2019.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

final class UmmAlQuraTimeLineGenerator: TimeLineGenerator {

  private (set) var underlineCalendar: Calendar
  private (set) var underlineLocale: Locale

  private var underlineRefCalendar: Calendar = .init(identifier: .gregorian)
  private var dateConverter: UmmAlQuraDateConverter = UmmAlQuraDateConverter()

  // MARK: - LifeCycle

  init(locale: Locale) {
    underlineCalendar = Calendar(identifier: .islamicTabular)
    underlineLocale = locale
  }

  // MARK: - Date processing

  func isDateInTodayDate(_ date: Date) -> Bool {
    let today = Date()
    let todayComponents = dateConverter.convertDateToUmmAlQura(date: today)
    let inspectDateComponents = dateConverter.convertDateToUmmAlQura(date: date)

    return todayComponents.0 == inspectDateComponents.0 &&
            todayComponents.1 == inspectDateComponents.1 &&
            todayComponents.2 == inspectDateComponents.2
  }

  func dateFromComponents(_ dateComponents: DateComponents) -> Date? {
    if dateComponents.day != nil,
        dateComponents.month != nil,
          dateComponents.year != nil {
      let comp: DateTransfromedComponents = (dateComponents.day!, dateComponents.month!, dateComponents.year!)
      let gregComponents = dateConverter.convertToGregorian(hYear: comp.2, hMonth: comp.1, hDay: comp.0)

      let targetDate = dateConverter.convertComponentToDate(gregComponents, using: underlineRefCalendar)
      return targetDate
    }

    return nil
  }

  func weekdayIndexFromDate(_ date: Date) -> Int {
    dateConverter.weekdayUmmAlQura(from: date)
  }

  // MARK: - Generation

  func prevMonthRange(_ currentDate: Date) -> Range<Int>? {
    let prevMonthDate: DateTransfromedComponents = dateConverter.prevMonthInUmmAlQura(from: currentDate)
    let prevMonthDaysCount: Int = dateConverter.daysInMonth(year: prevMonthDate.2, month: prevMonthDate.1)
    let range = 1...prevMonthDaysCount
    return Range<Int>(range)
  }

  func prevMonthDateComponents(_ currentDate: Date) -> DateComponents? {
    let prevMonthComponents: DateTransfromedComponents = dateConverter.prevMonthInUmmAlQura(from: currentDate)
    let components: DateComponents = dateConverter.convertComponentToDateCompoment(prevMonthComponents)
    return components
  }

  func currentMonthRange(_ currentDate: Date) -> Range<Int>? {
    let currentMonthDate: DateTransfromedComponents = dateConverter.convertDateToUmmAlQura(date: currentDate)
    let currentMonthDaysCount: Int = dateConverter.daysInMonth(year: currentMonthDate.2, month: currentMonthDate.1)
    let range = 1...currentMonthDaysCount
    return Range<Int>(range)
  }

  func currentMonthDateComponents(_ currentDate: Date) -> DateComponents {
    let currentMonthDate: DateTransfromedComponents = dateConverter.convertDateToUmmAlQura(date: currentDate)
    let components: DateComponents = dateConverter.convertComponentToDateCompoment(currentMonthDate)
    return components
  }

  func nextMonthRange(_ currentDate: Date) -> Range<Int>? {
    let nextMonthDate: DateTransfromedComponents = dateConverter.nextMonthInUmmAlQura(from: currentDate)
    let nextMonthDaysCount: Int = dateConverter.daysInMonth(year: nextMonthDate.2, month: nextMonthDate.1)
    let range = 1...nextMonthDaysCount
    return Range<Int>(range)
  }

  func nextMonthDateComponents(_ currentDate: Date) -> DateComponents? {
    let nextMonthComponents: DateTransfromedComponents = dateConverter.nextMonthInUmmAlQura(from: currentDate)
    let components: DateComponents = dateConverter.convertComponentToDateCompoment(nextMonthComponents)
    return components
  }

  // MARK: - TimeLineDataProviderDebugInfoProvidable

  func debugDateDescription(_ interestedDate: Date) -> String {
    let current = "\(interestedDate)"

    let dateFormatter = debugDateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    let gregStringValue = dateFormatter.string(from: interestedDate)

    let debugString = "\n\nclicked on - UmmAlQura -> \(current)\n\(Calendar.Identifier.gregorian) -> \(gregStringValue)"
    return debugString
  }

  // MARK: - Private

  private func debugDateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en")
    dateFormatter.timeZone = underlineRefCalendar.timeZone
    dateFormatter.dateFormat = "dd-MMMM-yyyy-EEEE"
    dateFormatter.calendar = underlineRefCalendar
    return dateFormatter
  }
}

fileprivate extension UmmAlQuraDateConverter {

  // MARK: - PrevMonth

  func prevMonthInUmmAlQura(from gregorianDate: Date) -> DateTransfromedComponents {
    let targetDateComponent = self.convertDateToUmmAlQura(date: gregorianDate)
    let month = targetDateComponent.1
    let prevMonth = month == 0 ? 11 : (month - 1)
    var prevYear = targetDateComponent.2
    let day = 1
    if prevMonth == 11 {
      prevYear -= 1
    }

    let prevMonthComponents: DateTransfromedComponents = (day, prevMonth, prevYear)
    return prevMonthComponents
  }

  // MARK: - NextMonth

  func nextMonthInUmmAlQura(from gregorianDate: Date) -> DateTransfromedComponents {
    let targetDateComponent = self.convertDateToUmmAlQura(date: gregorianDate)
    let month = targetDateComponent.1
    let nextMonth = month == 11 ? 0 : (month + 1)
    var nextYear = targetDateComponent.2
    let day = 1
    if nextMonth == 0 {
      nextYear += 1
    }

    let nextMonthComponents: DateTransfromedComponents = (day, nextMonth, nextYear)
    return nextMonthComponents
  }

  // MARK: - Utils

  func convertComponentToDateCompoment(_ component: DateTransfromedComponents) -> DateComponents {
    var components = DateComponents()
    components.day = component.0
    components.month = component.1
    components.year = component.2

    return components
  }

  func convertComponentToDate(_ component: DateTransfromedComponents, using calendar: Calendar) -> Date? {
    let components: DateComponents = convertComponentToDateCompoment(component)
    let target = calendar.date(from: components)
    return target
  }
}
