//
//  CalendarView.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/2/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

/**
 Combined typeallias that represent max customization level for `CalendarView`
 */
public typealias CalendarCustomInteractionDelegate = CalendarViewItemProviderDelegate & CalendarViewItemEventDelegate & CalendarViewItemLayoutDelegate

/**
 Implement this protol for `CalendarView` if you want to provide custom view's instead of default one's
 */
public protocol CalendarViewItemProviderDelegate: class {

  /**
   Ask buildCompoments class's types for registration in calendar
   You can return a lot of objects in array, in this case you responsible for correct configuring of this objects.

   Request will be called on `init` or on `forceReload`

   Use this funcs for configuration registered objects

        calendarView(_:, didRequestWeekDayItemFor:, forWeekNameItem:, poposedName: calendar:, locale:)
        calendarView(_:, didRequestDateItemFor:, calendar:, locale:)

   Sample:

       func calendarView(didRequestBuildComponentsForRegistration calendarView: CalendarView) -> [CalendarItemPresentable.Type] {
        /*you can provide array of items*/
        return [MyDateItem.self]
       }

   - Parameter calendarView: Object that holds all logic related to calendar
   - Returns: Type of items [CalendarItemPresentable](x-source-tag://4000)
   - Version: 0.1
   */
  func calendarView(didRequestBuildComponentsForRegistration calendarView: CalendarView) -> [CalendarItemPresentable.Type]

  /**
   Ask instance of registered components for date object

   Sample:

   func calendarView(_ calendarView: CalendarView, didRequestDateItemFor date: Date, calendar: Calendar, locale: Locale) -> CalendarDateItemPresentable {
   /*create any item from provided array types in func above*/
   let item = MyDateItem(date: date, calendar: calendar, locale: locale)
   return item
   }

   - Parameter calendarView: Object that holds all logic related to calendar
   - Parameter date: Date for which requested build item
   - Parameter timeline: Object that contains info about generator of date, calendar and locale
                          see [Timeline](x-source-tag://1003)

   *Note:* Sometimes you can mix `locale` and `calendar.locale` (**not recommended**)
   - Returns: object that represent data for specific date, see [CalendarDateItemPresentable](x-source-tag://4002)
   - Version: 0.21
   */
  func calendarView(_ calendarView: CalendarView,
                    didRequestDateItemFor date: Date,
                    timeline: Timeline) -> CalendarDateItemPresentable

  /**
   Ask instance of registered components for WeekDayItem.

   Sample:

           func calendarView(_ calendarView: CalendarView, didRequestWeekDayItemFor style: CalendarWeekSymbolType, forWeekNameItem item: CalendarWeekDayViewPosition, poposedName name: String, calendar: Calendar, locale: Locale) -> CalendarWeekDayItemPresentable {
             /*create any item from provided array types in func above*/
             /*check poposedName and style and modify if u want*/
             let item = MyDateItem(weekDayName: name, calendar: calendar, locale: locale)
             return item
           }

   - Parameter calendarView: Object that holds all logic related to calendar
   - Parameter style: Symbol style - check [CalendarWeekSymbolType](x-source-tag://2004) for more
   - Parameter item: WeekDay representation - check [CalendarWeekDayViewPosition](x-source-tag://2000) for more
   - Parameter name: Proposed name format according to settings
   - Parameter timeline: Object that contains info about generator of date, calendar and locale
                        see [Timeline](x-source-tag://1003)

   - SeeAlso: [CalendarWeekSymbolType](x-source-tag://2004), [CalendarWeekDayViewPosition](x-source-tag://2000)

   *Note:* Sometimes you can mix `locale` and `calendar.locale` (**not recommended**)
   - Version: 0.21
   */
  func calendarView(_ calendarView: CalendarView,
                    didRequestWeekDayItemFor style: CalendarWeekSymbolType,
                    forWeekNameItem item: CalendarWeekDayViewPosition,
                    poposedName name: String,
                    timeline: Timeline) -> CalendarWeekDayItemPresentable

  /**
   Called on each instance of view that was configured with provided build items at very end
   Use this callback for additional customization if needed (**not recommended**)

   Sample:

       func calendarView(_ calendarView: CalendarView, didCompleteConfigure cell: CalendarItemConfigurable, for buildItem: CalendarItemPresentable, configuredFor calendar: Calendar, and locale: Locale, forDate date: Date?) {
          /*modify cell additionally as u wish here*/
       }

   - Parameter calendarView: Object that holds all logic related to calendar
   - Parameter cell: `UICollectioViewCell` instance that was provided in [CalendarDateItemPresentable](x-source-tag://4002) and conform [CalendarItemConfigurable](x-source-tag://4003)
   - Parameter buildItem: [CalendarItemPresentable](x-source-tag://4000) instance used for configuration this cell
   - Parameter date: Date for which requested build item
   - Parameter timeline: Object that contains info about generator of date, calendar and locale
                        see [Timeline](x-source-tag://1003)
   - Version: 0.21
   */
  func calendarView(_ calendarView: CalendarView,
                    didCompleteConfigure cell: CalendarItemConfigurable,
                    for buildItem: CalendarItemPresentable,
                    configuredFor timeline: Timeline,
                    forDate date: Date?)
}

/**
  Implement this protocol if you want to have additional points for controlling items
 */
public protocol CalendarViewItemLayoutDelegate: class {

  /**
    Tells the delegate that the specified cell is about to be displayed in the calendar view.

   - Parameter calendarView: Object that holds all logic related to calendar
   - Parameter cell: `UICollectioViewCell` instance that was provided in [CalendarDateItemPresentable](x-source-tag://4002) and conform [CalendarItemConfigurable](x-source-tag://4003)
   - Parameter buildItem: [CalendarItemPresentable](x-source-tag://4000) instance used for configuration this cell
   - Parameter date: Date for which requested build item
   - Parameter timeline: Object that contains info about generator of date, calendar and locale
                          see [Timeline](x-source-tag://1003)
   - Version: 0.21
   */
  func calendarView(_ calendarView: CalendarView,
                    willDisplay cell: CalendarItemConfigurable,
                    for buildItem: CalendarItemPresentable,
                    configuredFor timeline: Timeline,
                    forDate date: Date?)
}

/**
 Implement this protocol if you want to receive/control selection events occured in calendar view
 */
public protocol CalendarViewDateSelectionEventDelegate: class {

  /**
   Ask the delegate if selection of date is enabled

   - Parameter calendarView: Object that holds all logic related to calendar
   - Parameter timeline: Object that contains info about generator of date, calendar and locale
                          see [Timeline](x-source-tag://1003)
   - Parameter date: Date that is about to select

   - Returns: Enabled or disabled selection
   - Version: 0.21
   */
  func calendarView(_ calendarView: CalendarView,
                    configuredFor timeline: Timeline,
                    shouldSelect date: Date) -> Bool

  /**
   Tell to delegate about selection event

   - Parameter calendarView: Object that holds all logic related to calendar
   - Parameter timeline: Object that contains info about generator of date, calendar and locale
                        see [Timeline](x-source-tag://1003)
   - Parameter date: Target date
   - Parameter selectionType: Indicate action - select or deselect, see [CalendarDateSelectionOperation](x-source-tag://2001) for more

   - Returns: Enabled or disabled selection
   - Version: 0.21
   */
  func calendarView(_ calendarView: CalendarView,
                    configuredFor timeline: Timeline,
                    didDetectDateSelectionChangeFor date: Date,
                    selectionType: CalendarDateSelectionOperation)
}

/**
 Implement this protocol if you want to receive additional event's notifications,
 such as date change (depends on components change)
 */
public protocol CalendarViewItemEventDelegate: CalendarViewDateSelectionEventDelegate {

  /**
   Tell to delegate about additional event - month change

   - Parameter calendarView: Object that holds all logic related to calendar
   - Parameter timeline: Object that contains info about generator of date, calendar and locale
                        see [Timeline](x-source-tag://1003)
   - Parameter month: This object represent changed item - month, see [CalendarMonth](x-source-tag://3001) for more

   Note: May be called even repeatedly
   - Version: 0.21
   */
  func calendarView(_ calendarView: CalendarView,
                    configuredFor timeline: Timeline,
                    didChangeMonth month: CalendarMonth)

  /**
   Tell to delegate about additional event - year change

   - Parameter calendarView: Object that holds all logic related to calendar
   - Parameter timeline: Object that contains info about generator of date, calendar and locale
                          see [Timeline](x-source-tag://1003)
   - Parameter year: This object represent changed item - year, see [CalendarYear](x-source-tag://3000) for more

   Note: May be called even repeatedly
   - Version: 0.21
   */
  func calendarView(_ calendarView: CalendarView,
                    configuredFor timeline: Timeline,
                    didChangeYear year: CalendarYear)

  /**
   Tell to delegate about additional event - selection date array change

   - Parameter calendarView: Object that holds all logic related to calendar
   - Parameter timeline: Object that contains info about generator of date, calendar and locale
                          see [Timeline](x-source-tag://1003)
   - Parameter dates: Array of selected dates after any change
   - Version: 0.21
   */
  func calendarView(_ calendarView: CalendarView,
                    configuredFor timeline: Timeline,
                    didChangeSelectedDates dates: [Date])

  /**
   Tell to delegate about additional event - user interaction with WeekDay section

   - Parameter calendarView: Object that holds all logic related to calendar
   - Parameter timeline: Object that contains info about generator of date, calendar and locale
                        see [Timeline](x-source-tag://1003)
   - Parameter weekDay: Tapped weekday, check [CalendarWeekDayViewPosition](x-source-tag://2000) for more

   Note: if you need only this event, consider to use

        var currentlySelectedDates: [Date] { get }

   instead
   - Version: 0.21
   */
  func calendarView(_ calendarView: CalendarView,
                    configuredFor timeline: Timeline,
                    didDetectWeekDayNameSelection weekDay: CalendarWeekDayViewPosition)
}

/**
 Calendar control that represent any calendar type supported by native iOS SDK,
 provide high performance and high customizablility

 - Author: Kyryl Horbushko, [contact](mailto:kirill.ge@gmail.com)
 - Version: 0.1
 - Tag: 1000
 */
final public class CalendarView: UIView, Nibable {

  /// dataSource delegate object
  /// - Version: 0.1
  public weak var itemProviderDelegate: CalendarViewItemProviderDelegate? {
    didSet {
      registerCells()
    }
  }

  /// layout delegate object
  /// - Version: 0.1
  public weak var layoutDelegate: CalendarViewItemLayoutDelegate?

  /// selection control delegate object
  /// - Version: 0.1
  public weak var dateSelectionDelegate: CalendarViewDateSelectionEventDelegate?

  /// selection control and additional event delegate object
  /// - Version: 0.1
  public weak var eventDelegate: CalendarViewItemEventDelegate? {
    didSet {
      dateSelectionDelegate = eventDelegate
    }
  }

  fileprivate enum CalendarViewDefines {

    enum Layout {

      static let spacing: CGFloat = 3
    }
  }

  @IBOutlet private var backgroundContainerView: UIView!
  @IBOutlet private weak var containerView: UIView!
  @IBOutlet private weak var collectionView: UICollectionView!

  private var timeline: Timeline!
  private var buildItems: [CalendarItemPresentable] = []

  private var offsetForBuildItemFetch: Int {
    timeline.startIndex - timeline.dayNamesCount
  }

  // MARK: - Appearence

  private var weekDayNameStyle: CalendarWeekSymbolType {
    get {
      timeline.weekDayNameStyle
    }

    set {
      timeline.weekDayNameStyle = newValue
    }
  }

  private var appearenceOptions: CalendarAppearenceOption = .default
  private var calendarAnimationStyle: CalendarViewAnimationType = .scaleItem

  // MARK: - Selection

  private var selectionStyle: CalendarSelectionType = .single
  private var selectedDates: [Date] = [] {
    didSet {
      eventDelegate?.calendarView(self, configuredFor: timeline, didChangeSelectedDates: selectedDates)
    }
  }

  // MARK: - Layout

  private var stretchMode: CalendarViewContentStretchMode = .fillWidth

  private var flowLayout: UICollectionViewFlowLayout? {
    return collectionView.collectionViewLayout as? UICollectionViewFlowLayout
  }

  private var expectedContentSize: CGSize {
    let width = frame.width

    switch stretchMode {
      case .fillWidth:
        return frame.size
      case .center:
        let expectedHeight: CGFloat = frame.height
        let sideSize = min(expectedHeight, width)
        return CGSize(width: sideSize, height: sideSize)
    }
  }

  private var sectionInset: CGFloat {
    switch stretchMode {
      case .fillWidth:
        return 0
      case .center:
        return max(0, frame.width - expectedContentSize.width) / 2
    }
  }

  // MARK: - ThisMonth

  /// display date for which shown calendar month
  /// - Version: 0.1
  public private (set) var activeDate: Date {
    set {
      timeline.prepareMonthTimelineFor(newValue, options: appearenceOptions)
      callbacksForDate(newValue)
    }

    get {
      timeline.activeDate
    }
  }

  // MARK: - Public Props

  /// Represent array of all selected dates, can be obtained at any time
  /// - Version: 0.1
  public var currentlySelectedDates: [Date] {
    return selectedDates
  }

  // MARK: - Date bounds
    
  public private (set) var maxDate: Date?
  public private (set) var minDate: Date?
  
  // MARK: Lyfecycle

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    prepareView()
    configureCalendarView()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    prepareView()
    configureCalendarView()
  }

  override public func layoutSubviews() {
    super.layoutSubviews()

    flowLayout?.invalidateLayout()
  }

  // MARK: - Public

  /// Allow to change stretchMode for `CalendarView`
  ///
  /// - Version: 0.1
  public func changeStretchMode(_ mode: CalendarViewContentStretchMode) {
    stretchMode = mode
    forceReload()
  }

  /// Allow to reload all components
  ///
  /// Selection of date will be stored
  /// - Version: 0.1
  public func forceReload() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
      showTimelineForSelectedDate()
    CATransaction.commit()
  }

  /// Ask to clear all selection in `CalendarView`.
  /// - Version: 0.1
  public func clearSelection() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
      selectedDates.removeAll()
      showTimelineForSelectedDate()
    CATransaction.commit()
  }

  // MARK: - Appearence

  /// Allow to modify behaviour of `CalendarView`, see [CalendarAppearenceOption](x-source-tag://2002) for more
  /// - Parameter optionSet: Set of options that will be applied to `CalendarView`
  /// - Version: 0.1
  public func updateAppearence(byApplying optionSet: CalendarAppearenceOption) {
    appearenceOptions = optionSet
  }

  /// Allow to modify selected dates
  /// - Parameter preSelectedDates: Set of preselected dates
  /// - Version: 0.1
  public func addPreSelectedDates(_ preSelectedDates: [Date]) {
    selectedDates.append(contentsOf: preSelectedDates)
  }

  /// Change animation that used while changing date with any of available methods
  /// - Parameter animation: Predefined set of animations, check [CalendarViewAnimationType](x-source-tag://2005) for more
  /// - Version: 0.1
  public func changeAnimationType(_ animation: CalendarViewAnimationType) {
    calendarAnimationStyle = animation
  }

  /// Change weekDay display mode
  /// - Parameter style: Predefined set of weekday mode, check [CalendarWeekSymbolType](x-source-tag://2004) for more
  /// - Version: 0.1
  public func changeWeekDayStyle(_ style: CalendarWeekSymbolType) {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
      weekDayNameStyle = style
      showTimelineForSelectedDate()
    CATransaction.commit()
  }

  // MARK: - Date change

  /// Change selected year for calendar
  ///
  /// Selection for dates not changed during this change, will trigger eventDelegate callback
  /// - Parameter newYear: Object that represent Year, check [CalendarYear](x-source-tag://3000)
  /// - Version: 0.1
  public func changeCurrentDate(year newYear: CalendarYear) {
    let calendar = timeline.underlineCalendar

    var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: activeDate)
    component.year = newYear.value
    if let updatedDate = calendar.date(from: component) {
      switchToDate(updatedDate)
    }
  }

  /// Change selected month for calendar
  ///
  /// Selection for dates not changed during this change, will trigger eventDelegate callback
  /// - Parameter newMonth: Object that represent Month, check [CalendarMonth](x-source-tag://3001)
  /// - Version: 0.1
  public func changeCurrentDate(month newMonth: CalendarMonth) {
    let calendar = timeline.underlineCalendar

    var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .calendar], from: activeDate)
    component.month = newMonth.index
    if let updatedDate = calendar.date(from: component) {
      switchToDate(updatedDate)
    }
  }

  /// Change selected month and year for calendar
  ///
  /// Selection for dates not changed during this change, will trigger eventDelegate callback
  /// - Parameter newMonth: Object that represent Month, check [CalendarMonth](x-source-tag://3001)
  /// - Parameter newYear: Object that represent Year, check [CalendarYear](x-source-tag://3000)
  /// - Version: 0.1
  public func changeCurrentDate(month newMonth: CalendarMonth, year newYear: CalendarYear) {
    let calendar = timeline.underlineCalendar

    var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .calendar], from: activeDate)
    component.month = newMonth.index
    component.year = newYear.value
    if let updatedDate = calendar.date(from: component) {
      switchToDate(updatedDate)
    }
  }
  
  // MARK: - Max and min dates
  
  /// Highlight future dates as inactive
  ///
  /// Dates will be highlighted during the next collection reload.
  /// - Parameter maxDate: The last date that should be marked as active.

  func setMaxDate(maxDate: Date) {
    self.maxDate = maxDate
  }
  
  /// Highlight older dates as inactive
  ///
  /// Dates will be highlighted during the next collection reload.
  /// - Parameter minDate: The first date that should be marked as active.
  
  func setMinDate(minDate: Date) {
    self.minDate = minDate
  }

  // MARK: - Navigation

  /// Perform calendar inner navigation
  ///
  /// Selection for dates not changed during this change, will trigger eventDelegate callback
  /// - Parameter switchItem: Supported navigation in calendar, check [CalendarDisplayDataType](x-source-tag://2004) for more
  /// - Version: 0.1
  public func switchTo(_ switchItem: CalendarDisplayDataType) {
    switch switchItem {
      case .date(let newDate):
        switchToDate(newDate)
      case .today:
        switchToTodayView()
      case .selected:
        switchToSelectedDateIfAny()
      case .nextMonth:
        switchToNextMonth()
      case .prevMonth:
        switchToPrevMonth()
    }
  }

  /// Perform calendar switch to selected identifier
  ///
  /// Selection for dates not changed during this change
  /// - Parameter identifier: An enumeration for the available calendars.
  /// - Parameter locale: Information about linguistic, cultural, and technological conventions for use in formatting data for presentation.
  /// - Version: 0.1
  public func switchToCalendarType(_ identifier: Calendar.Identifier, locale: Locale) {
    let current = timeline.underlineCalendar.identifier
    if current == identifier {
      return
    }

    setupCalendar(identifier, locale: locale)
    switchToDate(activeDate)
  }

  public func switchToCustomCalendarType(_ identifier: CustomTimeLineIdentifier, locale: Locale) {
    setupCalendar(identifier, locale: locale)
    switchToDate(activeDate)
  }

  // MARK: - Private Navigation

  private func callbacksForDate(_ date: Date) {
    let locale = timeline.underlineLocale
    let calendar = timeline.underlineCalendar

    if let month = CalendarMonth(date: date, calendar: calendar.identifier, locale: locale),
      let year = CalendarYear(date: date, calendar: calendar.identifier, locale: locale) {
      eventDelegate?.calendarView(self, configuredFor: timeline, didChangeYear: year)
      eventDelegate?.calendarView(self, configuredFor: timeline, didChangeMonth: month)
    }
  }

  private func switchToDate(_ date: Date) {
    showTimeLineForDate(date)
  }

  private func switchToTodayView() {
    let today = Date()
    let calendar = timeline.underlineCalendar

    if !timeline.displayDates.contains(where: { calendar.isDate($0, inSameDayAs: today) }) {
      showTimeLineForDate(today)
    }
  }

  private func switchToSelectedDateIfAny() {
    if let date = selectedDates.first {
      let calendar = timeline.underlineCalendar
      if !timeline.displayDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
        showTimeLineForDate(date)
      }
    }
  }

  private func switchToNextMonth() {
    let calendar = timeline.underlineCalendar

    if let next = calendar.nextMonth(from: activeDate) {
      showTimeLineForDate(next)

      switch calendarAnimationStyle {
        case .none:
          break
        case .slide:
          let rightAnimation = CalendarAnimator.swipeTransitionToLeftSide(true)
          containerView.layer.add(rightAnimation, forKey: nil)
        case .scaleItem:
          animateVisibleCells(true)
      }
    }
  }

  private func switchToPrevMonth() {
    let calendar = timeline.underlineCalendar

    if let prev = calendar.prevMonth(from: activeDate) {
      showTimeLineForDate(prev)

      switch calendarAnimationStyle {
        case .none:
          break
        case .slide:
          let leftAnimation = CalendarAnimator.swipeTransitionToLeftSide(false)
          containerView.layer.add(leftAnimation, forKey: nil)
        case .scaleItem:
          animateVisibleCells(false)
      }
    }
  }

  // MARK: - Private

  private func animateVisibleCells(_ toLeft: Bool) {
    let skippedIdxValue = weekDayNameStyle == .none ? 0 : Defines.Calendar.deysInWeek
    collectionView.animateVisibleCells(toLeft, skippedCount: skippedIdxValue)
  }

  private func configureCalendarView() {
    prepareCollectionView()
    registerCells()

    setupCalendar(.gregorian, locale: Locale(identifier: "en"))
  }

  private func prepareCollectionView() {
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
  }

  private func registerCells() {
    if let configDelegate = itemProviderDelegate {
      configDelegate.calendarView(didRequestBuildComponentsForRegistration: self).forEach { (itemType) in
        let nib = itemType.calendarItemNib
        let identifier = itemType.calendarItemIdentifier
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
      }
    } else {
      let nib = CalendarDateItem.calendarItemNib
      let identifier = CalendarDateItem.calendarItemIdentifier
      collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
  }

  private func setupCalendar(_ identifier: Calendar.Identifier, locale: Locale) {
    timeline = Timeline(identifier, locale: locale)
    showTimelineForSelectedDate()
  }

  private func setupCalendar(_ identifier: CustomTimeLineIdentifier, locale: Locale) {
    timeline = Timeline(identifier, locale: locale)
    showTimelineForSelectedDate()
  }

  // MARK: - Config

  private func showTimeLineForDate(_ date: Date) {
    buildItems.removeAll()
    timeline.prepareMonthTimelineFor(date, options: appearenceOptions)

    collectionView.reloadData()
  }

  private func showTimelineForSelectedDate() {
    buildItems.removeAll()
    timeline.prepareMonthTimelineForCurrentlySelectedDate()

    collectionView.reloadData()
  }
}

