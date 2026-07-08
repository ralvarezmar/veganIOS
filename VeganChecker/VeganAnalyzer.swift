import Foundation

enum VeganStatus {
    case vegan
    case notVegan
    case maybe
    case unknown
}

struct VeganAnalysis {
    let status: VeganStatus
    let nonVeganIngredients: [String]
    let doubtfulIngredients: [String]
}

func analyzeVegan(_ product: Product) -> VeganAnalysis {
    analyzeVegan(ingredientsAnalysisTags: product.ingredientsAnalysisTags, ingredients: product.ingredients)
}

func analyzeVegan(ingredientsAnalysisTags: [String]?, ingredients: [OffIngredient]?) -> VeganAnalysis {
    let ingredientList = ingredients ?? []
    let normalizedIngredients = ingredientList.compactMap { ingredient -> (String, String)? in
        guard let vegan = ingredient.vegan?.lowercased(), let cleanedText = cleanFoodFactsLabel(ingredient.text) else {
            return nil
        }
        return (vegan, cleanedText)
    }

    let nonVegan = normalizedIngredients
        .filter { $0.0 == "no" }
        .map { $0.1 }
        .orderedUnique()

    let doubtful = normalizedIngredients
        .filter { $0.0 == "maybe" }
        .map { $0.1 }
        .orderedUnique()

    let hasYesIngredient = normalizedIngredients.contains { $0.0 == "yes" }
    let hasIngredients = !(ingredients?.isEmpty ?? true)
    let hasTags = !(ingredientsAnalysisTags?.isEmpty ?? true)

    let decisiveStatus: VeganStatus? = {
        guard let tags = ingredientsAnalysisTags else { return nil }
        if tags.contains("en:non-vegan") { return .notVegan }
        if tags.contains("en:maybe-vegan") { return .maybe }
        if tags.contains("en:vegan") { return .vegan }
        return nil
    }()

    let status = decisiveStatus ?? {
        if !nonVegan.isEmpty { return .notVegan }
        if !doubtful.isEmpty { return .maybe }
        if hasYesIngredient { return .vegan }
        if !hasIngredients && !hasTags { return .unknown }
        return .unknown
    }()

    return VeganAnalysis(status: status, nonVeganIngredients: nonVegan, doubtfulIngredients: doubtful)
}

func cleanFoodFactsLabel(_ raw: String?) -> String? {
    guard let raw = raw?.trimmingCharacters(in: .whitespacesAndNewlines), !raw.isEmpty else {
        return nil
    }

    let decoded = htmlDecoded(raw).trimmingCharacters(in: .whitespacesAndNewlines)
    guard !decoded.isEmpty else { return nil }

    var normalized = decoded
    if let colonIndex = normalized.firstIndex(of: ":") {
        normalized = String(normalized[normalized.index(after: colonIndex)...])
    }

    normalized = normalized
        .replacingOccurrences(of: "_", with: "")
        .replacingOccurrences(of: "*", with: "")
        .map { $0.isWhitespace ? " " : String($0) }
        .joined()
        .replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines.union(CharacterSet(charactersIn: ".,;:\"'“”‘’«»()[]{}!?")))

    guard !normalized.isEmpty else { return nil }

    return normalized
        .split(whereSeparator: { $0.isWhitespace })
        .map { $0.lowercased().capitalized }
        .joined(separator: " ")
}

private func htmlDecoded(_ raw: String) -> String {
    guard raw.contains("&") else { return raw }

    let entities: [(String, String)] = [
        ("&nbsp;", " "),
        ("&quot;", "\""),
        ("&apos;", "'"),
        ("&#39;", "'"),
        ("&lt;", "<"),
        ("&gt;", ">"),
        ("&amp;", "&")
    ]

    var result = raw
    for (entity, replacement) in entities {
        result = result.replacingOccurrences(of: entity, with: replacement)
    }
    return result
}

private extension Array where Element == String {
    func orderedUnique() -> [String] {
        var seen = Set<String>()
        return filter { seen.insert($0).inserted }
    }
}

private extension Optional where Wrapped == [String] {
    var orEmpty: [String] {
        self ?? []
    }
}

private extension Optional where Wrapped == [OffIngredient] {
    var orEmpty: [OffIngredient] {
        self ?? []
    }
}
