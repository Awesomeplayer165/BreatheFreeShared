//
//  Sensor.swift
//  Fume
//
//  Created by Jacob Trentini on 7/6/23.
//

import Foundation

public class Sensor: Codable {
    public var index:        Int
    public var name:         String
    public var coordinate:   Coordinate
    public var airQuality:   AirQuality
    public var temperature:  Int
    public var humidity:     Int
    public var locationType: SensorLocation
    public var pollen:       Double
    public var lastUpdated:  Date
    
    public init(index:        Int,
                name:         String,
                coordinate:   Coordinate,
                airQuality:   AirQuality,
                temperature:  Int,
                humidity:     Int,
                locationType: SensorLocation,
                pollen:       Double,
                lastUpdated:  Date
    ) {
        self.index        = index
        self.name         = name
        self.coordinate   = coordinate
        self.airQuality   = airQuality
        self.temperature  = temperature
        self.humidity     = humidity
        self.locationType = locationType
        self.pollen       = pollen
        self.lastUpdated  = lastUpdated
    }
    
    public required init(from decoder: Decoder) throws {
        
        var container = try decoder.unkeyedContainer()
        
        self.index = UUID().hashValue
        self.name = ""
        self.coordinate = Coordinate(latitude: 0, longitude: 0)
        self.airQuality = AirQuality(pm25: 0)
        self.temperature = 0
        self.humidity = 0
        self.locationType = .outdoor
        self.pollen = 0.0
        self.lastUpdated = Date()
        
        for field in PurpleAirAPI.shared.activeAPIFields {
            switch field {
            case PurpleAirAPI.SensorFields.index       .rawValue: self.index                =                             try container.decode(Int.self)
            case PurpleAirAPI.SensorFields.name        .rawValue: self.name                 =                             try container.decode(String.self)
            case PurpleAirAPI.SensorFields.latitude    .rawValue: self.coordinate.latitude  =                             try container.decode(Double.self)
            case PurpleAirAPI.SensorFields.longitude   .rawValue: self.coordinate.longitude =                             try container.decode(Double.self)
            case PurpleAirAPI.SensorFields.pm2_5       .rawValue: self.airQuality           =  AirQuality(pm25: Double(   try container.decode(Double.self)))
            case PurpleAirAPI.SensorFields.temperature .rawValue: self.temperature          = Int(                        try container.decode(Double.self))
            case PurpleAirAPI.SensorFields.humidity    .rawValue: self.humidity             = Int(                        try container.decode(Double.self))
            case PurpleAirAPI.SensorFields.locationType.rawValue: self.locationType         = SensorLocation(rawValue:    try container.decode(Int.self)) ?? .outdoor
            case PurpleAirAPI.SensorFields.pm10        .rawValue: self.pollen               =                             try container.decode(Double.self)
            case PurpleAirAPI.SensorFields.lastUpdated .rawValue: self.lastUpdated          = Date(timeIntervalSince1970: try container.decode(Double.self))
            default:
                throw PurpleAirAPIErrors.failedDecoding
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        
        try container.encode(index)
        try container.encode(name)
        try container.encode(coordinate)
        try container.encode(airQuality.aqi)
        try container.encode(temperature)
        try container.encode(humidity)
        try container.encode(locationType.rawValue)
        try container.encode(pollen)
        try container.encode(lastUpdated.timeIntervalSince1970)
    }
}

extension Sensor: Identifiable {
    public typealias ID = Int
    
    public var id: Int { index }
}

extension Sensor: Hashable {
    public static func == (lhs: Sensor, rhs: Sensor) -> Bool { lhs.id == rhs.id }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public enum SensorLocation: Int {
    case outdoor
    case indoor
}
