import Foundation

struct ShoppingShareItem: Equatable {
    let barcode: String
    let productName: String?
    let brand: String?
    let verdict: String?
    let checked: Bool
}

func formatShoppingListShareText(
    header: String,
    checkedSectionTitle: String,
    items: [ShoppingShareItem],
    verdictLabel: (VeganStatus) -> String
) -> String {
    func line(_ item: ShoppingShareItem, mark: String) -> String {
        let trimmedName = item.productName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let name = trimmedName.isEmpty ? item.barcode : (item.productName ?? item.barcode)
        let trimmedBrand = item.brand?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let brand = trimmedBrand.isEmpty ? "" : " (\(item.brand ?? ""))"
        let verdict = item.verdict.map { " · \(verdictLabel(VeganStatus(persisted: $0)))" } ?? ""
        return "\(mark) \(name)\(brand)\(verdict)"
    }

    let pending = items.filter { !$0.checked }
    let checked = items.filter(\.checked)
    var lines = [header, ""]
    lines += pending.map { line($0, mark: "☐") }
    if !checked.isEmpty {
        if !pending.isEmpty { lines.append("") }
        lines.append("\(checkedSectionTitle):")
        lines += checked.map { line($0, mark: "☑") }
    }
    return lines.joined(separator: "\n")
}
