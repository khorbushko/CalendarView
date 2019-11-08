//
//  Timeline.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 05.11.2019.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

final public class Timeline {

  private (set) var underlineCalendar: Calendar
  private (set) var underlineLocale: Locale
  private (set) var identifier: TimelineIdentifier

  internal private (set) var activeDate: Date = Date()
  internal var weekDayNameStyle: CalendarWeekSymbolType = .veryShort

  internal var dayNamesCount: Int {
    let count = weekDayNameStyle == .none ? 0 : Defines.Calendar.deysInWeek
    return count
  }

  lazy var ummAlQuraConverter: UmmAlQuaraDateConverter = {
    UmmAlQuaraDateConverter()
  }()

  var displayDates: [Date] {
    displayDatesForPrevMonth + displayDatesForCurrentMonth + displayDatesForNextMonth
  }

  private (set) var displayDatesForPrevMonth: [Date] = []
  private (set) var displayDatesForCurrentMonth: [Date] = []
  private (set) var displayDatesForNextMonth: [Date] = []

  private (set) var startIndex: Int = 0

  private var appearenceOptions: CalendarAppearenceOption = .default

  // MARK: - LifeCycle

  private init(_ calendar: Calendar, locale: Locale) {
    underlineCalendar = calendar
    underlineCalendar.timeZone = TimeZone.autoupdatingCurrent
    underlineLocale = locale
    identifier = .system(calendar.identifier)
  }

  convenience init(_ identifier: Calendar.Identifier, locale: Locale) {
    let calendar = Calendar(identifier: identifier)

    self.init(calendar, locale: locale)
  }

  init(_ identifier: CustomTimeLineIdentifier, locale: Locale) {
    switch identifier {
      case .ummAlQura:
        underlineCalendar = .init(identifier: .islamicUmmAlQura)
        underlineCalendar.timeZone = TimeZone.autoupdatingCurrent
    }

    underlineLocale = locale
    self.identifier = .custom(identifier)
  }

  // MARK: - Internal

  internal func adoptedDateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = underlineLocale
    dateFormatter.calendar = underlineCalendar

