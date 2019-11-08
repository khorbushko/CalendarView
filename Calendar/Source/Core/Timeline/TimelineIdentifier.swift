//
//  TimelineIdentifier.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 05.11.2019.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

public enum TimelineIdentifier {

  case system(Calendar.Identifier)
  case custom(CustomTimeLineIdentifier)

  public static func == (lhs: Self, rhs: Self) -> Bool {
    switch (lhs, rhs) {
      case (.system(let xVal), .system(let yVal)) where xVal == yVal:
        return true
      case (.custom(let xVal), .custom(let yVal)) where xVal == yVal:
        return true
      default:
        return false
    }
  }
}
