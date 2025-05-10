import Foundation
import SwiftData

@Model
final class Vendedor: Identifiable, Decodable, Sendable {
    // Properties
    var id: Int
    var iniciales: String
    var nombre: String
    var correo: String
    var password: String
    var almacenes: String
    
    // Initializer for SwiftData
    init(id: Int, iniciales: String, nombre: String, correo: String, password: String, almacenes: String) {
        self.id = id
        self.iniciales = iniciales
        self.nombre = nombre
        self.correo = correo
        self.password = password
        self.almacenes = almacenes
    }
    
    // Custom Decoding
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.iniciales = try container.decode(String.self, forKey: .iniciales)
        self.nombre = try container.decode(String.self, forKey: .nombre)
        self.correo = try container.decode(String.self, forKey: .correo)
        self.password = try container.decode(String.self, forKey: .password)
        self.almacenes = try container.decode(String.self, forKey: .almacenes)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, iniciales, nombre, correo, password, almacenes
    }
    
    static func createOrUpdate(apiVendedor: Vendedor, in context: ModelContext) {
        do {
            // Create a FetchDescriptor with a predicate to filter by id
            let checkId = apiVendedor.id
            let fetchDescriptor = FetchDescriptor<Vendedor>(
                predicate: #Predicate { vendedor in vendedor.id == checkId }
            )

            // Fetch an existing vendedor using the descriptor
            if let existingVendedor = try context.fetch(fetchDescriptor).first {
                // Update the existing vendedor
                existingVendedor.update(with: apiVendedor)
            } else {
                // Insert a new vendedor
                let newVendedor = Vendedor(
                    id: apiVendedor.id,
                    iniciales: apiVendedor.iniciales,
                    nombre: apiVendedor.nombre,
                    correo: apiVendedor.correo,
                    password: apiVendedor.password,
                    almacenes: apiVendedor.almacenes
                )
                context.insert(newVendedor)
            }
        } catch {
            print("Failed to fetch or create/update vendedor: \(error)")
        }
    }
    
    func update(with apiVendedor: Vendedor) {
        self.iniciales = apiVendedor.iniciales
        self.nombre = apiVendedor.nombre
        self.correo = apiVendedor.correo
        self.password = apiVendedor.password
        self.almacenes = apiVendedor.almacenes
    }
} 