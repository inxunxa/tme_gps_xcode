import SwiftUI
import SwiftData

struct ClientSelectView: View {
    @Environment(\.modelContext) private var modelContext
    @State var selectedVendedor: Vendedor?
    @State private var searchText = ""
    @State private var clients: [Client] = []
    @State private var selectedClient: Client?
    
    
    @Query private var allClients: [Client]
    
    private func fetchClients() {
        let descriptor: FetchDescriptor<Client>
        let vnd = selectedVendedor?.iniciales ?? ""
        
        if searchText.isEmpty {
            descriptor = FetchDescriptor<Client>(
                predicate: #Predicate<Client> { $0.cveVendedor == vnd },
                sortBy: [SortDescriptor(\.razon)]
            )
        } else if let searchId = Int(searchText) {
            descriptor = FetchDescriptor<Client>(
                predicate: #Predicate<Client> { $0.id == searchId && $0.cveVendedor == vnd },
                sortBy: [SortDescriptor(\.razon)]
            )
        } else {
            descriptor = FetchDescriptor<Client>(
                predicate: #Predicate<Client> {$0.cveVendedor == vnd && $0.razon.localizedStandardContains(searchText)  },
                sortBy: [SortDescriptor(\.razon)]
            )
        }
        
        // Perform fetch in Task to avoid UI blocking
        Task {
            let result = try? modelContext.fetch(descriptor)
            await MainActor.run {
                clients = result ?? []
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                Backgrounds.gradientBottom.ignoresSafeArea()
                
                VStack(spacing:0) {
                    
                    List(selection: $selectedClient) {
                        Section(header: Text("Clientes de: \(selectedVendedor?.nombre ?? "")")
                            .foregroundColor(.black)
                            .padding(.horizontal, -10)
                        ) {
                            ForEach(clients) { client in
                               NavigationLink(destination: 
                                   ClientNavigationDestination(
                                       selectedClient: client, 
                                       selectedVendedor: selectedVendedor
                                   )
                               ){
                                       ListItemView(
                                           caption: "Num: \(String(client.id))",
                                           text: client.razon,
                                           id: client.id
                                       )
                                   }                                                             
                            }
                        }
                        
                    }
                    .scrollContentBackground(.hidden)
                    .searchable(
                        text: $searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Buscar Cliente"
                    )
                    .onChange(of: searchText) { _, _ in
                        fetchClients()
                    }
                    .onAppear {
                        fetchClients()
                    }
                }
            }
            .navigationTitle("Seleccione Cliente")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("logo1")
                }
            }
            .onAppear {
                fetchClients()
            }
            
        }
    }
}

#Preview {
    let vnd = Vendedor(id: 1, iniciales: "TLA", nombre: "TAPIA ALGO ANDRES", correo: "juan@juan.com", password: "123456", almacenes: "1")
    
    let preview = PreviewContainer([Client.self])
    
    if let cls = DefaultsJSON.decode(from:"previewClients", type:[Client].self) {
        preview.add(items: cls)
    }
        
    return ClientSelectView(selectedVendedor: vnd)
            .modelContainer(preview.container)
}
