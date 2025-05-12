import Foundation

struct DataService {
    
    static func getClients() async throws -> [Client] {
        
        let (data, _) = try await Http.sendPostRequest(to: "/GetAllClientes")
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            return try  Http.decode(data, to: [Client].self)
        }
        catch {
            throw APIError.invalidData
        }
    }

    static func getVendedores() async throws -> [Vendedor] {
        let (data, _) = try await Http.sendPostRequest(to: "/GetVendedores")
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            return try Http.decode(data, to: [Vendedor].self)
        }
        catch {
            throw APIError.invalidData
        }
    }
    
    static func getSucursales() async throws -> [Sucursal] {
        let (data, _) = try await Http.sendPostRequest(to: "/GetAllSucursales")
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            return try Http.decode(data, to: [Sucursal].self)
        }
        catch {
            throw APIError.invalidData
        }
    }
    
    static func saveLocation(clientId: Int, sucursalId: Int, latitude: String, longitude: String) async throws -> String {
        let (data, _) = try await Http.sendPostRequest(
            payload:["clientId":clientId, "sucursalId":sucursalId, "latitud":latitude, "longitud":longitude],
            to: "/SaveClientLocation"
        )
        
        print(data)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            return try Http.decode(data, to: String.self)
        }
        catch {
            throw APIError.invalidData
        }
                
    }
    
}
