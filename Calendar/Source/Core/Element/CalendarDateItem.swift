//
//  CalendarDateItem.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/3/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

/**
 Default implementation for build compomnents used in CalendarView
 
 - Tag: 1002
 - Version: 0.1
 */
public final class CalendarDateItem: CalendarDateItemPresentable, CalendarWeekDayItemPresentable {

  private let isHeader: Bool
  private var _subtitle: String?

  // MARK: - Init

  public required init(date: Date, timeline: Timeline) {
    let dateString = timeline.suggestedDisplayDateString(from: date)
    self.title = dateString

    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en")
    dateFormatter.dateFormat = "d"
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    let stringValueForSubtitle = dateFormatter.string(from: date)

    self._subtitle = stringValueForSubtitle
    self.isHeader = false
  }

  public required init(weekDayName: String, timeline: Timeline) {
    self.title = weekDayName
    self.isHeader = true
  }

  // MARK: - Props

  public static var calendarItemNib: UINib {
    return UINib.init(nibName: calendarItemIdentifier, bundle: Bundle(for: CalendarDateItem.self))
  }

  public static var classType: CalendarItemSelectable.Type {
    return CalendarViewCollectionViewCell.self
  }

  public static var calendarItemIdentifier: String {
    return String(describing: CalendarViewCollectionViewCell.self)
  }

  public var title: String

  public var subtitle: String? {
    return _subtitle
  }

  public var titleFont: UIFont {
    if isHeader {
      return UIFont.systemFont(ofSize: 14, weight: .bold)
    } else {
      return UIFont.systemFont(ofSize: 14, weight: .regular)
    }
  }
}
