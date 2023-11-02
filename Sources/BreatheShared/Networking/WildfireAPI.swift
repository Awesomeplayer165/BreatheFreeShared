//
//  WildfireAPI.swift
//  
//
//  Created by Jacob Trentini on 9/9/23.
//


import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import GEOSwift

public class WildfireAPI {
    public static let shared = WildfireAPI()
    
    private init() { }
    
    private let Endpoint = Endpoints.Wildfires.self
    
    public func wildfireIncidents() async throws -> [Wildfire] {
        guard let url = Endpoint.wildfireIncidents().asURL() else { throw GeoAPIfyError.failedToEncodeURL }
        
        let (data, response) = try await URLSession.shared.asyncData(from: url)
        let geoJson = try JSONDecoder().decode(FeatureCollection.self, from: data)
        
        var wildfires: [Wildfire] = []
        
        for feature in geoJson.features {
            if
                case .number(let id)               = feature.properties?["SourceOID"],
                case .string(let name)             = feature.properties?["IncidentName"]             ?? "",
                case .string(let shortDescription) = feature.properties?["IncidentShortDescription"] ?? "",
                case .number(let latitude)         = feature.properties?["InitialLatitude"]          ?? 0.0,
                case .number(let longitude)        = feature.properties?["InitialLongitude"]         ?? 0.0,
                case .string(let fireCause)        = feature.properties?["FireCause"]                ?? ""
            {
                wildfires.append(Wildfire(id: Int(id),
                                          name: name,
                                          localizedDescription: shortDescription,
                                          coordinate: Coordinate(latitude: latitude, longitude: longitude),
                                          fireCause: fireCause))
            }
        }
        
        return wildfires
    }
}


extension Endpoints {
    public class Wildfires {
        
        private init() { }
        
        private static let base = "https://services3.arcgis.com"
        
        public static func wildfireIncidents() -> String {
            "\(base)/T4QMspbfLg3qTGWY/arcgis/rest/services/WFIGS_Incident_Locations_Current/FeatureServer/0/query?where=1%3D1&outFields=SourceOID,IncidentName,IncidentShortDescription,InitialLatitude,InitialLongitude,FireCause&outSR=4326&f=geojson"
        }
    }
}
