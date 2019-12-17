//
//  UmmAlQuaraDateConverter.swift
//  Calendar
//
//  Created by Nataliia Volovach on 31.10.2019.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

typealias Day = Int
typealias Month = Int
typealias Year = Int

typealias DateTransfromedComponents = (Day, Month, Year)

/**
 Implementation of the UmmAlQura or 'Saudi' calendar.

 See also

    [en.wikipedia.org](http://en.wikipedia.org/wiki/Islamic_calendar#Saudi_Arabia.27s_Umm_al-Qura_calendar)

    [ummulqura.org](http://www.ummulqura.org.sa/About.aspx)

    [science.uu.nl](http://www.staff.science.uu.nl/~gent0113/islam/ummalqura.htm)

*/
internal final class UmmAlQuraDateConverter {

  // MARK: - Gregorian to Umm al-Qura

  func convertTimeIntervalToUmmAlQura(time: TimeInterval) -> DateTransfromedComponents {
    let date = Date(timeIntervalSince1970: time)
    return convertDateToUmmAlQura(date: date)
  }

  func convertDateToUmmAlQura(date: Date) -> DateTransfromedComponents {
    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents([.year, .month, .day], from: date)

    guard let day = components.day,
      let month = components.month,
      let year = components.year else {
        fatalError("must have all components")
    }

    let hDateInfo = daysToUmmAlQura(jdn: gregorianToDays(gYear: year, gMonth: month, gDay: day))
    return hDateInfo
  }

  func convertToUmmAlQura(gYear: Int, gMonth: Int, gDay: Int) -> DateTransfromedComponents {
    let g2dRes = gregorianToDays(gYear: gYear, gMonth: gMonth, gDay: gDay)
    let hDateInfo = daysToUmmAlQura(jdn: g2dRes)
    return hDateInfo
  }

  // MARK: - Umm al-Qura to Gregorian

  func convertToGregorian(hYear: Int, hMonth: Int, hDay: Int) -> DateTransfromedComponents {
    let gDateInfo = daysToGregorian(jdn: hijiryToDays(hijiryYear: hYear, hijiryMonth: hMonth, hijiryDay: hDay))
    return gDateInfo
  }

  func converToGregorian(date: Date) -> DateTransfromedComponents {
    let calendar = Calendar(identifier: .islamicUmmAlQura)
    let components = calendar.dateComponents([.day, .month, .year], from: date)
    guard let hYear = components.year,
      let hMonth = components.month,
      let hDay = components.day else {
        fatalError("must have all components")
    }

    let gDateInfo = daysToGregorian(jdn: hijiryToDays(hijiryYear: hYear, hijiryMonth: hMonth, hijiryDay: hDay))
    return gDateInfo
  }

  // MARK: - Components

  /*
   Returns the length of a UmmAlQura month in a UmmAlQura year.
   This returns the length of the month in days.
   */
  func daysInMonth(year: Int, month: Int) -> Int {
    let i = getNewMoonMJDNIndex(hijiryYear: year, hijiryMonth: month)
    return UmmAlQuaraCalendarData.dayRanges[i] - UmmAlQuaraCalendarData.dayRanges[i - 1]
  }

  /*
   Returns the length of the given year.
   This returns the length of the year in days, either 354 or 355.
   */
  func lengthOfYear(_ year: Int) -> Int {
    var length: Int = 0
    for month in stride(from: 0, to: 12, by: 1) {
      length += daysInMonth(year: year, month: month)
    }

    return length
  }

  func weekdayUmmAlQura(from gregorianDate: Date) -> Int {
    let components = convertDateToUmmAlQura(date: gregorianDate)
    let index = hijiryToDays(hijiryYear: components.2, hijiryMonth: components.1, hijiryDay: components.0)
    let day = (index + 1) % 7
    return day + 1
  }

  // MARK: - Private

  private func daysToUmmAlQura(jdn: Int) -> DateTransfromedComponents {
    let mjdn = jdn - 2400000
    let i = getNewMoonMJDNIndexByJDN(mjdn: mjdn)
    let totalMonths = i + 15292
    let cYears = Int(totalMonths / 12)
    let hijiryYear = cYears + 1
    let hijiryMonth = totalMonths - 12 * cYears
    let hijiryDay = mjdn - UmmAlQuaraCalendarData.dayRanges[i - 1] + 1
    return (hijiryDay, hijiryMonth, hijiryYear)
  }

  private func gregorianToDays(gYear: Int, gMonth: Int, gDay: Int) -> Int {

    let days1 = div(a: (gYear + div(a: gMonth - 8, b: 6) + 100100) * 1461, b: 4) + div(a: 153 * mod(a: gMonth + 9, b: 12) + 2, b: 5)
      + gDay - 34840408
    let days2 = days1 - div(a: div(a: gYear + 100100 + div(a: gMonth - 8, b: 6), b: 100) * 3, b: 4) + 752
    return days2
  }

  private func daysToGregorian(jdn: Int) -> DateTransfromedComponents {
    let days = 4 * jdn + 139361631
    let days2 = days + div(a: div(a: 4 * jdn + 183187720, b: 146097) * 3, b: 4) * 4 - 3908
    let i = div(a: mod(a: days2, b: 1461), b: 4) * 5 + 308
    let gregorianDay = div(a: mod(a: i, b: 153), b: 5) + 1
    let gregorianMonth = mod(a: div(a: i, b: 153), b: 12) + 1
    let gregorianYear = div(a: days2, b: 1461) - 100100 + div(a: 8 - gregorianMonth, b: 6)
    return (gregorianDay, gregorianMonth, gregorianYear)
  }

  // MARK: - Modified Chronological Julian Day Number

  private func getNewMoonMJDNIndexByJDN(mjdn: Int) -> Int {
    let index = UmmAlQuaraCalendarData.dayRanges.firstIndex(where: { $0 > mjdn }) ?? -1
    return index
  }

  private func getNewMoonMJDNIndex(hijiryYear: Int, hijiryMonth: Int) -> Int {
    let cYears = hijiryYear - 1
    let totalMonths = (cYears * 12) + 1 + (hijiryMonth - 1)
    return totalMonths - 15292
  }

  private func hijiryToDays(hijiryYear: Int, hijiryMonth: Int, hijiryDay: Int) -> Int {
    let i = getNewMoonMJDNIndex(hijiryYear: hijiryYear, hijiryMonth: hijiryMonth)
    let mjdn = hijiryDay + UmmAlQuaraCalendarData.dayRanges[i - 1] - 1

    return mjdn + 2400000
  }

  // MARK: - Utils

  private func div(a: Int, b: Int) -> Int {
    return Int(a / b)
  }

  private func mod(a: Int, b: Int) -> Int {
    return a - Int ((a / b) * b)
  }
}
