import Foundation

func buildShareText(
    headline: String,
    productName: String?,
    brand: String?,
    barcode: String,
    footer: String
) -> String {
    let name = productName?.trimmingCharacters(in: .whitespacesAndNewlines)
    let cleanBrand = brand?.trimmingCharacters(in: .whitespacesAndNewlines)
    let firstLine: String
    if let name, !name.isEmpty {
        firstLine = cleanBrand.flatMap { $0.isEmpty ? nil : "\(headline) — \(name) · \($0)" }
            ?? "\(headline) — \(name)"
    } else {
        firstLine = headline
    }
    return "\(firstLine)\n\(barcode)\n\(footer)"
}

func verdictAccessibilityText(
    headline: String,
    subtitle: String,
    explanation: String?
) -> String {
    [headline, subtitle, explanation?.isEmpty == false ? explanation : nil]
        .compactMap { $0 }
        .joined(separator: ". ")
}
