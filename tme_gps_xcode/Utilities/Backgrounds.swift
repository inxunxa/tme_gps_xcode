import SwiftUICore

struct Backgrounds {
    static var gradientBottom = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "#2F4E67"),
            Color(hex: "#3E627C"),
            Color(hex: "#4D7792"),
            Color(hex: "#5D8DA8"),
            Color(hex: "#7da3b9"),
            
            Color(hex: "#9dbaca"),
            Color(hex: "#bed1dc"),
            
            Color(hex: "#e1ecf2")
        ]),
        startPoint: .bottom,  // "to top" in CSS becomes .bottom to .top in SwiftUI
        endPoint: .top
    )
    
    static var gradientFull = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "#2F4E67"),
            Color(hex: "#3E627C"),
            Color(hex: "#4D7792"),
            Color(hex: "#5D8DA8"),
            Color(hex: "#6DA3BE")
        ]),
        startPoint: .bottom,  // "to top" in CSS becomes .bottom to .top in SwiftUI
        endPoint: .top
    )
}
