import Foundation

enum ListSortOrder: String, CaseIterable {
    case mostRecent
    case nameAscending
}

func filterAndSortItems<T>(
    _ items: [T],
    query: String,
    sortOrder: ListSortOrder,
    selectedVerdicts: Set<VeganStatus> = [],
    productName: (T) -> String?,
    brand: (T) -> String?,
    barcode: (T) -> String,
    timestamp: (T) -> Date,
    verdict: (T) -> VeganStatus? = { _ in nil }
) -> [T] {
    let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    let filtered = items.filter { item in
        let matchesQuery = normalizedQuery.isEmpty ||
            [productName(item), brand(item), barcode(item)]
                .compactMap { $0?.lowercased() }
                .contains { $0.contains(normalizedQuery) }
        let matchesVerdict = selectedVerdicts.isEmpty ||
            selectedVerdicts.contains(verdict(item) ?? .unknown)
        return matchesQuery && matchesVerdict
    }

    switch sortOrder {
    case .mostRecent:
        return filtered.sorted { timestamp($0) > timestamp($1) }
    case .nameAscending:
        return filtered.sorted {
            let lhs = (productName($0)?.isEmpty == false ? productName($0)! : barcode($0)).lowercased()
            let rhs = (productName($1)?.isEmpty == false ? productName($1)! : barcode($1)).lowercased()
            return lhs == rhs
                ? barcode($0).localizedCaseInsensitiveCompare(barcode($1)) == .orderedAscending
                : lhs.localizedCaseInsensitiveCompare(rhs) == .orderedAscending
        }
    }
}
