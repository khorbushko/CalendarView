//
//  ViewController.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/2/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

  @IBOutlet private weak var label: UILabel!
  @IBOutlet private weak var calendarView: CalendarView! {
    didSet {
      calendarView.dateSelectionDelegate = self
    }
  }

  // MARK: - Debug

  @IBAction private func todayAction(_ sender: Any) {
    calendarView.switchTo(.today)
  }

  @IBAction private func nextAction(_ sender: Any) {
    calendarView.switchTo(.nextMonth)
  }

  @IBAction private func prevAction(_ sender: Any) {
    calendarView.switchTo(.prevMonth)
  }

  @IBAction private func selectedDate(_ sender: UIButton) {
    calendarView.switchTo(.selected)
  }

  @IBAction private func gregorianCalenda(_ sender: Any) {
    calendarView.switchToCalendarType(.gregorian, locale: Locale(identifier: "en"))
  }

  @IBAction private func hijryCalendar(_ sender: Any) {
    calendarView.switchToCalendarType(.islamicUmmAlQura, locale: Locale(identifier: "ar"))
  }

  @IBAction private func changeYear(_ sender: UIStepper) {
    if let year = CalendarYear(value: Int(sender.value)) {
      calendarView.changeCurrentDate(year: year)
    }
  }

  @IBAction private func changeMonth(_ sender: UIStepper) {
    if let month = CalendarMonth(index: Int(sender.value), calendar: .gregorian, locale: Locale(identifier: "en")) {
      calendarView.changeCurrentDate(month: month)
    }
  }

  @IBAction private func stepChanged(_ sender: UISegmentedControl) {

    let selected = sender.selectedSegmentIndex
    if let value = CalendarWeekSymbolType(rawValue: selected) {
      calendarView.changeWeekDayStyle(value)
    }
  }

  @IBAction private func customCells(_ sender: UIButton) {
    if calendarView.itemProviderDelegate == nil {
      calendarView.itemProviderDelegate = self
      sender.setTitle("default cells", for: .normal)
    } else {
      calendarView.itemProviderDelegate = nil
      calendarView.clearSelection()
      sender.setTitle("custom cells", for: .normal)
    }

    calendarView.forceReload()
  }
}

extension ViewController: CalendarViewDateSelectionEventDelegate {
  func calendarView(_ calendarView: CalendarView, configuredFor calendar: Calendar, and locale: Locale, shouldSelect date: Date) -> Bool {
    return true
  }

  func calendarView(_ calendarView: CalendarView, configuredFor calendar: Calendar, and locale: Locale, didDetectDateSelectionChangeFor date: Date, selectionType: CalendarDateSelectionOperation) {

    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en")
    dateFormatter.timeZone = calendar.timeZone
    dateFormatter.dateFormat = "dd-MMMM-yyyy-EEEE"
    dateFormatter.calendar = calendar
    let stringValue = dateFormatter.string(from: date)

    dateFormatter.calendar = Calendar(identifier: .gregorian)
    let gregStringValue = dateFormatter.string(from: date)

    label.text =
"""
    \(selectionType)\n\(calendar.identifier) -> \(stringValue)\n\(Calendar.Identifier.gregorian) -> \(gregStringValue)
"""
  }
}

extension ViewController: CalendarViewItemProviderDelegate {

  func calendarView(didRequestBuildComponentsForRegistration calendarView: CalendarView) -> [CalendarItemPresentable.Type] {
    /*you can provide array of items*/
    return [MyDateItem.self]
  }

  func calendarView(_ calendarView: CalendarView, didRequestDateItemFor date: Date, calendar: Calendar, locale: Locale) -> CalendarDateItemPresentable {
    /*create any item from provided array types in func above*/
    let item = MyDateItem(date: date, calendar: calendar, locale: locale)
    return item
  }

  func calendarView(_ calendarView: CalendarView,
                    didRequestWeekDayItemFor style: CalendarWeekSymbolType,
                    forWeekNameItem item: CalendarWeekDayViewPosition,
                    poposedName name: String,
                    calendar: Calendar,
                    locale: Locale) -> CalendarWeekDayItemPresentable {
    /*create any item from provided array types in func above*/
    /*check poposedName and style and modify if u want*/
    let item = MyDateItem(weekDayName: name, calendar: calendar, locale: locale)
    return item
  }

  func calendarView(_ calendarView: CalendarView, didCompleteConfigure cell: CalendarItemConfigurable, for buildItem: CalendarItemPresentable, configuredFor calendar: Calendar, and locale: Locale, forDate date: Date?) {
    /*modify cell additionally as u wish here*/
  }
}
