//
//  MyDateItem.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/4/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

final class MyDateItem: CalendarDateItemPresentable, CalendarWeekDayItemPresentable {

  // MARK: - Init

  var colorForToday: UIColor {
    return UIColor.orange
  }

  var selectionColor: UIColor {
    return UIColor.purple
  }

  var titleFont: UIFont {
    return UIFont.systemFont(ofSize: 16, weight: .regular)
  }

  var subtitle: String? {
    let obj = "🛠👮🏿‍♂️🦷🥶".randomElement() ?? "x"
    return (Int.random(in: 0...1000) % 2) == 0 ? String(obj) : nil
  }

  var subtitleColor: UIColor? {
    return UIColor.red
  }

  var subtitleFont: UIFont? {
    return UIFont.systemFont(ofSize: 10, weight: .bold)
  }

  public required init(date: Date, calendar: Calendar, locale: Locale) {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = locale
    dateFormatter.calendar = calendar
    dateFormatter.dateFormat = "d"

    let stringValue = dateFormatter.string(from: date)
    self.title = stringValue
  }

  public required init(weekDayName: String, calendar: Calendar, locale: Locale) {
    self.title = weekDayName
  }

  var title: String

  public static var calendarItemNib: UINib {
    return UINib.init(nibName: calendarItemIdentifier, bundle: Bundle(for: MyCustomCell.self))
  }

  public static var classType: CalendarItemSelectable.Type {
    return MyCustomCell.self
  }

  public static var calendarItemIdentifier: String {
    return String(describing: MyCustomCell.self)
  }
}
