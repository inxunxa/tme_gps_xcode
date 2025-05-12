import SwiftUI
import MapKit

struct LocationRecordView: View {
    var selectedClient: Client?
    var selectedSucursal: Sucursal?
    @State private var showAlertMessage = false
    @State private var alertMessage = ""
    @State private var alertMessageType: MessageType = .error
    
    @StateObject private var locationManager = LocationManager()
    
    // computed prop
    var sucName: String {
        if let sucursal = selectedSucursal {
            return sucursal.nombre
        }
        return "Matriz"
    }
    
    var shortName: String {
        if let cl = selectedClient {
            if cl.razon.count > 10 {
                return String(cl.razon.prefix(10)) + "..."
            } else {
                return cl.razon
            }
        }
        
        return "Cliente"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                Backgrounds.gradientBottom.ignoresSafeArea()
                
                VStack(alignment:.leading) {
                    
                    VStack(alignment:.leading, spacing: 10, ) {
                                                
                        LabelView(
                            text: selectedClient?.razon ?? "No seleccionado",
                            label: "  Cliente:",
                            font: .headline
                        )
                        .padding(.leading, 5)
                        
                        LabelView(
                            text: sucName,
                            label: "  Sucursal:",
                            font: .subheadline
                        )
                        .padding(.leading, 5)
                        
                        HStack() {
                            Spacer()
                            
                            Button(action: {
                                saveLocation()
                            }) {
                                Text("Guardar ubicación actual")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding(3)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.top, 15)
                            
                            Spacer()
                        }
                        
                        
                    }
                    .padding()
                    
                    
                    if let coordinate = locationManager.lastKnownLocation {
                        Map{
                            Marker(shortName, coordinate: coordinate)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    else {
                        Text("Obteniendo ubicación...")
                    }
                    
                }
                .onAppear {
                    locationManager.checkLocationAuthorization()
                }
                
                // Error message overlay
                if showAlertMessage {
                    MessageView(
                        message: alertMessage,
                        type: alertMessageType,
                        onDismiss: { showAlertMessage = false }
                    )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Guardar Ubicación")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("logo1")
                }
            }
        }
        
    }
    
    func saveLocation() {
        Task {
            do {
                let response = try await DataService.saveLocation(
                    clientId: selectedClient?.id ?? 0,
                    sucursalId: selectedSucursal?.id ?? 0,
                    latitude: String(locationManager.lastKnownLocation?.latitude ?? 0),
                    longitude: String(locationManager.lastKnownLocation?.longitude ?? 0)
                )
                
                print("response: \(response)")
                
                // show the response in an alert
                if response == "OK" {
                    alertMessage = "Ubicación guardada con éxito."
                    alertMessageType = .success
                }
                else {
                    alertMessage = response
                    alertMessageType = .error
                }
                
            } catch {
                print("Error saving location: \(error)")
                alertMessage = error.localizedDescription
                alertMessageType = .error
            }
            
            showAlertMessage = true
        }
        
    }
    
}

#Preview {
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
    
    let sucursal = Sucursal(
        id: 152,
        idCliente: "6081",
        nombre: "REFORMA",
        cveVendedor: "TLA",
        actualizado: "/Date(1746837432207)/"
    )
    
    return LocationRecordView(selectedClient: client, selectedSucursal: sucursal)
}
