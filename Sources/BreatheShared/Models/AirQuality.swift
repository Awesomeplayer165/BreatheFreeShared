//
//  AirQuality.swift
//  Fume
//
//  Created by Jacob Trentini on 10/27/22.
//

import Foundation

public struct AirQuality {
    public let aqi: Int
    
    public var airQualityCategory: AirQualityCategory {
        AirQuality.find(aqi: aqi)
    }
    
    public init(aqi: Int) {
        self.aqi = aqi
    }
    
    public init(pm25: Double) {
        self.aqi = AQIUtils.pm2p5_aqi(concentration: pm25).aqi
    }
    
    public static func find(aqi: Int) -> AirQualityCategory {
        AirQualityCategories.good                       .range ~= aqi ? AirQualityCategories.good :
        AirQualityCategories.moderate                   .range ~= aqi ? AirQualityCategories.moderate :
        AirQualityCategories.unhealthyForSensitiveGroups.range ~= aqi ? AirQualityCategories.unhealthyForSensitiveGroups :
        AirQualityCategories.unhealthy                  .range ~= aqi ? AirQualityCategories.unhealthy :
        AirQualityCategories.veryUnhealthy              .range ~= aqi ? AirQualityCategories.veryUnhealthy :
        AirQualityCategories.hazardous                  .range ~= aqi ? AirQualityCategories.hazardous :
        AirQualityCategories.veryHazardous              .range ~= aqi ? AirQualityCategories.veryHazardous :
                                                                        AirQualityCategories.outdatedSensor
    }
}

extension AirQuality: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(aqi)
    }
}
