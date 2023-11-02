//
//  GEOAPIfy.swift
//  Fume-Swift-Server
//
//  Created by Jacob Trentini on 7/6/23.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import GEOSwift

public class GeoAPIfy {
    public static let shared = GeoAPIfy()
    
    private init() { }
    
    var Endpoint = Endpoints.GEOAPIfy.self
    
    // From coordinates, returns a String
    public func reverseGeoCode(point: Point) async throws -> ReverseGeoCodedData? {
        guard let url = Endpoint.reverse(of: point).asURL() else { throw GeoAPIfyError.failedToEncodeURL }
        
        let (data, response) = try await URLSession.shared.asyncData(from: url)
        let json = try JSONDecoder().decode(FeatureCollection.self, from: data)
        
        if
            let features = json.features.first,
            case let .string(placeId)   = features.properties?["place_id"],
            case let .string(name)      = features.properties?["address_line1"],
            case let .number(latitude)  = features.properties?["lat"],
            case let .number(longitude) = features.properties?["lon"]
        {
            return ReverseGeoCodedData(placeId: placeId,
                                       coordinate: Coordinate(latitude: latitude, longitude: longitude),
                                       name: name)
        } else {
            return nil
        }
    }
    
    public func boundary(detailsOf placeId: String) async throws -> Geometry? {
        guard let url = Endpoint.boundary(detailsOf: placeId).asURL() else { throw GeoAPIfyError.failedToEncodeURL }
        
        let (data, response) = try await URLSession.shared.asyncData(from: url)
        let json = try JSONDecoder().decode(FeatureCollection.self, from: data)
        
        return json.features.first?.geometry
    }
}

extension String {
    public func asURL() -> URL? { URL(string: self) }
}

enum GeoAPIfyError: Error {
    case failedToEncodeURL
    case failedToDecodeJson
}

extension Endpoints {
    public class GEOAPIfy {

        private init() { }
        
        private static var base: String { "https://api.geoapify.com" }
        
        public static func reverse (of location: Point)        -> String { "\(base)/v1/geocode/reverse/?lat=\(location.x)&lon=\(location.y)&type=city&apiKey=\(EnvironmentVariables.shared.geoAPIfyKey)" }
        
        public static func boundary(detailsOf placeId: String) -> String { "\(base)/v2/place-details?id=\(placeId)&apiKey=\(EnvironmentVariables.shared.geoAPIfyKey)" }
    }
}
