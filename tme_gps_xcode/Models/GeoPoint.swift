import Foundation

struct GeoPoint: Codable {
    let lat: Double
    let long: Double
    
    enum CodingKeys: String, CodingKey {
        case lat
        case long
    }
} 