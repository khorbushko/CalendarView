//
//  CalendarDateItemPresentable.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/3/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

/**
 Represent base constraints for data item that will be used for DATEs

 Inherits from [CalendarItemPresentable](x-source-tag://4000)

 - Tag: 4002
 - Version: 0.1
 */
public protocol CalendarDateItemPresentable: CalendarItemPresentable {

  // MARK: - CalendarDateItemPresentable

  /// Default initializator for CalendarDateItemPresentable
  ///  - Parameter timeline: Underline object that can provide
  ///   detailed info about current date source, selected calendar and locale
  ///  - Parameter date: Date that is about to select
  init(date: Date, timeline: Timeline)

  // MARK: - Subtitle

  /// subtitle container, dafult - nil
  var subtitle: String? { get }

  /// subtitle color, default - .lightGray
  var subtitleColor: UIColor? { get }

  /// subtitle font, default - UIFont.systemFont(ofSize: 12)
  var subtitleFont: UIFont? { get }

  /// inactive title color, default - .lightGray
  var inActiveTitleColor: UIColor { get }

  /// inactive subtitle color, default - .lightGray
  var inActiveSubTitleColor: UIColor? { get }
}

public extension CalendarDateItemPresentable {

  var subtitle: String? {
    return nil
  }

  var subtitleColor: UIColor? {
    return .lightGray
  }

  var subtitleFont: UIFont? {
    return UIFont.systemFont(ofSize: 12)
  }

  var inActiveTitleColor: UIColor {
    return .lightGray
  }

  var inActiveSubTitleColor: UIColor? {
    return .lightGray
  }
}
