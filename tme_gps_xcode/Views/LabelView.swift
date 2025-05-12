import SwiftUI

struct LabelView: View {
    var text: String
    var label: String
    var font: Font? = .subheadline
    var fontWeight: Font.Weight? = .regular
    
    var body: some View {
        HStack {
            Text(label)
                .font(font ?? .callout)
                .fontWeight(.light)
                .lineLimit(1)
    
            Text(text)
                .font(font ?? .callout)
//                .foregroundStyle(.tmePrimary)
                .lineLimit(1)
        }
    }
}

#Preview("normal") {
    LabelView(
        text: "NPMBRE AQUI", label: "Sucursal:"
    )
}


#Preview("bold") {
    LabelView(
        text: "NPMBRE AQUI", label: "Cliente:", font: .headline
    )
}
