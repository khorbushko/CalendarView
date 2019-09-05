//
//  CalendarItemConfigurable.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/3/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

/**
 Represent base constraints for view that will be used for displaying date in calendar

 - Tag: 4003
 - Version: 0.1
 */
public protocol CalendarItemConfigurable where Self: UICollectionViewCell {

  /// main title label, by default used for current day number
  var titleLabelItem: UILabel { get }

  /// main title label, by default used for secondary information
  var subtitleLabelItem: UILabel { get }

  /**
   Called when item will ready for setup

   - Parameter item: The item tha holds all required information needed for updating view, see [CalendarDateItemPresentable](x-source-tag://4002)

   Note: Default implementation apply available parameters from [CalendarItemPresentable](x-source-tag://4000)
   */
  func setupWith(_ item: CalendarItemPresentable)
}

public extension CalendarItemSelectable {

  func setupWith(_ item: CalendarItemPresentable) {
    setNeedsLayout()
    layoutIfNeeded()

    titleLabelItem.text = item.title
    titleLabelItem.textColor = item.titleColor
    titleLabelItem.font = item.titleFont

    if let item = item as? CalendarDateItemPresentable {
      subtitleLabelItem.text = item.subtitle
      if let color = item.subtitleColor {
        subtitleLabelItem.textColor = color
      }
      if let font = item.subtitleFont {
        subtitleLabelItem.font = font
      }
    }
  }
}
