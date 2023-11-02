//
//  File.swift
//  
//
//  Created by Jacob Trentini on 9/9/23.
//

import Foundation

public struct AirNowStation: Codable {
    public let name:        String
    public let airQuality:  AirQuality
    public let coordinate:  Coordinate
    public let lastUpdated: Date
    
    public init(name:        String,
                airQuality:  AirQuality,
                coordinate:  Coordinate,
                lastUpdated: Date
    ) {
        self.name        = name
        self.airQuality  = airQuality
        self.coordinate  = coordinate
        self.lastUpdated = lastUpdated
    }

    
    enum CodingKeys: String, CodingKey {
        case name, airQuality, coordinate, lastUpdated
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name        =                             try container.decode(String.self,     forKey: .name)
        airQuality  = AirQuality(aqi:             try container.decode(Int.self,        forKey: .airQuality))
        coordinate  =                             try container.decode(Coordinate.self, forKey: .coordinate)
        lastUpdated = Date(timeIntervalSince1970: try container.decode(Double.self,     forKey: .lastUpdated))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name,                              forKey: .name)
        try container.encode(airQuality.aqi,                    forKey: .airQuality)
        try container.encode(coordinate,                        forKey: .coordinate)
        try container.encode(lastUpdated.timeIntervalSince1970, forKey: .lastUpdated)
    }
}

extension AirNowStation: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate)
    }
}

