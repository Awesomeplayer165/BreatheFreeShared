//
//  Wildfire.swift
//
//
//  Created by Jacob Trentini on 9/9/23.
//

public struct Wildfire: Codable {
    public let id:                   Int
    public let name:                 String
    public let localizedDescription: String
    public let coordinate:           Coordinate
    public let fireCause:            String
    
    public init(id:                   Int,
                name:                 String,
                localizedDescription: String,
                coordinate:           Coordinate,
                fireCause:            String
    ) {
        self.id                    = id
        self.name                  = name
        self.localizedDescription  = localizedDescription
        self.coordinate            = coordinate
        self.fireCause             = fireCause
    }
}

extension Wildfire: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
