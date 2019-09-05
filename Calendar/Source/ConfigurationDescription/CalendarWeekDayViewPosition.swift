//
//  WeekDayViewPosition.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/3/19.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

/**
  Represent week day position

  First - 0, Monday

 - Tag: 2000
 - Version: 0.1
 */
public enum CalendarWeekDayViewPosition: Int, CaseIterable {

  /// 0, Sunday
  case first

  /// 1, Monday
  case second

  /// 2, Tuesday
  case third

  /// 4, Wednesday
  case fourth

  /// 5, Thursday
  case fifth

  /// 6, Friday
  case six

  /// 7, Saturday
  case seventh
}
