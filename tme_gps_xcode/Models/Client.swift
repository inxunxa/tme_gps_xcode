import Foundation
import SwiftData

@Model
final class Client: Identifiable, Decodable, Sendable {
    // Properties
    var id: Int
    var razon: String
    var cveVendedor: String
    var cveVendedor2: String
    var nombre: String
    var estatus: String
    var precio1: Int
    var precio2: Int
    var precio3: Int
    var gps: String
    var credito: Double
    var autorizarDescuento: Bool
    var tipoCambio: Double
    var unaMoneda: Bool
    var moneda: String
    var limiteCredito: Double
    var prepago: Bool
    var limiteAtrasadoPermitido: String
    var ciudad: String
    var actualizado: String
    var regimen: Bool
    
    // Initializer for SwiftData
    init(id: Int, razon: String, cveVendedor: String, cveVendedor2: String, nombre: String, estatus: String, precio1: Int, precio2: Int, precio3: Int, gps: String, credito: Double, autorizarDescuento: Bool, tipoCambio: Double, unaMoneda: Bool, moneda: String, limiteCredito: Double, prepago: Bool, limiteAtrasadoPermitido: String, ciudad: String, actualizado: String, regimen: Bool) {
        self.id = id
        self.razon = razon
        self.cveVendedor = cveVendedor
        self.cveVendedor2 = cveVendedor2
        self.nombre = nombre
        self.estatus = estatus
        self.precio1 = precio1
        self.precio2 = precio2
        self.precio3 = precio3
        self.gps = gps
        self.credito = credito
        self.autorizarDescuento = autorizarDescuento
        self.tipoCambio = tipoCambio
        self.unaMoneda = unaMoneda
        self.moneda = moneda
        self.limiteCredito = limiteCredito
        self.prepago = prepago
        self.limiteAtrasadoPermitido = limiteAtrasadoPermitido
        self.ciudad = ciudad
        self.actualizado = actualizado
        self.regimen = regimen
    }
    
    // Custom Decoding (if API JSON keys differ)
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.razon = try container.decode(String.self, forKey: .razon)
        self.cveVendedor = try container.decode(String.self, forKey: .cveVendedor)
        self.cveVendedor2 = try container.decode(String.self, forKey: .cveVendedor2)
        self.nombre = try container.decode(String.self, forKey: .nombre)
        self.estatus = try container.decode(String.self, forKey: .estatus)
        self.precio1 = try container.decode(Int.self, forKey: .precio1)
        self.precio2 = try container.decode(Int.self, forKey: .precio2)
        self.precio3 = try container.decode(Int.self, forKey: .precio3)
        self.gps = try container.decode(String.self, forKey: .gps)
        self.credito = try container.decode(Double.self, forKey: .credito)
        self.autorizarDescuento = try container.decode(Bool.self, forKey: .autorizarDescuento)
        self.tipoCambio = try container.decode(Double.self, forKey: .tipoCambio)
        self.unaMoneda = try container.decode(Bool.self, forKey: .unaMoneda)
        self.moneda = try container.decode(String.self, forKey: .moneda)
        self.limiteCredito = try container.decode(Double.self, forKey: .limiteCredito)
        self.prepago = try container.decode(Bool.self, forKey: .prepago)
        self.limiteAtrasadoPermitido = try container.decode(String.self, forKey: .limiteAtrasadoPermitido)
        self.ciudad = try container.decode(String.self, forKey: .ciudad)
        self.actualizado = try container.decode(String.self, forKey: .actualizado)
        self.regimen = try container.decode(Bool.self, forKey: .regimen)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, razon, cveVendedor, cveVendedor2, nombre, estatus
        case precio1, precio2, precio3, gps, credito, autorizarDescuento
        case tipoCambio, unaMoneda, moneda, limiteCredito, prepago
        case limiteAtrasadoPermitido, ciudad, actualizado, regimen
    }
    
    static func createOrUpdate(apiClient: Client, in context: ModelContext) {
        do {
            // Create a FetchDescriptor with a predicate to filter by id
            let checkId = apiClient.id
            let fetchDescriptor = FetchDescriptor<Client>(
                predicate: #Predicate { client in client.id == checkId }
            )

            // Fetch an existing client using the descriptor
            if let existingClient = try context.fetch(fetchDescriptor).first {
                // Update the existing client
                existingClient.update(with: apiClient)
            } else {
                // Insert a new client
                let newClient = Client(
                    id: apiClient.id,
                    razon: apiClient.razon,
                    cveVendedor: apiClient.cveVendedor,
                    cveVendedor2: apiClient.cveVendedor2,
                    nombre: apiClient.nombre,
                    estatus: apiClient.estatus,
                    precio1: apiClient.precio1,
                    precio2: apiClient.precio2,
                    precio3: apiClient.precio3,
                    gps: apiClient.gps,
                    credito: apiClient.credito,
                    autorizarDescuento: apiClient.autorizarDescuento,
                    tipoCambio: apiClient.tipoCambio,
                    unaMoneda: apiClient.unaMoneda,
                    moneda: apiClient.moneda,
                    limiteCredito: apiClient.limiteCredito,
                    prepago: apiClient.prepago,
                    limiteAtrasadoPermitido: apiClient.limiteAtrasadoPermitido,
                    ciudad: apiClient.ciudad,
                    actualizado: apiClient.actualizado,
                    regimen: apiClient.regimen
                )
                context.insert(newClient)
            }
        } catch {
            print("Failed to fetch or create/update client: \(error)")
        }
    }
    
    func update(with apiClient: Client) {
        self.razon = apiClient.razon
        self.cveVendedor = apiClient.cveVendedor
        self.cveVendedor2 = apiClient.cveVendedor2
        self.nombre = apiClient.nombre
        self.estatus = apiClient.estatus
        self.precio1 = apiClient.precio1
        self.precio2 = apiClient.precio2
        self.precio3 = apiClient.precio3
        self.gps = apiClient.gps
        self.credito = apiClient.credito
        self.autorizarDescuento = apiClient.autorizarDescuento
        self.tipoCambio = apiClient.tipoCambio
        self.unaMoneda = apiClient.unaMoneda
        self.moneda = apiClient.moneda
        self.limiteCredito = apiClient.limiteCredito
        self.prepago = apiClient.prepago
        self.limiteAtrasadoPermitido = apiClient.limiteAtrasadoPermitido
        self.ciudad = apiClient.ciudad
        self.actualizado = apiClient.actualizado
        self.regimen = apiClient.regimen
    }
}
