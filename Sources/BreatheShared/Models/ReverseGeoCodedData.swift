//
//  ReverseGeoCodedData.swift
//  Fume
//
//  Created by Jacob Trentini on 7/12/23.
//

import Foundation

public struct ReverseGeoCodedData: Codable {
    public let placeId:    String
    public let coordinate: Coordinate
    public let name:       String
    
    public init(placeId: String, coordinate: Coordinate, name: String) {
        self.placeId    = placeId
        self.coordinate = coordinate
        self.name       = name
    }
}

extension ReverseGeoCodedData: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(placeId)
        hasher.combine(coordinate)
        hasher.combine(name)
    }
}
