//
//  CalendarWeekDayItemPresentable.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/3/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

/**
 Represent base constraints for data item that will be used for WEEKDAY name

 Inherits from [CalendarItemPresentable](x-source-tag://4000)

 - Tag: 4001
 - Version: 0.1
 */
public protocol CalendarWeekDayItemPresentable: CalendarItemPresentable {

  // MARK: - CalendarWeekDayItemPresentable

  /// Default initializator for CalendarDateItemPresentable
  ///  - Parameter calendar: Underline calendar that currently active in view
  ///  - Parameter locale: Locale that used within calendar.
  ///  - Parameter weekDayName: Proposed weekday name according to selected style, see [CalendarWeekSymbolType](x-source-tag://2004)
  init(weekDayName: String, calendar: Calendar, locale: Locale)
}
