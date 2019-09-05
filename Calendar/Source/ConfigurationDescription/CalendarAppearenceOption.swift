//
//  CalendarAppearenceOption.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/3/19.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

/**
  Option that represent different aspects of calendar view appearence
  also my influence to the behavior of calendar view

 - Tag: 2002
 - Version: 0.1
 */
public struct CalendarAppearenceOption: OptionSet {

  public let rawValue: Int

  public init(rawValue: Int) {
    self.rawValue = rawValue
  }

  /// This option allow some debug prints, usefull for checking behaviour of different calendar
  /// as result u will see date in selected calendar and in gregorian calendar in same line
  public static let debugMode = CalendarAppearenceOption(rawValue: 1 << 0)

  /// Enable enclosing (prev and next) month to be displayed
  public static let showEnclosingMonth = CalendarAppearenceOption(rawValue: 1 << 1)

  /// If enabled **showEnclosingMonth** option, this option will allow date selection for non selected month
  public static let enableEnclosingMonthSelection = CalendarAppearenceOption(rawValue: 1 << 2)

  /// If enabled **showEnclosingMonth** option, day's that are in current month will be hightlighted
  public static let hightlightCurrentMonth = CalendarAppearenceOption(rawValue: 1 << 3)

  /// If selected `CalendarSelectionType.single`, this option may enable deselect already selected item
  public static let allowSingleDeselectionForSingleMode = CalendarAppearenceOption(rawValue: 1 << 4)

  /// Represent set of minimal (non) option for calendar
  public static let noOption: CalendarAppearenceOption = []

  /// Default set of options for calendar - `showEnclosingMonth` and `hightlightCurrentMonth`
  public static let `default`: CalendarAppearenceOption = [] //[.showEnclosingMonth, .hightlightCurrentMonth, .debugMode]
}
