//
//  CalendarViewAnimationType.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/3/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

/**
  Represent animation type for collection of dates shown in `CalendarView` on any date change

 - Tag: 2005
 - Version: 0.1
 */
public enum CalendarViewAnimationType: Int {

  /// Change without any animation
  case none

  /// Whole view will be slided
  case slide

  /// Signle element with date will be scaled in and change it opacity from 0 to 1, Default
  case scaleItem
}
