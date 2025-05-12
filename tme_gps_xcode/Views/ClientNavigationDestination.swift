import SwiftUI
import SwiftData

struct ClientNavigationDestination: View {
    @Environment(\.modelContext) private var modelContext
    var selectedClient: Client
    var selectedVendedor: Vendedor?
    @State private var sucursales: [Sucursal] = []
    @State private var isLoading = true
    
    private func fetchSucursales() {
        let clientId = String(selectedClient.id)
        let descriptor = FetchDescriptor<Sucursal>(
            predicate: #Predicate<Sucursal> { $0.idCliente == clientId },
            sortBy: [SortDescriptor(\.nombre)]
        )
        
        // Perform fetch in Task to avoid UI blocking
        Task {
            let result = try? modelContext.fetch(descriptor)
            await MainActor.run {
                sucursales = result ?? []
                isLoading = false
            }
        }
    }
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Cargando sucursales...")
            } else if sucursales.count > 1 {
                // If multiple sucursales, show the selection view
                SucursalSelectView(selectedClient: selectedClient, selectedVendedor: selectedVendedor)
            } else if sucursales.count == 1 {
                // If only one sucursal, go directly to record location with that sucursal
                LocationRecordView(selectedClient: selectedClient, selectedSucursal: sucursales.first)
            } else {
                // If no sucursales, go directly to record location with just the client
                LocationRecordView(selectedClient: selectedClient)
            }
        }
        .onAppear {
            fetchSucursales()
        }
    }
}

#Preview {
    let vnd = Vendedor(id: 1, iniciales: "TLA", nombre: "TAPIA ALGO ANDRES", correo: "juan@juan.com", password: "123456", almacenes: "1")
    
    let client = Client(
        id: 6081,
        razon: "MADERAS FINAS LOS PINOS",
        cveVendedor: "TLA",
        cveVendedor2: "",
        nombre: "LOS PINOS",
        estatus: "",
        precio1: 90,
        precio2: 25,
        precio3: 21,
        gps: "",
        credito: 2,
        autorizarDescuento: false,
        tipoCambio: 0,
        unaMoneda: false,
        moneda: "M",
        limiteCredito: 50000,
        prepago: false,
        limiteAtrasadoPermitido: "0",
        ciudad: "TIJUANA",
        actualizado: "/Date(1746837431357)/",
        regimen: true
    )
    
    let preview = PreviewContainer([Sucursal.self])
    if let sucs = DefaultsJSON.decode(from: "previewSucs", type: [Sucursal].self) {
        preview.add(items: sucs)
    }
    
    return ClientNavigationDestination(selectedClient: client, selectedVendedor: vnd)
        .modelContainer(preview.container)
}
