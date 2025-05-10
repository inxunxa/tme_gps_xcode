import SwiftUI

struct LoaderView: View {
    let message: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.tmeDarkGray2)
                
                Text(message)
                    .font(.headline)
                    .foregroundColor(.accent)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.9))
            )
            .shadow(radius: 10)
        }
    }
}

#Preview {
    LoaderView(message: "Obteniendo Saldos del Servidor")
} 
