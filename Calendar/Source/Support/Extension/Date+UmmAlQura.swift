//
//  Date.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 12.11.2019.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

public typealias DateString = String
public typealias MonthString = String
public typealias YearString = String

public extension Date {

  func ummAlQuraDateToStringComponents() -> (DateString, MonthString, YearString) {
    let comp = UmmAlQuraDateConverter().convertDateToUmmAlQura(date: self)
    return ("\(comp.0)", "\(comp.1)", "\(comp.2)")
  }
}
