//
//  City.swift
//  Fume
//
//  Created by Jacob Trentini on 7/16/23.
//

import Foundation

public struct City: Codable {
    public let airQuality:          AirQuality
    public let temperature:         Int
    public let humidity:            Int
    public let reverseGeoCodedData: ReverseGeoCodedData
    public let linkedSensors:       [Int]
    
    public init(airQuality:          AirQuality,
                temperature:         Int,
                humidity:            Int,
                reverseGeoCodedData: ReverseGeoCodedData,
                linkedSensors:       [Int]
    ) {
        self.airQuality          = airQuality
        self.temperature         = temperature
        self.humidity            = humidity
        self.reverseGeoCodedData = reverseGeoCodedData
        self.linkedSensors       = linkedSensors
    }
    
    public enum CodingKeys: String, CodingKey {
        case airQuality
        case temperature
        case humidity
        case reverseGeoCodedData = "data"
        case linkedSensors
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.airQuality.aqi,      forKey: .airQuality)
        try container.encode(self.temperature,         forKey: .temperature)
        try container.encode(self.humidity,            forKey: .humidity)
        try container.encode(self.reverseGeoCodedData, forKey: .reverseGeoCodedData)
        try container.encode(self.linkedSensors,       forKey: .linkedSensors)
    }
    
    public init(from decoder: Decoder) throws {
        let container =                       try decoder.container(keyedBy: CodingKeys.self)
        
        self.init(airQuality: AirQuality(aqi: try container.decode(Int.self,                 forKey: .airQuality)),
                  temperature:                try container.decode(Int.self,                 forKey: .temperature),
                  humidity:                   try container.decode(Int.self,                 forKey: .humidity),
                  reverseGeoCodedData:        try container.decode(ReverseGeoCodedData.self, forKey: .reverseGeoCodedData),
                  linkedSensors:              try container.decode([Int].self,               forKey: .linkedSensors))
    }
}

extension City: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(reverseGeoCodedData.coordinate)
        hasher.combine(reverseGeoCodedData.name)
    }
}
