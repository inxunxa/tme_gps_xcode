import Foundation

struct Http {
    /// Decodes an API response wrapped in a "d" object.
    ///
    /// - Parameters:
    ///   - data: The raw JSON data returned by the API.
    ///   - type: The expected type of the decoded object.
    /// - Returns: The decoded object of the specified type.
    /// - Throws: An error if decoding fails.
    static func decode<T: Decodable>(_ data: Data, to type: T.Type) throws -> T {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            
            // Decode the generic APIResponse
            let wrappedResponse = try decoder.decode(APIResponse<T>.self, from: data)
            
            // Extract and return the actual payload
            return wrappedResponse.d
        } catch {
            print("Decoding failed for type: \(type)")
            print("Error: \(error.localizedDescription)")
            print("Full error details: \(error)") // Prints the complete error object
            throw APIError.decodingFailed
        }
    }
    
    static func sendPostRequest(payload: [String: Any]? = nil, to endpoint: String, expectedStatus:Int = 200) async throws -> (Data, URLResponse) {
        
        let domain = "http://toolsdemexico.net/cotizaciones/serviceJson.asmx" + endpoint
        
        guard let url = URL(string: domain) else { throw APIError.invalidURL }
        
        // Create a URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // Set the HTTP method to POST

        // Set the Content-Type header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Serialize the payload into JSON if it exists
        if let payload = payload {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        }

        // Use URLSession to send the request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode != expectedStatus {
            // Log the status code and server response
            print("Unexpected status code: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("Server response: \(responseString)")
            } else {
                print("Unable to decode server response.")
            }
            throw APIError.invalidResponse
        }

        return (data, response)
    }
}


struct APIResponse<T: Decodable>: Decodable {
    let d: T
}
