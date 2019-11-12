//
//  TimeLineDataProvidable.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 06.11.2019.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

typealias TimeLineGenerator = TimelineDataProvidable & TimeLineDataProviderDebugInfoProvidable

protocol TimelineDataProvidable {

  // MARK: - Init

  var underlineCalendar: Calendar { get }

  var underlineLocale: Locale { get }

  // MARK: - Date processing

  func isDateInTodayDate(_ date: Date) -> Bool

  func dateFromComponents(_ dateComponents: DateComponents) -> Date?

  func weekdayIndexFromDate(_ date: Date) -> Int

  // MARK: - Generation

  func prevMonthRange(_ currentDate: Date) -> Range<Int>?

  func prevMonthDateComponents(_ currentDate: Date) -> DateComponents?

  func currentMonthRange(_ currentDate: Date) -> Range<Int>?

  func currentMonthDateComponents(_ currentDate: Date) -> DateComponents

  func nextMonthRange(_ currentDate: Date) -> Range<Int>?

  func nextMonthDateComponents(_ currentDate: Date) -> DateComponents?
}

protocol TimeLineDataProviderDebugInfoProvidable {

  func debugDateDescription(_ interestedDate: Date) -> String
}
