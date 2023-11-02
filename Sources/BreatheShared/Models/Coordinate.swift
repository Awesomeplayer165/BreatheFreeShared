//
//  Coordinate.swift
//  Fume
//
//  Created by Jacob Trentini on 7/17/23.
//

import Foundation

public struct Coordinate: Codable {
    public var latitude:  Double
    public var longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
}

extension Coordinate: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
