import Foundation
import SwiftData

@Model
final class Sucursal: Identifiable, Decodable, Sendable {
    // Properties
    var id: Int
    var idCliente: String
    var nombre: String
    var cveVendedor: String
    var actualizado: String
    
    // Initializer for SwiftData
    init(id: Int, idCliente: String, nombre: String, cveVendedor: String, actualizado: String) {
        self.id = id
        self.idCliente = idCliente
        self.nombre = nombre
        self.cveVendedor = cveVendedor
        self.actualizado = actualizado
    }
    
    // Custom Decoding (if API JSON keys differ)
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.idCliente = try container.decode(String.self, forKey: .idCliente)
        self.nombre = try container.decode(String.self, forKey: .nombre)
        self.cveVendedor = try container.decode(String.self, forKey: .cveVendedor)
        self.actualizado = try container.decode(String.self, forKey: .actualizado)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case idCliente = "id_cliente"
        case nombre
        case cveVendedor
        case actualizado
    }
    
    static func createOrUpdate(apiSucursal: Sucursal, in context: ModelContext) {
        do {
            // Create a FetchDescriptor with a predicate to filter by id
            let checkId = apiSucursal.id
            let fetchDescriptor = FetchDescriptor<Sucursal>(
                predicate: #Predicate { sucursal in sucursal.id == checkId }
            )

            // Fetch an existing sucursal using the descriptor
            if let existingSucursal = try context.fetch(fetchDescriptor).first {
                // Update the existing sucursal
                existingSucursal.update(with: apiSucursal)
            } else {
                // Insert a new sucursal
                let newSucursal = Sucursal(
                    id: apiSucursal.id,
                    idCliente: apiSucursal.idCliente,
                    nombre: apiSucursal.nombre,
                    cveVendedor: apiSucursal.cveVendedor,
                    actualizado: apiSucursal.actualizado
                )
                context.insert(newSucursal)
            }
        } catch {
            print("Failed to fetch or create/update sucursal: \(error)")
        }
    }
    
    func update(with apiSucursal: Sucursal) {
        self.idCliente = apiSucursal.idCliente
        self.nombre = apiSucursal.nombre
        self.cveVendedor = apiSucursal.cveVendedor
        self.actualizado = apiSucursal.actualizado
    }
} 