import SwiftUI

enum MessageType {
    case error
    case success
    
    var color: Color {
        switch self {
        case .error:
            return Color.red
        case .success:
            return Color.green
        }
    }
    
    var icon: String {
        switch self {
        case .error:
            return "exclamationmark.triangle.fill"
        case .success:
            return "checkmark.circle.fill"
        }
    }
}

struct MessageView: View {
    let message: String
    let type: MessageType
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: 20) {
                Image(systemName: type.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(type.color)
                
                Text(message)
                    .font(.headline)
                    .foregroundColor(.tmeDarkGray2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button {
                    onDismiss()
                } label: {
                    Text("Cerrar")
                        .font(.headline)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .foregroundColor(.tmeDarkGray)
                        .cornerRadius(8)
                }
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.9))
            )
            .shadow(radius: 10)
            .padding()
        }
    }
}

#Preview {
    MessageView(
        message: "Ha ocurrido un error al conectar con el servidor",
        type: .error,
        onDismiss: {}
    )
} 
