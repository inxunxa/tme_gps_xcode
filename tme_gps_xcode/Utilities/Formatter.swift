import Foundation

struct Formatter {
    static func currency(_ amount: Double, currencyCode: String = "USD") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencySymbol = "$"
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
    
    static func format2Decs(_ value: Double) -> String {
        return String(format: "%.2f", value)
    }
}
