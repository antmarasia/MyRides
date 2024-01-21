//
//  APIClient.swift
//  MyRides
//
//  Created by Anthony Marasia on 1/18/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case badRequest
}

class APIClient {
    static let shared = APIClient()
    
    private init() {}
    
    func fetchTrips() async throws -> [Trip] {
        let url = URL(string: "https://storage.googleapis.com/hsd-interview-resources/mobile_coding_challenge_data.json")
        let tripResponse: TripResponse = try await fetch(url)
        return tripResponse.trips
    }
    
    private func fetch<T: Decodable>(_ url: URL?, dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss'Z'") async throws -> T {
        guard let url else { throw APIError.invalidURL }
        
        let request = URLRequest(url: url)
        
        //Make the api call
        let (data, response) = try await URLSession.shared.data(for: request)
                
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        //Check if we have http error otherwise decode data
        let fetchedData = try decoder.decode(T.self, from: try mapResponse(data: data, response: response))
        
        return fetchedData
    }
    
    private func mapResponse(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else { return data }
        
        switch httpResponse.statusCode {
        case 200..<300:
            return data
        default:
            throw APIError.badRequest
        }
    }
}
