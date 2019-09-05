//
//  CalendarItemSelectable.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/3/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

/**
  Represent constraints for view that will be used for displaying date in calendar
  see [CalendarItemConfigurable](x-source-tag://4003)
 
 - Tag: 4004
 - Version: 0.1
 */
public protocol CalendarItemSelectable: CalendarItemConfigurable {

  /**
   Called to indicate if this view should be marked as today

   - Parameter item: The item tha holds all required information needed for updating view, see [CalendarDateItemPresentable](x-source-tag://4002)
  */
  func markIsTodayCell(_ item: CalendarDateItemPresentable)

  /**
   Called when item is about to select or deselect

   - Parameter item: The item tha holds all required information needed for updating view, see [CalendarDateItemPresentable](x-source-tag://4002)
   - Parameter select: Indicate if item is selected or not
   */
  func selectItem(_ select: Bool, item: CalendarDateItemPresentable)

  /**
   Called when item will be marked as inactive or no

   - Parameter item: The item tha holds all required information needed for updating view, see [CalendarDateItemPresentable](x-source-tag://4002)
   - Parameter select: Indicate if item is inactive or not

   Note: Default implementation apply available parameters from [CalendarDateItemPresentable](x-source-tag://4002)
   */
  func markCellAsInactive(_ isInactive: Bool, item: CalendarDateItemPresentable)
}

public extension CalendarItemSelectable {

  func markCellAsInactive(_ isInactive: Bool, item: CalendarDateItemPresentable) {
    if isInactive {
      titleLabelItem.textColor = item.inActiveTitleColor
      subtitleLabelItem.textColor = item.inActiveSubTitleColor
    } else {
      titleLabelItem.textColor = item.titleColor
      subtitleLabelItem.textColor = item.subtitleColor
    }
  }
}
