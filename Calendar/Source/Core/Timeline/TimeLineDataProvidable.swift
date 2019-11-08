//
//  TimeLineDataProvidable.swift
//  Calendar
//
//  Created by Kyryl Horbushko on 06.11.2019.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

protocol TimelineDataProvidable {

  var underlineCalendar: Calendar { get }

  var underlineLocale: Locale { get }
}
