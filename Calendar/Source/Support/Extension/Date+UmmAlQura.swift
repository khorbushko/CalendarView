//
//  Date.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 12.11.2019.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

public typealias DateValue = Int
public typealias MonthValue = Int
public typealias YearValue = Int

public extension Date {

  func ummAlQuraDateToStringComponents() -> (date: DateValue, month: MonthValue, year: YearValue) {
    let comp = UmmAlQuraDateConverter().convertDateToUmmAlQura(date: self)
    let day = comp.0
    let month = comp.1 == 0 ? 12 : comp.1
    let year = comp.1 == 0 ? comp.2 - 1 : comp.2
    return (day, month, year)
  }
}
