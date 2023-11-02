import XCTest
@testable import BreatheShared

final class BreatheSharedTests: XCTestCase {
    
    override func setUp() async throws {
        print(ProcessInfo.processInfo.environment)
        
        if ProcessInfo.processInfo.environment["CI"] == nil {
            EnvironmentVariables.shared.load()
        }
    }
    
//    func testPurpleAirSensors() async throws {
//        let sensors = try! await PurpleAirAPI.shared.sensors()
//        XCTAssertFalse(sensors.isEmpty)
//    }
//    
//    func testPurpleAirSensorData() async throws {
//        let sensor = try! await PurpleAirAPI.shared.sensorData(id: 109366)
//    }
//    
//    func testSensorAverages() async throws {
//        let sensorAverages = try! await PurpleAirAPI.shared.sensorAverages(forSensor: 44049)
//    }
//    
//    func testWildfires() async throws {
//        let wildfires = try! await WildfireAPI.shared.wildfireIncidents()
//        XCTAssertFalse(wildfires.isEmpty)
//    }
//    
//    func testAirNowAPI() async throws {
//        let networkDataStations = try! await AirNowAPI.shared.dataStations()
//        XCTAssertFalse(networkDataStations.isEmpty)
//        
//        let data = try JSONEncoder().encode(networkDataStations)
//        let decodedDataStations = try JSONDecoder().decode([AirNowStation].self, from: data)
//        XCTAssertTrue(networkDataStations == decodedDataStations)
//    }

    func testEnvironmentVariables() {
        if ProcessInfo.processInfo.environment["GITHUB_ACTION"] == nil {
            [
                EnvironmentVariables.shared.purpleAirAPIKey,
                EnvironmentVariables.shared.geoAPIfyKey
            ].forEach { XCTAssertFalse($0.isEmpty) }
        }
    }
}
