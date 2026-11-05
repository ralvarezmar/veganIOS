import Foundation

let statsRecentWindow: TimeInterval = 30 * 24 * 60 * 60

struct ScanStatsInput: Equatable {
    let verdict: String?
    let category: String?
    let timestamp: Date
}

struct CategoryCount: Equatable {
    let category: ProductCategory
    let count: Int
}

struct ScanStats: Equatable {
    let total: Int
    let vegan: Int
    let notVegan: Int
    let maybe: Int
    let unknown: Int
    let lastThirtyDays: Int
    let topCategories: [CategoryCount]

    var veganPercent: Int? {
        let withVerdict = vegan + notVegan + maybe
        guard withVerdict > 0 else { return nil }
        return Int((Double(vegan) * 100 / Double(withVerdict)).rounded())
    }
}

func computeScanStats(_ entries: [ScanStatsInput], now: Date, topCategoryLimit: Int = 3) -> ScanStats {
    let verdicts = entries.map { VeganStatus(persisted: $0.verdict) }
    var categoryCounts: [ProductCategory: Int] = [:]
    for entry in entries {
        guard let raw = entry.category, let category = ProductCategory(rawValue: raw), category != .other else { continue }
        categoryCounts[category, default: 0] += 1
    }
    let order = ProductCategory.allCases
    let topCategories = categoryCounts
        .sorted { lhs, rhs in
            if lhs.value != rhs.value { return lhs.value > rhs.value }
            return (order.firstIndex(of: lhs.key) ?? 0) < (order.firstIndex(of: rhs.key) ?? 0)
        }
        .prefix(topCategoryLimit)
        .map { CategoryCount(category: $0.key, count: $0.value) }

    return ScanStats(
        total: entries.count,
        vegan: verdicts.filter { $0 == .vegan }.count,
        notVegan: verdicts.filter { $0 == .notVegan }.count,
        maybe: verdicts.filter { $0 == .maybe }.count,
        unknown: verdicts.filter { $0 == .unknown }.count,
        lastThirtyDays: entries.filter {
            let age = now.timeIntervalSince($0.timestamp)
            return age >= 0 && age <= statsRecentWindow
        }.count,
        topCategories: Array(topCategories)
    )
}
