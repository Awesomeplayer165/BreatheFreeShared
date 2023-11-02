//
//  SensorHistory.swift
//  Fume
//
//  Created by Jacob Trentini on 5/2/23.
//

import Foundation

public struct SensorHistory {
    public let average: AirQuality
    public let history: [SensorHistoryAirQualityValues]
    public var animate = false
    
    public init(average: AirQuality, history: [SensorHistoryAirQualityValues], animate: Bool = false) {
        self.average = average
        self.history = history
        self.animate = animate
    }
}

public struct SensorHistoryAirQualityValues {
    public let timestamp: Date
    public let channelA:  AirQuality
    public let channelB:  AirQuality
    
    public init(timestamp: Date, channelA: AirQuality, channelB: AirQuality) {
        self.timestamp = timestamp
        self.channelA  = channelA
        self.channelB  = channelB
    }
}
