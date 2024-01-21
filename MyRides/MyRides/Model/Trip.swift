//
//  Trip.swift
//  MyRides
//
//  Created by Anthony Marasia on 1/17/24.
//

import Foundation

// MARK: - TripResponse
struct TripResponse: Codable {
    let trips: [Trip]
}

// MARK: - Trip
struct Trip: Codable {
    let carpool: Bool
    let claimable: Bool
    let driverCanCancel: Bool
    let driverFareMultiplier: Int
    let driverViewPermission: String
    let estimatedEarnings: Int
    let estimatedNetEarnings: Int
    let id: Int
    let slug: String
    let state: String
    let timeAnchor: String
    let tripOpportunity: Bool
    let updatedAt: String
    let shuttle: Bool
    let inSeries: Bool?
    let passengers: [Passenger]
    let paymentStartsAt: Date
    let paymentEndsAt: Date
    let timeZoneName: String
    let uuid: String
    let inCart: Bool
    let plannedRoute: PlannedRoute
    let waypoints: [Waypoint]

    enum CodingKeys: String, CodingKey {
        case carpool
        case claimable
        case driverCanCancel = "driver_can_cancel"
        case driverFareMultiplier = "driver_fare_multiplier"
        case driverViewPermission = "driver_view_permission"
        case estimatedEarnings = "estimated_earnings"
        case estimatedNetEarnings = "estimated_net_earnings"
        case id
        case slug
        case state
        case timeAnchor = "time_anchor"
        case tripOpportunity = "trip_opportunity"
        case updatedAt = "updated_at"
        case shuttle
        case inSeries = "in_series"
        case passengers
        case paymentStartsAt = "payment_starts_at"
        case paymentEndsAt = "payment_ends_at"
        case timeZoneName = "time_zone_name"
        case uuid
        case inCart = "in_cart"
        case plannedRoute = "planned_route"
        case waypoints
    }
}

extension Trip {
    var paymentStartsAtWithLocalTZ: Date {
        DateFormatter.defaultWithTimeZone(paymentEndsAt, timeZoneIdentifier: timeZoneName)
    }
    
    var paymentEndsAtWithLocalTZ: Date {
        DateFormatter.defaultWithTimeZone(paymentEndsAt, timeZoneIdentifier: timeZoneName)
    }
}

// MARK: - Passenger
struct Passenger: Codable {
    let age: Int
    let boosterSeat: Bool
    let displayName: String
    let firstName: String
    let initials: String
    let mustBeMet: Bool?
    let frontSeatAuthorized: Bool
    let dateOfBirth: Date
    let gender: String
    let riderNotes: String
    let slug: String
    let uuid: String

    enum CodingKeys: String, CodingKey {
        case age
        case boosterSeat = "booster_seat"
        case displayName = "display_name"
        case firstName = "first_name"
        case initials
        case mustBeMet = "must_be_met"
        case frontSeatAuthorized = "front_seat_authorized"
        case dateOfBirth = "date_of_birth"
        case gender
        case riderNotes = "rider_notes"
        case slug
        case uuid
    }
}

// MARK: - PlannedRoute
struct PlannedRoute: Codable {
    let id: Int
    let totalTime: Double
    let totalDistance: Int
    let startsAt: Date
    let endsAt: Date
    let overviewPolyline: String
    let legs: [Leg]

    enum CodingKeys: String, CodingKey {
        case id
        case totalTime = "total_time"
        case totalDistance = "total_distance"
        case startsAt = "starts_at"
        case endsAt = "ends_at"
        case overviewPolyline = "overview_polyline"
        case legs
    }
}

// MARK: - Leg
struct Leg: Codable {
    let id: Int
    let slug: String
    let startsAt: Date
    let endsAt: Date
    let position: Int
    let startWaypointID: Int
    let endWaypointID: Int

    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case startsAt = "starts_at"
        case endsAt = "ends_at"
        case position
        case startWaypointID = "start_waypoint_id"
        case endWaypointID = "end_waypoint_id"
    }
}

// MARK: - Waypoint
struct Waypoint: Codable {
    let id: Int
    let accountLocations: [AccountLocation]
    let estimatedArrivesAt: Date
    let location: Location
    let passengers: [Passenger]

    enum CodingKeys: String, CodingKey {
        case id
        case accountLocations = "account_locations"
        case estimatedArrivesAt = "estimated_arrives_at"
        case location
        case passengers
    }
}

// MARK: - AccountLocation
struct AccountLocation: Codable {
    let accountID: Int
    let address: String
    let id: Int
    let lat: Double
    let lng: Double
    let pickupProcedure: PickupProcedure
    let pickupProcedureTime: Int
    let dropoffProcedureTime: Int
    let placeID: String
    let pickupProcedureInstructions: String?

    enum CodingKeys: String, CodingKey {
        case accountID = "account_id"
        case address
        case id
        case lat
        case lng
        case pickupProcedure = "pickup_procedure"
        case pickupProcedureTime = "pickup_procedure_time"
        case dropoffProcedureTime = "dropoff_procedure_time"
        case placeID = "place_id"
        case pickupProcedureInstructions = "pickup_procedure_instructions"
    }
}

// MARK: - PickupProcedure
struct PickupProcedure: Codable {
    let time: Int
    let instructions: String?
}

// MARK: - Location
struct Location: Codable {
    let id: Int
    let address: String
    let lat: Double
    let lng: Double
    let placeID: String
    let streetAddress: String
    let streetName: String
    let streetNumber: String
    let city: String
    let zipcode: String
    let state: String

    enum CodingKeys: String, CodingKey {
        case id
        case address
        case lat
        case lng
        case placeID = "place_id"
        case streetAddress = "street_address"
        case streetName = "street_name"
        case streetNumber = "street_number"
        case city
        case zipcode
        case state
    }
}
