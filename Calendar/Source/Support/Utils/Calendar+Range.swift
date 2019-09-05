//
//  Date+Range.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/2/19.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

extension Calendar {

  func nextMonth(from date: Date) -> Date? {
    let dateToReturn = self.date(byAdding: .month, value: 1, to: date)
    return dateToReturn
  }

  func prevMonth(from date: Date) -> Date? {
    let dateToReturn = self.date(byAdding: .month, value: -1, to: date)
    return dateToReturn
  }
}
