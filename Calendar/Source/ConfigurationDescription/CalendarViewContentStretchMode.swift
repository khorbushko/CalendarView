//
//  CalendarViewContentShrinkMode.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/6/19.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

/**

 Represent available content stretch modes types in `CalendarView`

 - Tag: 2007
 - Version: 0.1
 */
public enum CalendarViewContentStretchMode {

  /// all content will be centered with minimum interitem spacing, trying to fit 1:1 aspect
  case center

  /// all content will be displayed at max width, Default value
  case fillWidth
}
