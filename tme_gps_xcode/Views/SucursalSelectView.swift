import SwiftUI
import SwiftData

struct SucursalSelectView: View {
    @Environment(\.modelContext) private var modelContext
    @State var selectedClient: Client?
    @State var selectedVendedor: Vendedor?
    @State private var selectedSuc: Sucursal?
    @State private var clientSucursales: [Sucursal] = []
    
    private func fetchSucursales() {
        let clientId = String(selectedClient?.id ?? 0)
        let descriptor = FetchDescriptor<Sucursal> (
            predicate: #Predicate<Sucursal> { $0.idCliente == clientId },
            sortBy: [SortDescriptor(\.nombre)]
        )
                
        // Perform fetch in Task to avoid UI blocking
        Task {
            let result = try? modelContext.fetch(descriptor)
            await MainActor.run {
                clientSucursales = result ?? []
                print("loaded", clientSucursales)
            }
        }
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                // background
                Backgrounds.gradientBottom.ignoresSafeArea()
                
                List(selection: $selectedSuc) {
                    Section(header:Text("Sucursales de: \(selectedClient?.razon ?? "")")
                        .foregroundColor(.black)
                        .padding(.horizontal, -10)
                        .lineLimit(1)
                    ) {
                        ForEach(clientSucursales) { suc in
                            NavigationLink(suc.nombre, destination: 
                                LocationRecordView(selectedClient: selectedClient, selectedSucursal: suc)
                                    .navigationTitle("Registrar Ubicación")
                            )
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .onAppear {
                    fetchSucursales()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Seleccione Sucursal")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("logo1")
                }
            }
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
    
    return SucursalSelectView(selectedClient:client, selectedVendedor: vnd)
        .modelContainer(preview.container)
}
