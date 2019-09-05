//
//  CalendarItemPresentable.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/3/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

/**
 Base constraint for any data item used in `CalendarView`

 - Tag: 4000
 - Version: 0.1
 */
public protocol CalendarItemPresentable {

  // MARK: - CalendarItemPresentable

  // MARK: - Object

  /// reuse identifier that used in `UICollectionViewCell`
  /// A string that identifies the purpose of the view.
  static var calendarItemIdentifier: String { get }

  /// instance of nib for `UICollectionViewCell`
  /// An object that wraps, or contains, Interface Builder nib files.
  static var calendarItemNib: UINib { get }

  /// Type that used for custom `UICollectionViewCell`
  static var classType: CalendarItemSelectable.Type { get }

  /// Main title
  var title: String { get }

  /// Main title font, default - UIFont.systemFont(ofSize: 14)
  var titleFont: UIFont { get }

  /// Main title color, dafult - .black
  var titleColor: UIColor { get }
}

public extension CalendarItemPresentable {

  var titleColor: UIColor {
    return .black
  }

  var titleFont: UIFont {
    return UIFont.systemFont(ofSize: 14)
  }
}
