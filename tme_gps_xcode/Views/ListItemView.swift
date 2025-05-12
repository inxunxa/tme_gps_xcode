import SwiftUI

struct ListItemView: View {
    let caption: String
    let text: String
    let id: Int
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(caption)
                .font(.caption)
                .foregroundColor(.tmeDarkGray)
            
            Text(text)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .tag(id)
    }
}

#Preview {
    ListItemView( caption: "Num: 234", text: "Nombre del Ciente", id: 1)
}
