//
//  DateFormatter+Extension.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 10/03/2021.
//  Copyright © 2021 Appoly. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    // MARK: - Static Formatters
    
    static func iso8601DateFormatter() -> DateFormatter {
        return .init(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX")
    }

    // MARK: - Initializer
    
    /// Initializes a date formatter with a given format
    /// - Parameters:
    ///   - dateFormat: Format to set date to, for help see `https://nsdateformatter.com`
    ///   - calendar: Calendar the date formatter uses, defaults to `autoUpdatingCurrent`
    ///   - locale: Locale the date formatter uses, defaults to `autoUpdatingCurrent`
    ///   - timeZone: Time Zone the date formatter uses, defaults to `autoUpdatingCurrent`
    convenience init(dateFormat: String,
                     calendar: Calendar = .autoupdatingCurrent,
                     locale: Locale = .autoupdatingCurrent,
                     timeZone: TimeZone = .autoupdatingCurrent) {
        self.init()
        self.calendar = calendar
        self.locale = locale
        self.timeZone = timeZone
        self.dateFormat = dateFormat
    }

}
