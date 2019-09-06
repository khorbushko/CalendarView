//
//  CalendarYear.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/2/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

/**
 Represent Year with en locale

 - Tag: 3000
 - Version: 0.1
 */
public struct CalendarYear {

  let value: Int

  public init?(date: Date, calendar: Calendar.Identifier, locale: Locale) {
    var targetCalendar = Calendar(identifier: calendar)
    targetCalendar.locale = locale

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    dateFormatter.calendar = targetCalendar
    dateFormatter.locale = Locale(identifier: "en")
    let year = dateFormatter.string(from: date)

    if let idx = Int(year) {
      self.value = idx
    } else {
      return nil
    }
  }

  public init?(value: Int) {
    if value >= 0 {
      self.value = value
    } else {
      return nil
    }
  }
}
