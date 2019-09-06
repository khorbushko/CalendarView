//
//  CalendarMonth.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/2/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

/**
 - Tag: 3001
 - Version: 0.1
 */
public struct CalendarMonth {

  let index: Int
  let name: String
  let calendar: Calendar
  let locale: Locale

  public init?(date: Date, calendar: Calendar.Identifier, locale: Locale) {
    var targetCalendar = Calendar(identifier: calendar)
    targetCalendar.locale = locale
    self.calendar = targetCalendar
    self.locale = locale

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "LLLL"
    dateFormatter.calendar = targetCalendar
    dateFormatter.locale = locale
    self.name = dateFormatter.string(from: date)

    dateFormatter.dateFormat = "MM"
    let indexString = dateFormatter.string(from: date)
    if let idx = Int(indexString) {
      self.index = idx
    } else {
      return nil
    }
  }

  public init?(index: Int, calendar: Calendar.Identifier, locale: Locale) {
    if index > 0 && index <= 12 {
      var targetCalendar = Calendar(identifier: calendar)
      targetCalendar.locale = locale

      self.calendar = targetCalendar
      self.index = index
      self.locale = locale

      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MM"
      dateFormatter.calendar = targetCalendar
      dateFormatter.locale = locale

      if let date = dateFormatter.date(from: "\(index)") {
        dateFormatter.dateFormat = "LLLL"
        let name = dateFormatter.string(from: date)
        self.name = name
      } else {
        return nil
      }
    } else {
      return nil
    }
  }

  public init?(name: String, calendar: Calendar.Identifier, locale: Locale) {
    var targetCalendar = Calendar(identifier: calendar)
    targetCalendar.locale = locale

    self.calendar = targetCalendar
    self.name = name
    self.locale = locale

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "LLLL"
    dateFormatter.calendar = targetCalendar
    dateFormatter.locale = locale

    if let date = dateFormatter.date(from: name) {
      dateFormatter.dateFormat = "MM"
      let indexString = dateFormatter.string(from: date)
      if let idx = Int(indexString) {
        self.index = idx
      } else {
        return nil
      }
    } else {
      return nil
    }
  }
}
