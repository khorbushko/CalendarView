//
//  UICollectionView+Animations.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 05.11.2019.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

internal extension UICollectionView {

  func animateVisibleCells(_ toLeft: Bool, skippedCount: Int) {
    layoutIfNeeded()
    var visibleItems = indexPathsForVisibleItems.sorted()
    if !toLeft {
      visibleItems.reverse()
    }

    let skippedIdxValue = skippedCount

    for (idx, item) in visibleItems.enumerated() {
      let cell = self.cellForItem(at: item)

      if item.item >= skippedIdxValue {
        cell?.transform = .init(scaleX: 0.1, y: 0.1)
        cell?.alpha = 0
        UIView.animate(withDuration: Double(idx) * 0.01) {
          cell?.transform = .identity
          cell?.alpha = 1
        }
      } else {
        cell?.transform = .identity
        cell?.alpha = 1
      }
    }
  }
}
