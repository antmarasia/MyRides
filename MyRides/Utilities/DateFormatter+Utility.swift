//
//  DateFormatter+Utility.swift
//  MyRides
//
//  Created by Anthony Marasia on 1/17/24.
//

import Foundation

extension DateFormatter {
    // Converts 2023-11-16T18:15:00Z to 6:15p
    static func hmma(_ date: Date, timeZoneIdentifier: String?) -> String {
        let formatter = DateFormatter()
        formatter.amSymbol = "a"
        formatter.pmSymbol = "p"
        formatter.dateFormat = "h:mma"
        
        if let timeZoneIdentifier {
            formatter.timeZone = TimeZone(identifier: timeZoneIdentifier)
        }
        
        return formatter.string(from: date)
    }
    
    // Add time zone data to dates returned from api
    static func defaultWithTimeZone(_ date: Date, timeZoneIdentifier: String?) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let timeZoneIdentifier {
            formatter.timeZone = TimeZone(identifier: timeZoneIdentifier)
        }
        
        return formatter.date(from: formatter.string(from: date)) ?? Date()
    }
}
