//
//  SensorAverages.swift
//  Fume
//
//  Created by Jacob Trentini on 5/2/23.
//

import Foundation

public struct SensorAverages: Decodable {
    public let pm2_5_1week:    AirQuality
    public let pm2_5_24hour:   AirQuality
    public let pm2_5_6hour:    AirQuality
    public let pm2_5_60minute: AirQuality
    public let pm2_5_30minute: AirQuality
    public let pm2_5_10minute: AirQuality
    
    enum CodingKeys: String, CodingKey {
        case pm2_5_1week    = "pm2.5_1week"
        case pm2_5_24hour   = "pm2.5_24hour"
        case pm2_5_6hour    = "pm2.5_6hour"
        case pm2_5_60minute = "pm2.5_60minute"
        case pm2_5_30minute = "pm2.5_30minute"
        case pm2_5_10minute = "pm2.5_10minute"
    }
    
    public init(
        pm2_5_1week:    AirQuality,
        pm2_5_24hour:   AirQuality,
        pm2_5_6hour:    AirQuality,
        pm2_5_60minute: AirQuality,
        pm2_5_30minute: AirQuality,
        pm2_5_10minute: AirQuality
    ) {
        self.pm2_5_1week    = pm2_5_1week
        self.pm2_5_24hour   = pm2_5_24hour
        self.pm2_5_6hour    = pm2_5_6hour
        self.pm2_5_60minute = pm2_5_60minute
        self.pm2_5_30minute = pm2_5_30minute
        self.pm2_5_10minute = pm2_5_10minute
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        pm2_5_1week    = AirQuality(pm25: try container.decode(Double.self, forKey: .pm2_5_1week))
        pm2_5_24hour   = AirQuality(pm25: try container.decode(Double.self, forKey: .pm2_5_24hour))
        pm2_5_6hour    = AirQuality(pm25: try container.decode(Double.self, forKey: .pm2_5_6hour))
        pm2_5_60minute = AirQuality(pm25: try container.decode(Double.self, forKey: .pm2_5_60minute))
        pm2_5_30minute = AirQuality(pm25: try container.decode(Double.self, forKey: .pm2_5_30minute))
        pm2_5_10minute = AirQuality(pm25: try container.decode(Double.self, forKey: .pm2_5_10minute))
        
    }
    
    public func toArray() -> Array<(String, AirQuality)> {
        [
            ("1w",  pm2_5_1week),
            ("1d",  pm2_5_24hour),
            ("6h",  pm2_5_6hour),
            ("1h",  pm2_5_60minute),
            ("30m", pm2_5_30minute),
            ("10m", pm2_5_10minute)
        ]
    }
}

extension SensorAverages.CodingKeys: CaseIterable { }
