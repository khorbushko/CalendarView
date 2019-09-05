//
//  CalendarSelectionType.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/3/19.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

/**
 Represent selection style of dates ion calendar

 - Tag: 2003
 - Version: 0.1
 */
public enum CalendarSelectionType {

  /// Allow to select only 1 date simulteniously
  /// Can be combined with [CalendarAppearenceOption](x-source-tag://2002) - `allowSingleDeselectionForSingleMode`
  case single
}