extension CalendarView: UICollectionViewDataSource {

  // MARK: - UICollectionViewDataSource

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    timeline.numberOfItemsInSection()
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    var cellToReturn: UICollectionViewCell?
    let dateFormatter = timeline.adoptedDateFormatter()
    let calendar = timeline.underlineCalendar

    if weekDayNameStyle != .none,
      let dayName = CalendarWeekDayViewPosition(rawValue: indexPath.item) {
      var symbols: [String] = []

      switch weekDayNameStyle {
        case .full:
          symbols = dateFormatter.weekdaySymbols
        case .short:
          symbols = dateFormatter.shortWeekdaySymbols
        case .veryShort:
          symbols = dateFormatter.veryShortWeekdaySymbols
        case .none:
          break
      }

      assert(symbols.count == Defines.Calendar.deysInWeek, "invalid symbols obtain for week name")
      if symbols.count < Defines.Calendar.deysInWeek {
        symbols = [String].init(repeating: "", count: Defines.Calendar.deysInWeek)
      }

      var buildItem: CalendarItemPresentable
      if buildItems.count > indexPath.row {
        buildItem = buildItems[indexPath.row]
      } else {
        let name = symbols[dayName.rawValue]

        if let configDelegate = itemProviderDelegate {
          buildItem = configDelegate.calendarView(self,
                                                  didRequestWeekDayItemFor: weekDayNameStyle,
                                                  forWeekNameItem: dayName,
                                                  poposedName: name,
                                                  timeline: timeline)
        } else {
          buildItem = CalendarDateItem(weekDayName: name, timeline: timeline)
        }

        buildItems.append(buildItem)
      }

      let cellResuseIdentifier = type(of: buildItem).calendarItemIdentifier
      cellToReturn = collectionView.dequeueReusableCell(withReuseIdentifier: cellResuseIdentifier, for: indexPath)

      let configurableCell = cellToReturn as? CalendarItemConfigurable
      configurableCell?.setupWith(buildItem)

      if let confCell = cellToReturn as? CalendarItemConfigurable {
        itemProviderDelegate?.calendarView(self, didCompleteConfigure: confCell, for: buildItem, configuredFor: timeline, forDate: nil)
      }

    } else {
      let currentItemIdx = indexPath.item - timeline.startIndex

      if currentItemIdx >= 0,
        timeline.displayDates.count > currentItemIdx {
        let dateToShow = timeline.displayDates[currentItemIdx]

        var generatedBuildItem: CalendarItemPresentable
        if buildItems.count > indexPath.row {
          generatedBuildItem = buildItems[indexPath.row]
        } else {
          if let configDelegate = itemProviderDelegate {
            generatedBuildItem = configDelegate.calendarView(self, didRequestDateItemFor: dateToShow, timeline: timeline)
          } else {
            generatedBuildItem = CalendarDateItem(date: dateToShow, timeline: timeline)
          }

          buildItems.append(generatedBuildItem)
        }

        guard let buildItem = generatedBuildItem as? CalendarDateItemPresentable else {
          fatalError("invalid builditem generation logic")
        }

        let cellResuseIdentifier = type(of: buildItem).calendarItemIdentifier
        cellToReturn = collectionView.dequeueReusableCell(withReuseIdentifier: cellResuseIdentifier, for: indexPath)

        let configurableCell = cellToReturn as? CalendarItemSelectable
        configurableCell?.setupWith(buildItem)
        
        let isTodayItem = timeline.isDateInToday(dateToShow)

        if isTodayItem {
          configurableCell?.markIsTodayCell(buildItem)
        }
        
        let isSelected = selectedDates.contains(where: { calendar.isDate($0, inSameDayAs: dateToShow) })
        configurableCell?.selectItem(isSelected, item: buildItem)

        if !isTodayItem,
          !isSelected {
          
          if appearenceOptions.showEnclosingMonths,
            appearenceOptions.hightlightCurrentMonth {
            let isDateFromNotSelectedMonth = !timeline.displayDatesForCurrentMonth.contains(where: { calendar.isDate($0, inSameDayAs: dateToShow) })
            configurableCell?.markCellAsInactive(isDateFromNotSelectedMonth, item: buildItem)
          }
          
          if let maxDate = maxDate,
          dateToShow > maxDate {
            configurableCell?.markCellAsInactive(true, item: buildItem)
          }
          
          if let minDate = minDate,
           dateToShow < minDate {
            configurableCell?.markCellAsInactive(true, item: buildItem)
          }
        }

        if let confCell = configurableCell {
          itemProviderDelegate?.calendarView(self, didCompleteConfigure: confCell, for: buildItem, configuredFor: timeline, forDate: dateToShow)
        }
      } else {
        if !appearenceOptions.showEnclosingMonths {
          let startBounds = timeline.startIndex
          if indexPath.item < startBounds {
            let identifier = String(describing: CalendarViewCollectionViewCell.self)
            cellToReturn = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
          }
        } else {
          fatalError("invalid dataSource generation - can't obtain cell")
        }
      }
    }

