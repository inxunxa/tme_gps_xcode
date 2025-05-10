import SwiftUI
import SwiftData

struct ClientSelectView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var clients: [Client] = []
    @State private var selectedClient: Client?
    @Binding var selectedVendedor: Vendedor?
    
    private func fetchClients() {
        let descriptor: FetchDescriptor<Client>
        
        if searchText.isEmpty {
            descriptor = FetchDescriptor<Client>(
                sortBy: [SortDescriptor(\.razon)]
            )
        } else if let searchId = Int(searchText) {
            descriptor = FetchDescriptor<Client>(
                predicate: #Predicate<Client> { $0.id == searchId },
                sortBy: [SortDescriptor(\.razon)]
            )
        } else {
            descriptor = FetchDescriptor<Client>(
                predicate: #Predicate<Client> { $0.razon.localizedStandardContains(searchText) },
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
        ZStack {
            // Background gradient
            Backgrounds.gradientBottom.ignoresSafeArea()
            
            VStack {
                Text("Vendedor: \(selectedVendedor?.nombre ?? "")")
                    .font(.headline)
                    .padding(.top)
                
                List(clients, selection: $selectedClient) { client in
                    Text("\(String(client.id)) - \(client.razon)")
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .tag(client)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Buscar Cliente")
                .keyboardType(.numberPad)
                .onChange(of: searchText) { _, _ in
                    fetchClients()
                }
            }
        }
        .navigationTitle("Seleccione Cliente")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(.logo1)
            }
        }
        .onAppear {
            fetchClients()
        }
    }
}

#Preview {
    let vnd = Vendedor(id: 1, iniciales: "AA", nombre: "Juan", correo: "juan@juan.com", password: "123456", almacenes: "1")
    ClientSelectView(selectedVendedor: .constant(vnd))
        .modelContainer(for: Client.self, inMemory: false)
    
}
