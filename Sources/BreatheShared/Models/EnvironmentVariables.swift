import Foundation

public struct EnvironmentVariables {
    public static var shared: EnvironmentVariables = EnvironmentVariables(path: nil)

    public private(set) var dotEnv: DotEnv?
    public var path = "\(FileManager.default.currentDirectoryPath)/.env"

    private init(path: String?) {
        if let path {
            self.path = path
        }
    }

    mutating public func load() {
        self.dotEnv = DotEnv(fileAt: path)
    }

    public var purpleAirAPIKey: String {
        (dotEnv?.value("PA_API_KEY")!)!
    }

    public var geoAPIfyKey: String {
        (dotEnv?.value("GEO_API_KEY")!)!
    }
    
    public var airNowAPIKey: String {
        (dotEnv?.value("AIR_NOW_API_KEY")!)!
    }
    
    public var googleCloudAPIKey: String {
        (dotEnv?.value("GOOGLE_CLOUD_API_KEY")!)!
    }
}
