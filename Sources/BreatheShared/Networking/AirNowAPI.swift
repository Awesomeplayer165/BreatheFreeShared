//
//  AirNowAPI.swift
//
//
//  Created by Jacob Trentini on 9/9/23.
//


import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public class AirNowAPI {
    public static let shared = AirNowAPI()
    
    private init() { }
    
    private let Endpoint = Endpoints.AirNowAPI.self
    
    private struct AirNowStationJson: Codable {
        let latitude:  Double
        let longitude: Double
        let utc:       Date
        let siteName:  String
        let aqi:       Int
        
        enum CodingKeys: String, CodingKey {
            case latitude  = "Latitude"
            case longitude = "Longitude"
            case utc       = "UTC"
            case aqi       = "AQI"
            case siteName  = "SiteName"
        }
        
        func toAirNowStation() -> AirNowStation {
            AirNowStation(name: siteName,
                          airQuality: AirQuality(aqi: aqi),
                          coordinate: Coordinate(latitude: latitude, longitude: longitude),
                          lastUpdated: utc)
        }
    }
    
    public func dataStations() async throws -> [AirNowStation] {
        guard let url = Endpoints.AirNowAPI.dataStations().asURL() else { throw GeoAPIfyError.failedToEncodeURL }
        
        let (data, response) = try await URLSession.shared.asyncData(from: url)
        
        let decoder = JSONDecoder()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return try decoder
            .decode([AirNowStationJson].self, from: data)
            .map { $0.toAirNowStation() }
    }
}


extension Endpoints {
    public class AirNowAPI {
        
        private init() { }
        
        private static var base: String { "https://www.airnowapi.org" }
        
        public static func dataStations() -> String {
            return "\(base)/aq/data/?parameters=PM25&BBOX=-124.205070,28.716781,-75.337882,45.419415&dataType=A&format=application/json&verbose=1&monitorType=2&includerawconcentrations=0&API_KEY=\(EnvironmentVariables.shared.airNowAPIKey)"
        }
    }
}