    return dateFormatter
  }

  internal func isDateInToday(_ date: Date) -> Bool {
    underlineCalendar.isDateInToday(date)
  }

  func prepareMonthTimelineForCurrentlySelectedDate() {
    prepareMonthTimelineFor(activeDate, options: appearenceOptions)
  }

  func prepareMonthTimelineFor(_ selectedDate: Date, options: CalendarAppearenceOption) {
    self.activeDate = selectedDate
    self.appearenceOptions = options

    displayDatesForPrevMonth.removeAll()
    displayDatesForCurrentMonth.removeAll()
    displayDatesForNextMonth.removeAll()

    guard let rangeOfDaysThisMonth = currentMonthRange() else {
      return
    }

    var currentComponents = currentMonthDateComponents()

    for idx in stride(from: rangeOfDaysThisMonth.lowerBound, to: rangeOfDaysThisMonth.upperBound, by: 1) {
      currentComponents.day = idx
      if let dateToShow = underlineCalendar.date(from: currentComponents) {
        displayDatesForCurrentMonth.append(dateToShow)
      } else {
        assertionFailure("can't generate date for selcted range")
      }
    }

    if !displayDates.isEmpty,
      let firstOfTheMonth = displayDates.first {
      let weekday = underlineCalendar.component(.weekday, from: firstOfTheMonth)

      if weekday == 7 {
        startIndex = dayNamesCount + (dayNamesCount - 1)
      } else {
        startIndex = ((weekday % 7) - 1) + dayNamesCount
      }
    }

    if appearenceOptions.showEnclosingMonths {
      guard let rangeOfDaysPrevMonth = prevMonthRange(),
        let rangeOfDaysNextMonth = nextMonthRange() else {
          return
      }

      let offsetForDate = startIndex - dayNamesCount

      var prevComponents = prevMonthDateComponents()
      for idx in stride(from: rangeOfDaysPrevMonth.upperBound - offsetForDate, to: rangeOfDaysPrevMonth.upperBound, by: 1) {
        prevComponents?.day = idx
        if let comp = prevComponents,
          let dateToShow = underlineCalendar.date(from: comp) {

          displayDatesForPrevMonth.append(dateToShow)
        } else {
          assertionFailure("can't generate date for selected prev month range")
        }
      }

      var nextComponents = nextMonthDateComponents()

      if let lastOfTheMonth = displayDatesForCurrentMonth.last {
        let weekday = underlineCalendar.component(.weekday, from: lastOfTheMonth)

        var daysToFetch = Defines.Calendar.deysInWeek - weekday

        if appearenceOptions.showConstantCount {
          let numberOfRows = 7
          if (displayDates.count + dayNamesCount + daysToFetch) < Defines.Calendar.deysInWeek * numberOfRows {
            daysToFetch += Defines.Calendar.deysInWeek
          }
        }

        if daysToFetch > 0 {

          for idx in stride(from: rangeOfDaysNextMonth.lowerBound, to: rangeOfDaysNextMonth.lowerBound + daysToFetch, by: 1) {
            nextComponents?.day = idx
            if let comp = nextComponents,
              let dateToShow = underlineCalendar.date(from: comp) {
              displayDatesForNextMonth.append(dateToShow)
            } else {
              assertionFailure("can't generate date for selected next month range")
            }
          }
        }
      }

      startIndex = dayNamesCount
    }
  }

  // MARK: - CollectionInfo

  func numberOfItemsInSection() -> Int {
    if appearenceOptions.showEnclosingMonths {
      return displayDates.count + dayNamesCount
    } else {
      return startIndex + displayDates.count
    }
  }

  // MARK: - Builders

  func MOCK() {
    switch self.identifier {
      case .system:
      break
      case .custom(let identifier):
        switch identifier {
          case .ummAlQura:
            break
      }
    }

  }

  // MARK: - PrevMonth Info

  private func prevMonthRange() -> Range<Int>? {
    if let prevMonthDate = underlineCalendar.prevMonth(from: activeDate) {
      return underlineCalendar.range(of: .day, in: .month, for: prevMonthDate)
    }

    return nil
  }

  private func prevMonthDateComponents() -> DateComponents? {
    if let prevMonthDate = underlineCalendar.prevMonth(from: activeDate) {
      let componentsToReturn = componentsFromDate(prevMonthDate)
      return componentsToReturn
    }

    return nil
  }

  // MARK: - CurrentMonth Info

  private func currentMonthRange() -> Range<Int>? {
    underlineCalendar.range(of: .day, in: .month, for: activeDate)
  }

  private func currentMonthDateComponents() -> DateComponents {
    switch self.identifier {
      case .system:
        let componentsToReturn = componentsFromDate(activeDate)
        return componentsToReturn
      case .custom(let identifier):
        switch identifier {
          case .ummAlQura:
            let components = ummAlQuraConverter.currentMonthDateComponents(from: activeDate)
            return components
      }
    }
  }

  // MARK: - NextMonth Info

  private func nextMonthRange() -> Range<Int>? {
    if let nextMonthDate = underlineCalendar.nextMonth(from: activeDate) {
      return underlineCalendar.range(of: .day, in: .month, for: nextMonthDate)
    }

    return nil
  }

  private func nextMonthDateComponents() -> DateComponents? {
    if let nextMonthDate = underlineCalendar.nextMonth(from: activeDate) {
      let componentsToReturn = componentsFromDate(nextMonthDate)
      return componentsToReturn
    }

    return nil
  }

  // MARK: - Config

  private func componentsFromDate(_ date: Date) -> DateComponents {
    var componentsToReturn = underlineCalendar.dateComponents([.day, .month, .year, .era, .weekday], from: date)
    componentsToReturn.timeZone = underlineCalendar.timeZone

    componentsToReturn.hour = 0
    componentsToReturn.minute = 0
    componentsToReturn.second = 0
    return componentsToReturn
  }

  // MARK: - DEBUG

  internal func debugDateDescription(_ interestedDate: Date) -> String {
    let dateFormatter = debugDateFormatter()
    let stringValue = dateFormatter.string(from: interestedDate)

    dateFormatter.calendar = Calendar(identifier: .gregorian)
    let gregStringValue = dateFormatter.string(from: interestedDate)

    let debugString = "\n\nclicked on - \n\(underlineCalendar.identifier) -> \(stringValue)\n\(Calendar.Identifier.gregorian) -> \(gregStringValue)"
    return debugString
  }

  private func debugDateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en")
    dateFormatter.timeZone = underlineCalendar.timeZone
    dateFormatter.dateFormat = "dd-MMMM-yyyy-EEEE"
    dateFormatter.calendar = underlineCalendar
    return dateFormatter
  }
}