    if let cellToReturn = cellToReturn {
      return cellToReturn
    } else {
      fatalError("invalid dataSource generation - can't obtain cell")
    }
  }
}

extension CalendarView: UICollectionViewDelegate {

  // MARK: - UICollectionViewDelegate

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    let calendar = timeline.underlineCalendar

    if let weekDay = CalendarWeekDayViewPosition(rawValue: indexPath.item) {
      eventDelegate?.calendarView(self, configuredFor: timeline, didDetectWeekDayNameSelection: weekDay)
    } else {
      let currentItemIdxForDisplayDate = indexPath.item - timeline.startIndex
      if indexPath.item >= timeline.startIndex,
        timeline.displayDates.count > currentItemIdxForDisplayDate {
        let interestedDate = timeline.displayDates[currentItemIdxForDisplayDate]

        if appearenceOptions.enableDebugMessages {
          debugPrint(timeline.debugDateDescription(interestedDate))
        }

        let isDateFromNotSelectedMonth = !timeline.displayDatesForCurrentMonth.contains(where: { calendar.isDate($0, inSameDayAs: interestedDate) })
        if isDateFromNotSelectedMonth,
          !appearenceOptions.enableEnclosingMonthSelection {
          if appearenceOptions.enableDebugMessages {
            debugPrint("enableEnclosingMonthSelection disable")
          }
          return
        }

        if appearenceOptions.showEnclosingMonths {
          assert(buildItems.count == timeline.displayDates.count + timeline.dayNamesCount, "invalid data generation logic")
        }

        guard let target = collectionView.cellForItem(at: indexPath) as? CalendarItemSelectable,
          let buildItem = buildItems[indexPath.item - offsetForBuildItemFetch] as? CalendarDateItemPresentable else {
            assertionFailure("invalid cast for selection")
            return
        }
        
        var isWithinBounds = true
        if let maxDate = maxDate,
          interestedDate > maxDate {
          isWithinBounds = false
        }
        if let minDate = minDate,
          interestedDate < minDate {
          isWithinBounds = false
        }

        switch selectionStyle {
          case .single:
            assert(selectedDates.count == 1 || selectedDates.isEmpty,
                   "invalid logic for single selection - check store index logic")
              if let index = selectedDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: interestedDate) }),
                let indexInStorage = timeline.displayDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: interestedDate) }) {

              if appearenceOptions.enablseSingleDeselectionForSingleMode {
                selectedDates.remove(at: index)
                assert(selectedDates.isEmpty,
                       "invalid logic for single selection - check store index logic")
                let prevIndex = indexInStorage + timeline.startIndex

                let prevIndexPathSelected = IndexPath(item: prevIndex, section: 0)
                let prevSelected = collectionView.cellForItem(at: prevIndexPathSelected) as? CalendarItemSelectable
                if let prevBuildItem = buildItems[prevIndexPathSelected.item - offsetForBuildItemFetch] as? CalendarDateItemPresentable {
                  prevSelected?.selectItem(false, item: prevBuildItem)
                }

                if appearenceOptions.showEnclosingMonths,
                  appearenceOptions.hightlightCurrentMonth {
                  let isDateFromNotSelectedMonth = !timeline.displayDatesForCurrentMonth.contains(where: { calendar.isDate($0, inSameDayAs: interestedDate) })

                  target.markCellAsInactive(!isWithinBounds || isDateFromNotSelectedMonth, item: buildItem)
                }

                dateSelectionDelegate?.calendarView(self, configuredFor: timeline, didDetectDateSelectionChangeFor: interestedDate, selectionType: .deselect)
                return
              } else {
                let date = selectedDates[index]
                if calendar.isDate(date, inSameDayAs: interestedDate) {
                  if appearenceOptions.enableDebugMessages {
                    debugPrint("same item selection")
                  }
                  return
                }
              }
            } else {

              if !selectedDates.isEmpty {
                assert(selectedDates.count == 1,
                       "invalid logic for single selection - check store index logic")
                if let date = selectedDates.first {

                  if calendar.isDate(date, inSameDayAs: interestedDate) {
                    return
                  }

                  if let indexInStorage = timeline.displayDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: date) }) {
                    let prevIndex = indexInStorage + timeline.startIndex

                    let prevIndexPathSelected = IndexPath(item: prevIndex, section: 0)
                    let prevSelected = collectionView.cellForItem(at: prevIndexPathSelected) as? CalendarItemSelectable
                    if let prevBuildItem = buildItems[prevIndexPathSelected.item - offsetForBuildItemFetch] as? CalendarDateItemPresentable {
                      prevSelected?.selectItem(false, item: prevBuildItem)
                    }

                    if appearenceOptions.showEnclosingMonths,
                      appearenceOptions.hightlightCurrentMonth {
                      let isDateFromNotSelectedMonth = !timeline.displayDatesForCurrentMonth.contains(where: { calendar.isDate($0, inSameDayAs: interestedDate) })
                      target.markCellAsInactive(!isWithinBounds || isDateFromNotSelectedMonth, item: buildItem)
                    }
                  }

                  dateSelectionDelegate?.calendarView(self, configuredFor: timeline, didDetectDateSelectionChangeFor: date, selectionType: .deselect)
                  selectedDates.removeAll()
                } else {
                  assertionFailure("invalid storage access for selected dates")
                }
              }
            }

            var canSelectDate = true
            if let eventDelegate = dateSelectionDelegate {
              canSelectDate = eventDelegate.calendarView(self, configuredFor: timeline, shouldSelect: interestedDate)
            }

            if canSelectDate {
              target.selectItem(true, item: buildItem)
              selectedDates.append(interestedDate)
              dateSelectionDelegate?.calendarView(self, configuredFor: timeline, didDetectDateSelectionChangeFor: interestedDate, selectionType: .select)
            }
        }
      }
    }
  }

  public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    cell.setNeedsLayout()
    cell.layoutIfNeeded()

    if let delegate = layoutDelegate {
      guard let target = cell as? CalendarItemConfigurable else {
          assertionFailure("invalid cast for selection")
          return
      }

      let buildItem = buildItems[indexPath.item - offsetForBuildItemFetch]

      var date: Date?
      if let _ = CalendarWeekDayViewPosition(rawValue: indexPath.item) {
        date = nil
      } else {
        let currentItemIdxForDisplayDate = indexPath.item - timeline.startIndex
        if indexPath.item >= timeline.startIndex,
          timeline.displayDates.count > currentItemIdxForDisplayDate {
          date = timeline.displayDates[currentItemIdxForDisplayDate]
        }
      }

      delegate.calendarView(self, willDisplay: target, for: buildItem, configuredFor: timeline, forDate: date)
    }
  }
}

