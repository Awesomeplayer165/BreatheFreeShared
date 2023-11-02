//
//  PurpleAirAPI.swift
//  Breathe
//
//  Created by Jacob Trentini on 1/20/23.
//

import Foundation
import Alamofire

public class PurpleAirAPI {
    public static let shared = PurpleAirAPI()
    private init() {}
    
    public private(set) var activeAPIFields: [String] = []
    
    public enum SensorFields: String, CaseIterable {
        case index        = "sensor_index"
        case name         = "name"
        case latitude     = "latitude"
        case longitude    = "longitude"
        case pm2_5        = "pm2.5"
        case temperature  = "temperature"
        case humidity     = "humidity"
        case locationType = "location_type"
        case pm10         = "pm10.0"
        case lastUpdated  = "last_modified"
    
        var associatedType: Any {
            switch self {
            case .index:        return Int   .self
            case .name:         return String.self
            case .latitude:     return Double.self
            case .longitude:    return Double.self
            case .pm2_5:        return Double.self
            case .temperature:  return Double.self
            case .humidity:     return Double.self
            case .locationType: return Int   .self
            case .pm10:         return Double   .self
            case .lastUpdated:  return Double.self
            }
        }
    }
    
    public func sensors() async throws -> Set<Sensor> {
        let data = try await fetchData(for: AF.request("https://api.purpleair.com/v1/sensors",
                                                       parameters: ["fields": SensorFields.allCases.map { $0.rawValue }.joined(separator: ",")],
                                                       headers: ["X-API-Key": EnvironmentVariables.shared.purpleAirAPIKey]))
        
        if
            let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let jsonSensors = jsonObject["data"] as? [[Any]],
            let apiFields = jsonObject["fields"] as? [String]
        {
            activeAPIFields = apiFields
            return Set(jsonSensors.compactMap { try? JSONDecoder().decode(Sensor.self, from: JSONSerialization.data(withJSONObject: $0)) })
        } else {
            throw PurpleAirAPIErrors.failedDecoding
        }
    }
    
    public func sensorData(id: Int) async throws -> Sensor {
        let data = try await fetchData(for: AF.request("https://api.purpleair.com/v1/sensors/\(id)",
                                                       parameters: ["fields": SensorFields.allCases.map { $0.rawValue }.joined(separator: ","),
                                                                    "api_key": EnvironmentVariables.shared.purpleAirAPIKey]))
        
        if
            let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let jsonSensor = jsonObject["sensor"] as? [String: Any]
        {
            activeAPIFields = Array(jsonSensor.keys)
            let sensor = try JSONDecoder().decode(Sensor.self, from: JSONSerialization.data(withJSONObject: Array(jsonSensor.values)))
            return sensor
        } else {
            throw PurpleAirAPIErrors.failedDecoding
        }
    }
    
    public func sensorHistory(forSensor sensorIndex: Int) async throws -> SensorHistory {
        let data = try await fetchData(for: AF.request("https://pastebin.com/raw/JTKEnXgs"))
        
        var rows = String(data: data, encoding: .utf8)?.components(separatedBy: "\n")
        
        rows?.removeFirst()
        
        guard let rows else { throw PurpleAirAPIErrors.failedDecoding }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        var histories: [SensorHistoryAirQualityValues] = []
        
        dump(rows)
        
        for row in rows {
            let columns = row.components(separatedBy: ",")
            
            if columns.count == 4 {
                if
                    let timestamp = dateFormatter.date(from: columns[0]),
                    let pm25_a = Double(columns[2]),
                    let pm25_b = Double(columns[3])
                {
                    
                    histories.append(
                        .init(timestamp: timestamp,
                              channelA: AirQuality(pm25: pm25_a),
                              channelB: AirQuality(pm25: pm25_b))
                    )
                }
            }
        }
        
        let channelAAverages = (histories.reduce(0) { $0 + $1.channelA.aqi }) / histories.count
        let channelABverages = (histories.reduce(0) { $0 + $1.channelB.aqi }) / histories.count
        
        histories.sort { $0.timestamp < $1.timestamp }
        
        return SensorHistory(average: AirQuality(aqi: (channelAAverages + channelABverages) / 2), history: histories)
    }
    
    public func sensorAverages(forSensor sensorIndex: Int) async throws -> SensorAverages {
        let data = try await fetchData(for: AF.request("https://api.purpleair.com/v1/sensors/\(sensorIndex)",
                                                       parameters: [
                                                        "fields": SensorAverages.CodingKeys.allCases.map { $0.rawValue }.joined(separator: ","),
                                                        "sensor_index": sensorIndex
                                                       ],
                                                       headers: ["X-API-Key": EnvironmentVariables.shared.purpleAirAPIKey]))
        
        if
            let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let sensor = jsonObject["sensor"] as? [String: Any],
            let stats = sensor["stats"] as? [String: Any]
        {
            return try JSONDecoder().decode(SensorAverages.self, from: JSONSerialization.data(withJSONObject: stats))
        } else {
            throw PurpleAirAPIErrors.failedDecoding
        }
    }

    private func fetchData(for request: DataRequest) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            request
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):  continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
        }
    }
}

/// Defines the possible errors
public enum URLSessionAsyncErrors: Error {
    case invalidUrlResponse, missingResponseData
}

/// An extension that provides async support for fetching a URL
///
/// Needed because the Linux version of Swift does not support async URLSession yet.
public extension URLSession {
 
    /// A reimplementation of `URLSession.shared.data(from: url)` required for Linux
    ///
    /// - Parameter url: The URL for which to load data.
    /// - Returns: Data and response.
    ///
    /// - Usage:
    ///
    ///     let (data, response) = try await URLSession.shared.asyncData(from: url)
    func asyncData(from url: URL) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    continuation.resume(throwing: URLSessionAsyncErrors.invalidUrlResponse)
                    return
                }
                guard let data = data else {
                    continuation.resume(throwing: URLSessionAsyncErrors.missingResponseData)
                    return
                }
                continuation.resume(returning: (data, response))
            }
            task.resume()
        }
    }
}
