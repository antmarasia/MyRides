//
//  MyRides.swift
//  MyRides
//
//  Created by Anthony Marasia on 1/19/24.
//

import Foundation

struct MyRides {
    let sections: [RideSection]
    
    init(trips: [Trip]) {
        self.sections = MyRides.getSections(trips: trips)
    }
    
    private static func getSections(trips: [Trip]) -> [RideSection] {
        var sections = [RideSection]()
        
        guard let firstTrip = trips.first else { return sections }
        
        var lastTripDay: Date = firstTrip.paymentStartsAtWithLocalTZ
        var endTime: Date = firstTrip.paymentEndsAtWithLocalTZ
        var estimatedEarnings: Int = 0
        var count: Int = 0
        var sectionTrips = [Trip]()
        
        for (index, trip) in trips.enumerated() {
            // Same day so in same section
            if Calendar.current.isDate(lastTripDay, inSameDayAs: trip.paymentStartsAtWithLocalTZ) {
                count += 1
                estimatedEarnings += trip.estimatedEarnings
                lastTripDay = trip.paymentStartsAtWithLocalTZ
                endTime = trip.paymentEndsAtWithLocalTZ
                sectionTrips.append(trip)
            } else {
                // Save the last section
                let newSection = RideSection(count: count, startTime: lastTripDay, endTime: endTime, estimatedEarnings: estimatedEarnings, trips: sectionTrips)
                sections.append(newSection)
                sectionTrips.removeAll()
                
                // Reset the section
                count = 1
                lastTripDay = trip.paymentStartsAtWithLocalTZ
                endTime = trip.paymentEndsAtWithLocalTZ
                estimatedEarnings = trip.estimatedEarnings
                sectionTrips.append(trip)
            }
            
            // Save the last built section
            if index == trips.count - 1 {
                let newSection = RideSection(count: count, startTime: lastTripDay, endTime: endTime, estimatedEarnings: estimatedEarnings, trips: sectionTrips)
                sections.append(newSection)
            }
            
        }
        return sections
    }
}

struct RideSection {
    let count: Int
    let startTime: Date
    let endTime: Date
    let estimatedEarnings: Int
    let trips: [Trip]
}
