//
//  CalendarWeekSymbolType.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/3/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

/**
 Represent displaying weekDay Symbols

 - Tag: 2004
 - Version: 0.1
 */
public enum CalendarWeekSymbolType: Int {

  /// no symbols will be shown
  case none = 0

  ///The weekday symbol in very short style, ex: S
  case veryShort

  ///The weekday symbol in short style, ex: Sun
  case short

  ///The weekday symbol in full style, ex: Sunday
  case full
}
