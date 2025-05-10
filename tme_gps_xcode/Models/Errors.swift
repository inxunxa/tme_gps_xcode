
enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingFailed
    case serverFailed
}
