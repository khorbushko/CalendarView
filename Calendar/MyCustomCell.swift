//
//  MyCustomCell.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/4/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

final class MyCustomCell: UICollectionViewCell, CalendarItemSelectable {

  @IBOutlet private weak var mainLabel: UILabel!
  @IBOutlet private weak var secondaryLabel: UILabel!

  var titleLabelItem: UILabel {
    return mainLabel
  }

  var subtitleLabelItem: UILabel {
    return secondaryLabel
  }

  // MARK: - LifeCycle

  override func prepareForReuse() {
    super.prepareForReuse()

    mainLabel.text = nil
    contentView.backgroundColor = .clear
  }

  // MARK: - CalendarItemSelectable

  func markIsTodayCell(_ item: CalendarDateItemPresentable) {
    mainLabel.text = "😼"
    if let item = item as? MyDateItem {
      mainLabel.textColor = item.colorForToday
    }
  }

  func selectItem(_ select: Bool, item: CalendarDateItemPresentable) {
    if let item = item as? MyDateItem {
      let color = select ? item.selectionColor : UIColor.clear
      contentView.backgroundColor = color
    }
  }
}