extension CalendarView: UICollectionViewDelegateFlowLayout {

  // MARK: - UICollectionViewDelegateFlowLayout

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return sizeForItem()
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    switch stretchMode {
      case .center:
        return CalendarViewDefines.Layout.spacing
      case .fillWidth:
        let expectedCountsInLineFloat = CGFloat(Defines.Calendar.deysInWeek)
        let occupation = expectedCountsInLineFloat * sizeForItem().width
        let spacing = (expectedContentSize.width - occupation) / expectedCountsInLineFloat
        return spacing
    }
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return CalendarViewDefines.Layout.spacing
  }

  // MARK: - Private

  private func sizeForItem() -> CGSize {
    let targetWidth = expectedContentSize.width
    let supportLinesCountForWeekDayName = 1
    let totalSpacing = CalendarViewDefines.Layout.spacing * CGFloat(Defines.Calendar.deysInWeek - 1 + supportLinesCountForWeekDayName)
    let sideSize = (targetWidth - totalSpacing) / CGFloat(Defines.Calendar.deysInWeek)

    switch stretchMode {
    case .center:
      return CGSize(width: sideSize, height: sideSize)
    case .fillWidth:
      var rowsCount = CGFloat(timeline.startIndex + timeline.displayDates.count) / CGFloat(Defines.Calendar.deysInWeek)
      if appearenceOptions.showEnclosingMonths {
        rowsCount = CGFloat(timeline.displayDates.count + timeline.dayNamesCount) / CGFloat(Defines.Calendar.deysInWeek)
      }

      let sideHeight = (expectedContentSize.height - totalSpacing) / CGFloat(rowsCount)
      let target = min(sideHeight, sideSize)
      return CGSize(width: target, height: target)
    }
  }
}
