//
//  Timeline.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 05.11.2019.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

/**
 Object that responsible for generating ranges of dates for selected TimelineIdentifier model
 also holds info about current date source, selected calendar and locale

 - Version: 0.21
 - Tag: 1003
 */

@dynamicMemberLookup
final public class Timeline {

  subscript<T>(dynamicMember keyPath: KeyPath<TimeLineGenerator, T>) -> T {
    return engine[keyPath: keyPath]
  }

  private var engine: TimeLineGenerator

  private (set) var identifier: TimelineIdentifier

  internal private (set) var activeDate: Date = Date()
  internal var weekDayNameStyle: CalendarWeekSymbolType = .veryShort

  internal var dayNamesCount: Int {
    let count = weekDayNameStyle == .none ? 0 : Defines.Calendar.deysInWeek
    return count
  }

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
    var calendarObj = calendar
    calendarObj.timeZone = TimeZone.autoupdatingCurrent
    calendarObj.locale = locale

    identifier = .system(calendar.identifier)
    engine = calendarObj
  }

  convenience init(_ identifier: Calendar.Identifier, locale: Locale) {
    let calendar = Calendar(identifier: identifier)

    self.init(calendar, locale: locale)
  }

  init(_ identifier: CustomTimeLineIdentifier, locale: Locale) {
    switch identifier {
      case .ummAlQura:
        engine = UmmAlQuraTimeLineGenerator(locale: locale)
    }

    self.identifier = .custom(identifier)
  }

  // MARK: - Public

  func suggestedDisplayDateString(from date: Date) -> String {

    switch identifier {
      case .system:
        let dateFormatter = DateFormatter()
        dateFormatter.locale = self.underlineLocale
        dateFormatter.calendar = self.underlineCalendar
        dateFormatter.dateFormat = "d"
        let dateString = dateFormatter.string(from: date)
        return dateString

      case .custom(let cutomCalendarEngine):
        switch cutomCalendarEngine {
          case .ummAlQura:
            let comp = UmmAlQuraDateConverter().convertDateToUmmAlQura(date: date)
            let dateString = "\(comp.0)"

            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "ar")
            if let localized = formatter.string(from: NSNumber(value: comp.0)) {
              return "\(localized)"
            }

            return dateString
      }
    }
  }

  // MARK: - Internal

  internal func adoptedDateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = engine.underlineLocale
    dateFormatter.calendar = engine.underlineCalendar

    return dateFormatter
  }

  internal func isDateInToday(_ date: Date) -> Bool {
    engine.isDateInTodayDate(date)
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
      if let dateToShow = engine.dateFromComponents(currentComponents) {

        displayDatesForCurrentMonth.append(dateToShow)
      } else {
        assertionFailure("can't generate date for selcted range")
      }
    }

    if !displayDates.isEmpty,
      let firstOfTheMonth = displayDates.first {
      let weekday = engine.weekdayIndexFromDate(firstOfTheMonth)

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
            let dateToShow = engine.dateFromComponents(comp) {

          displayDatesForPrevMonth.append(dateToShow)
        } else {
          assertionFailure("can't generate date for selected prev month range")
        }
      }

      var nextComponents = nextMonthDateComponents()
      if let lastOfTheMonth = displayDatesForCurrentMonth.last {
          let weekday = engine.weekdayIndexFromDate(lastOfTheMonth)

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
              let dateToShow = engine.dateFromComponents(comp) {

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

  // MARK: - Engine

  // MARK: - PrevMonth Info

  private func prevMonthRange() -> Range<Int>? {
    engine.prevMonthRange(activeDate)
  }

  private func prevMonthDateComponents() -> DateComponents? {
    engine.prevMonthDateComponents(activeDate)
  }

  // MARK: - CurrentMonth Info

  private func currentMonthRange() -> Range<Int>? {
    engine.currentMonthRange(activeDate)
  }

  private func currentMonthDateComponents() -> DateComponents {
    engine.currentMonthDateComponents(activeDate)
  }

  // MARK: - NextMonth Info

  private func nextMonthRange() -> Range<Int>? {
    engine.nextMonthRange(activeDate)
  }

  private func nextMonthDateComponents() -> DateComponents? {
    engine.nextMonthDateComponents(activeDate)
  }

  // MARK: - DEBUG

  internal func debugDateDescription(_ interestedDate: Date) -> String {
    engine.debugDateDescription(interestedDate)
  }
}
