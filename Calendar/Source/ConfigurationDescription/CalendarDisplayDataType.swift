//
//  CalendarDisplayDataType.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/3/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

/**

 Represent available navigation types in `CalendarView`

 - Tag: 2006
 - Version: 0.1
 */
public enum CalendarDisplayDataType {

  /// navigate to month that contains today
  case today

  /// navigate to month that contains selected dates, first will be selected
  case selected

  /// navigate to month that contains specific date
  case date(Date)

  /// navigate to next month starting from selected
  case nextMonth

  /// navigate to prev month starting from selected
  case prevMonth
}
