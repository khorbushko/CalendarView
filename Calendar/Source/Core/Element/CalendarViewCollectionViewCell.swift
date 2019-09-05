//
//  CalendarViewCollectionViewCell.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/2/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

/**
 Default implementation for view compomnents used in CalendarView

 - Tag: 1001
 - Version: 0.1
 */

final class CalendarViewCollectionViewCell: UICollectionViewCell, CalendarItemSelectable {

  @IBOutlet private weak var centerView: UIView!
  @IBOutlet private weak var contentContainerView: UIView!

  @IBOutlet private weak var mainTitleLabel: UILabel!
  @IBOutlet private weak var mainSubtitleLabel: UILabel!

  private var backgroundSelectionLayer: CAShapeLayer = CAShapeLayer()
  private var backgroundTodayLayer: CAShapeLayer = CAShapeLayer()

  var titleLabelItem: UILabel {
    return mainTitleLabel
  }

  var subtitleLabelItem: UILabel {
    return mainSubtitleLabel
  }

  // MARK: - LifeCycle

  override func awakeFromNib() {
    super.awakeFromNib()

    clear()
    configureLayers()
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    clear()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    updatePathForLayer()
  }

  // MARK: - CalendarItemSelectable

  func selectItem(_ select: Bool, item: CalendarDateItemPresentable) {
    setNeedsLayout()
    layoutIfNeeded()

    backgroundSelectionLayer.removeAllAnimations()

    let transformAnimation = CalendarAnimator.scaleAnimation(select ? true : false)

    let fromColor = backgroundSelectionLayer.fillColor == nil ? .clear : UIColor(cgColor: backgroundSelectionLayer.fillColor!)
    let toColor = select ? UIColor.red : .clear
    let backgroundColorAnimation = CalendarAnimator.backgroundColorAnimation(fromColor.cgColor, newColor: toColor.cgColor)

    let group = CAAnimationGroup()
    group.animations = [
      transformAnimation,
      backgroundColorAnimation
      ]

    let opacity: Float = select ? 1 : 0
    backgroundSelectionLayer.opacity = opacity
    backgroundSelectionLayer.transform = select ? CATransform3DIdentity : CATransform3DMakeScale(0, 0, 0)
    backgroundSelectionLayer.fillColor = toColor.cgColor
  }

  func markIsTodayCell(_ item: CalendarDateItemPresentable) {
    setNeedsLayout()
    layoutIfNeeded()

    backgroundTodayLayer.opacity = 1
    backgroundTodayLayer.fillColor = UIColor.blue.cgColor
  }

  // MARK: - Private

  private func clear() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
      mainTitleLabel.text = nil
      mainSubtitleLabel.text = nil

      backgroundSelectionLayer.opacity = 0
      backgroundTodayLayer.opacity = 0
    CATransaction.commit()
  }

  private func configureLayers() {
    backgroundTodayLayer.fillColor = UIColor.clear.cgColor
    backgroundTodayLayer.opacity = 0
    backgroundTodayLayer.frame = contentContainerView.bounds
    contentContainerView.layer.insertSublayer(backgroundTodayLayer, below: centerView.layer)

    backgroundSelectionLayer.fillColor = UIColor.clear.cgColor
    backgroundSelectionLayer.opacity = 0
    backgroundSelectionLayer.frame = contentContainerView.bounds
    contentContainerView.layer.insertSublayer(backgroundSelectionLayer, above: backgroundTodayLayer)
  }

  private func updatePathForLayer() {
    let rect = contentContainerView.bounds.insetBy(dx: 3, dy: 3)
    let path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height / 2)
    backgroundSelectionLayer.path = path.cgPath
    backgroundTodayLayer.path = path.cgPath
  }
}
