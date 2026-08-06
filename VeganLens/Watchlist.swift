import Foundation

struct WatchlistMatches: Equatable {
    let additives: [String]
    let ingredientKeywords: [String]

    var isEmpty: Bool {
        additives.isEmpty && ingredientKeywords.isEmpty
    }
}

enum WatchlistPreferences {
    static let additivesKey = "watched_additives"
    static let ingredientKeywordsKey = "watched_ingredient_keywords"

    static func decode(_ storage: String) -> [String] {
        storage
            .split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    static func encode(_ values: [String]) -> String {
        values
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .orderedUnique()
            .joined(separator: "\n")
    }
}

func normalizeWatchedAdditive(_ raw: String) -> String {
    let withoutPrefix = raw
        .split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
        .last
        .map(String.init) ?? raw
    return withoutPrefix
        .uppercased()
        .filter { !$0.isWhitespace && $0 != "-" && $0 != "_" }
}

func normalizeWatchedKeyword(_ raw: String) -> String {
    raw.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
        .trimmingCharacters(in: .whitespacesAndNewlines)
}

func watchlistMatches(
    product: Product,
    watchedAdditives: [String],
    watchedKeywords: [String]
) -> WatchlistMatches {
    let normalizedWatchedAdditives = watchedAdditives
        .map(normalizeWatchedAdditive)
        .filter { !$0.isEmpty }

    let additiveMatches = (product.additivesTags ?? [])
        .map(normalizeWatchedAdditive)
        .filter { normalizedWatchedAdditives.contains($0) }
        .orderedUnique()

    let ingredientsText = normalizeWatchedKeyword(product.ingredientsText ?? "")
    let keywordMatches = watchedKeywords
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty && ingredientsText.contains(normalizeWatchedKeyword($0)) }
        .orderedUnique()

    return WatchlistMatches(
        additives: additiveMatches,
        ingredientKeywords: keywordMatches
    )
}

private extension Array where Element == String {
    func orderedUnique() -> [String] {
        var seen = Set<String>()
        return filter { seen.insert($0).inserted }
    }
}
