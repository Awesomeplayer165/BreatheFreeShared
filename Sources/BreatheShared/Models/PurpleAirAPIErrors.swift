//
//  PurpleAirAPIErrors.swift
//  Fume
//
//  Created by Jacob Trentini on 5/13/23.
//

import Foundation
import Alamofire

public enum PurpleAirAPIErrors: Error {
    case alamofireError(AFError)
    case failedDecoding
}
