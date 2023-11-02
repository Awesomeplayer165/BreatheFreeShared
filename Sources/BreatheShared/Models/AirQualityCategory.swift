//
//  AirQualityCategory.swift
//  Fume
//
//  Created by Jacob Trentini on 7/20/23.
//

import Foundation

public struct AirQualityCategory {
    public let name:            String
    public let description:     String
    public let airQualityColor: AirQualityColor
    public let range:           ClosedRange<Int>
}

public struct AirQualityColor {
    public let adaptiveColor:   String
    public let primaryColor:    String
    public let secondaryColor:  String
}

public final class AirQualityCategories {
    public static let good = AirQualityCategory(name: "Good",
                                                description: "Air quality is considered satisfactory, and air pollution poses little or no risk.",
                                                airQualityColor: AirQualityColor(adaptiveColor:  "Good Adaptive",
                                                                                 primaryColor:   "Good",
                                                                                 secondaryColor: "Good Secondary"),
                                                range: 0...50)
    
    public static let moderate = AirQualityCategory(name: "Moderate",
                                                    description: "Air quality is acceptable; however, for some pollutants there may be a moderate health concern for a very small number of people who are unusually sensitive to air pollution.",
                                                    airQualityColor: AirQualityColor(adaptiveColor:  "Moderate Adaptive",
                                                                                     primaryColor:   "Moderate",
                                                                                     secondaryColor: "Moderate Secondary"),
                                                    range: 51...100)
    
    public static let unhealthyForSensitiveGroups = AirQualityCategory(name: "Unhealthy for Sensitive Groups",
                                                                       description: "Members of sensitive groups may experience health effects. The general public is not likely to be affected.",
                                                                       airQualityColor: AirQualityColor(adaptiveColor:  "Unhealthy for Sensitive Groups Adaptive",
                                                                                                        primaryColor:   "Unhealthy for Sensitive Groups",
                                                                                                        secondaryColor: "Unhealthy for Sensitive Groups Secondary"),
                                                                       range: 101...150)
    
    public static let unhealthy = AirQualityCategory(name: "Unhealthy",
                                                     description: "Everyone may begin to experience health effects; members of sensitive groups may experience more serious health effects.",
                                                     airQualityColor: AirQualityColor(adaptiveColor:  "Unhealthy Adaptive",
                                                                                      primaryColor:   "Unhealthy",
                                                                                      secondaryColor: "Unhealthy Secondary"),
                                                     range: 151...200)
    
    public static let veryUnhealthy = AirQualityCategory(name: "Very Unhealthy",
                                                         description: "Health warnings of emergency conditions. The entire population is more likely to be affected.",
                                                         airQualityColor: AirQualityColor(adaptiveColor:  "Very Unhealthy Adaptive",
                                                                                          primaryColor:   "Very Unhealthy",
                                                                                          secondaryColor: "Very Unhealthy Secondary"),
                                                         range: 201...300)
    
    public static let hazardous = AirQualityCategory(name: "Hazardous",
                                                     description: "Health alert: Everyone may experience serious health effects.",
                                                     airQualityColor: AirQualityColor(adaptiveColor:  "Hazardous Adaptive",
                                                                                      primaryColor:   "Hazardous",
                                                                                      secondaryColor: "Hazardous Secondary"),
                                                     range: 301...400)
    
    public static let veryHazardous = AirQualityCategory(name: "Very Hazardous",
                                                         description: "Health alert: Everyone may experience serious health effects.",
                                                         airQualityColor: AirQualityColor(adaptiveColor:  "Very Hazardous Adaptive",
                                                                                          primaryColor:   "Very Hazardous",
                                                                                          secondaryColor: "Very Hazardous Secondary"),
                                                         range: 401...500)
    
    public static let outdatedSensor = AirQualityCategory(name: "Outdated Sensor",
                                                          description: "The sensor has not uploaded sensor information for at least 2 days. This only applies to sensors and the sensor is be excluded from Group By City mode calculations.",
                                                          airQualityColor: AirQualityColor(adaptiveColor:  "gray",
                                                                                           primaryColor:   "gray",
                                                                                           secondaryColor: "gray"),
                                                          range: -1...500)
    
    public static let all = [
        AirQualityCategories.good,
        AirQualityCategories.moderate,
        AirQualityCategories.unhealthyForSensitiveGroups,
        AirQualityCategories.unhealthy,
        AirQualityCategories.veryUnhealthy,
        AirQualityCategories.hazardous,
        AirQualityCategories.veryHazardous,
        AirQualityCategories.outdatedSensor
    ]
}
