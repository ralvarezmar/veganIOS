import Foundation

enum VeganStatus: Equatable {
    case vegan
    case notVegan
    case maybe
    case unknown
}

enum VeganReasonSource: Equatable {
    case structuredNonVeganIngredient
    case structuredDoubtfulIngredient
    case structuredVeganIngredient
    case decisiveTag
    case heuristicText
    case veganSeal
    case meatAlternativeCategory
}

struct VeganReason: Equatable {
    let source: VeganReasonSource
    let evidence: [String]

    init(source: VeganReasonSource, evidence: [String] = []) {
        self.source = source
        self.evidence = evidence
    }
}

struct VeganAnalysis {
    let status: VeganStatus
    let nonVeganIngredients: [String]
    let doubtfulIngredients: [String]
    let heuristic: Bool
    let reason: VeganReason?

    init(
        status: VeganStatus,
        nonVeganIngredients: [String],
        doubtfulIngredients: [String],
        heuristic: Bool = false,
        reason: VeganReason? = nil
    ) {
        self.status = status
        self.nonVeganIngredients = nonVeganIngredients
        self.doubtfulIngredients = doubtfulIngredients
        self.heuristic = heuristic
        self.reason = reason
    }
}

func analyzeVegan(_ product: Product) -> VeganAnalysis {
    analyzeVegan(
        ingredientsAnalysisTags: product.ingredientsAnalysisTags,
        ingredients: product.ingredients,
        ingredientsText: product.ingredientsText,
        categoriesTags: product.categoriesTags,
        labelsTags: product.labelsTags
    )
}

func analyzeVegan(
    ingredientsAnalysisTags: [String]?,
    ingredients: [OffIngredient]?,
    ingredientsText: String? = nil,
    categoriesTags: [String]? = nil,
    labelsTags: [String]? = nil
) -> VeganAnalysis {
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

    let decisiveTag: String? = {
        guard let tags = ingredientsAnalysisTags else { return nil }
        if tags.contains("en:non-vegan") { return "en:non-vegan" }
        if tags.contains("en:maybe-vegan") { return "en:maybe-vegan" }
        if tags.contains("en:vegan") { return "en:vegan" }
        return nil
    }()

    let decisiveStatus: VeganStatus? = {
        switch decisiveTag {
        case "en:non-vegan": return .notVegan
        case "en:maybe-vegan": return .maybe
        case "en:vegan": return .vegan
        default: return nil
        }
    }()

    let status = decisiveStatus ?? {
        if !nonVegan.isEmpty { return .notVegan }
        if !doubtful.isEmpty { return .maybe }
        if hasYesIngredient { return .vegan }
        if !hasIngredients && !hasTags { return .unknown }
        return .unknown
    }()

    let reason: VeganReason? = {
        if let decisiveTag {
            return VeganReason(source: .decisiveTag, evidence: [decisiveTag])
        }
        if !nonVegan.isEmpty {
            return VeganReason(source: .structuredNonVeganIngredient, evidence: nonVegan)
        }
        if !doubtful.isEmpty {
            return VeganReason(source: .structuredDoubtfulIngredient, evidence: doubtful)
        }
        if hasYesIngredient {
            return VeganReason(
                source: .structuredVeganIngredient,
                evidence: normalizedIngredients.filter { $0.0 == "yes" }.map { $0.1 }
            )
        }
        return nil
    }()

    let finalStatus: VeganStatus
    let finalReason: VeganReason?
    if status == .notVegan {
        finalStatus = .notVegan
        finalReason = reason
    } else if labelsTags?.contains(where: isVeganSealTag) == true {
        finalStatus = .vegan
        finalReason = VeganReason(
            source: .veganSeal,
            evidence: Array(labelsTags?.filter(isVeganSealTag).prefix(1) ?? [])
        )
    } else if status == .unknown, categoriesTags?.contains(where: isMeatAlternativeCategoryTag) == true {
        finalStatus = .vegan
        finalReason = VeganReason(
            source: .meatAlternativeCategory,
            evidence: Array(categoriesTags?.filter(isMeatAlternativeCategoryTag).prefix(1) ?? [])
        )
    } else {
        finalStatus = status
        finalReason = reason
    }

    if finalStatus == .unknown, let ingredientsText, !ingredientsText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        let detected = detectAnimalIngredients(ingredientsText)
        if !detected.isEmpty {
            return VeganAnalysis(
                status: .notVegan,
                nonVeganIngredients: detected,
                doubtfulIngredients: [],
                heuristic: true,
                reason: VeganReason(source: .heuristicText, evidence: detected)
            )
        }
        return VeganAnalysis(
            status: .maybe,
            nonVeganIngredients: [],
            doubtfulIngredients: [],
            heuristic: true,
            reason: VeganReason(source: .heuristicText)
        )
    }

    return VeganAnalysis(
        status: finalStatus,
        nonVeganIngredients: nonVegan,
        doubtfulIngredients: doubtful,
        reason: finalReason
    )
}

private func isMeatAlternativeCategoryTag(_ tag: String) -> Bool {
    let normalizedTag = tag.lowercased().split(separator: ":", maxSplits: 1).last.map(String.init) ?? tag.lowercased()
    let englishMarkers = ["substitut", "analog", "analogue", "alternativ"]
    let spanishMarkers = ["sucedaneo", "sucedaneos", "sustituto", "sustitutos", "alternativ"]
    return (normalizedTag.contains("meat") && englishMarkers.contains { normalizedTag.contains($0) }) ||
        (normalizedTag.contains("carne") && spanishMarkers.contains { normalizedTag.contains($0) })
}

private func isVeganSealTag(_ tag: String) -> Bool {
    let normalizedTag = tag.lowercased().split(separator: ":", maxSplits: 1).last.map(String.init) ?? tag.lowercased()
    return normalizedTag.contains("vegan") &&
        !normalizedTag.contains("non") &&
        !normalizedTag.contains("not")
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
        .map { word in
            let lowercased = word.lowercased()
            guard let first = lowercased.first, first.isLowercase else {
                return lowercased
            }
            return String(first).uppercased() + lowercased.dropFirst()
        }
        .joined(separator: " ")
}

private func htmlDecoded(_ raw: String) -> String {
    let withoutMarkup = raw.replacingOccurrences(
        of: #"</?[A-Za-z][^>]*>"#,
        with: "",
        options: .regularExpression
    )

    guard withoutMarkup.contains("&") else { return withoutMarkup }

    let entities: [(String, String)] = [
        ("&nbsp;", " "),
        ("&quot;", "\""),
        ("&apos;", "'"),
        ("&#39;", "'"),
        ("&lt;", "<"),
        ("&gt;", ">"),
        ("&amp;", "&")
    ]

    var result = withoutMarkup
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
