//
//  CalendarAnimator.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 9/3/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

final class CalendarAnimator {

  static func swipeTransitionToLeftSide(_ leftSide: Bool, duration: TimeInterval = 0.3) -> CATransition {
    let transition = CATransition()
    transition.type = CATransitionType.push
    transition.subtype = leftSide ? CATransitionSubtype.fromRight : CATransitionSubtype.fromLeft
    transition.duration = duration
    return transition
  }

  class func scaleAnimation(_ scaleIn: Bool, duration: TimeInterval = 0.3) -> CABasicAnimation {
    let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
    scaleAnimation.fromValue = scaleIn ? 0.3 : 1
    scaleAnimation.toValue = scaleIn ? 1 : 0.3
    scaleAnimation.duration = duration
    scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    return scaleAnimation
  }

  class func backgroundColorAnimation(_ fromColor: CGColor, newColor: CGColor, duration: TimeInterval = 0.3) -> CABasicAnimation {
    let animation: CABasicAnimation = CABasicAnimation(keyPath: "fillColor")
    animation.fromValue = fromColor
    animation.toValue = newColor
    animation.duration = duration
    animation.isRemovedOnCompletion = true
    animation.fillMode = CAMediaTimingFillMode.forwards
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

    return animation
  }
}
