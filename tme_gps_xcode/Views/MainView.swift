import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var loading = false
    @State private var selectedVnd: Vendedor?
    @Query private var vendedores : [Vendedor]

    // computer property
    private var sortedData: [Vendedor] {
        return vendedores.sorted { $0.nombre < $1.nombre }
    }
    
    var body: some View {
        NavigationSplitView {
            ZStack {
                // Background gradient
                Backgrounds.gradientFull.ignoresSafeArea()
                
                
                if loading {
                    LoaderView(message: "Obteniendo Datos...")
                }
                
                List(selection: $selectedVnd) {
                    Section(header:
                                Text("Seleccione Vendedor para iniciar")
                        .foregroundColor(.black)
                        .padding(.horizontal, -10)
                    ) {
                        ForEach(sortedData) { vnd in
                            Text(vnd.nombre)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .toolbar() {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image(.logo1)
                    }
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text("Registrar GPS")
                                .font(.title2)
                                .padding(.top, 4)
                                .foregroundColor(.black)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: updateData) {
                            Label("Actualizar", systemImage: "arrow.clockwise")
                        }
                        .foregroundColor(.black)
                    }
                }
                
            }
                                    
        } detail: {
            if let selectedVnd = selectedVnd {
                ClientSelectView(selectedVendedor: $selectedVnd)
            } else {
                Text("Seleccione un vendedor para continuar")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private func updateData() {
        Task {
            do {
                loading = true
                
                /////////////////////////// VENDEDORES
                let apiVnds = try await DataService.getVendedores()
                if apiVnds.count > 0 {
                    // Delete all existing vendedores
                    for vnd in vendedores {
                        modelContext.delete(vnd)
                    }
                    try modelContext.save()
                }
                // save vendedores
                for vnd in apiVnds {
                    modelContext.insert(vnd)
                }
                try modelContext.save()
                
                
                /////////////////////////// CLIENTES
                let apiCls = try await DataService.getClients()
                if apiCls.count > 0 {
                    // retrieve existing clients
                    let existingClients = try modelContext.fetch(FetchDescriptor<Client>())
                    for cl in existingClients {
                        modelContext.delete(cl)
                    }
                    try modelContext.save()
                }
                // Save clientes
                for cl in apiCls {
                    modelContext.insert(cl)
                }
                try modelContext.save()
                
                /////////////////////////// Sucursales
                let apiSucs = try await DataService.getSucursales()
                if apiSucs.count > 0 {
                    //clear all existing sucs
                    let existingSucs = try modelContext.fetch(FetchDescriptor<Sucursal>())
                    for suc in existingSucs {
                        modelContext.delete(suc)
                    }
                    try modelContext.save()
                    // save Sucursales
                    for suc in apiSucs {
                        modelContext.insert(suc)
                    }
                    try modelContext.save()
                }
            
                
                
                print("Data updated successfully!")
                
                loading = false
                
            } catch {
                loading = false
                print("Error Updating Data: \(error)")
                
            }
        }
    }

}

#Preview {
    MainView()
        .modelContainer(for: Vendedor.self, inMemory: false)
}
