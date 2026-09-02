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
    case additiveAnimal
    case additiveUncertain
    case tracesOnly
    case sealConflict
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

private struct NormalizedIngredient {
    let status: String
    let name: String
    let isTrace: Bool
}

private struct IngredientTraceParts {
    let real: [String]
    let traces: [String]
}

private func flattenIngredients(_ ingredients: [OffIngredient]?) -> [OffIngredient] {
    var flattened: [OffIngredient] = []

    func appendAll(_ items: [OffIngredient]?) {
        for ingredient in items ?? [] {
            flattened.append(ingredient)
            appendAll(ingredient.ingredients)
        }
    }

    appendAll(ingredients)
    return flattened
}

private func traceParts(_ text: String) -> IngredientTraceParts {
    var real: [String] = []
    var traces: [String] = []
    for phrase in cleanFoodFactsMarkup(text).components(separatedBy: CharacterSet(charactersIn: ".!\n")) {
        let segments = phrase.components(separatedBy: CharacterSet(charactersIn: ",;()/"))
        guard let traceStart = segments.firstIndex(where: containsTraceWarning) else {
            real.append(contentsOf: segments)
            continue
        }
        real.append(contentsOf: segments[..<traceStart])
        traces.append(contentsOf: segments[traceStart...])
    }
    return IngredientTraceParts(real: real, traces: traces)
}

private func isTraceIngredient(_ ingredient: OffIngredient, ingredientsText: String?) -> Bool {
    if containsTraceWarning(ingredient.text ?? "") {
        return true
    }
    guard let ingredientsText,
          !ingredientsText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
          let cleanedName = cleanFoodFactsLabel(ingredient.text) else {
        return false
    }

    let name = normalizeIngredientSegment(cleanedName)
    let parts = traceParts(ingredientsText)
    let appearsInRealIngredients = parts.real.contains {
        normalizeIngredientSegment($0).contains(name)
    }
    if appearsInRealIngredients {
        return false
    }
    return parts.traces.contains {
        normalizeIngredientSegment($0).contains(name)
    } || parts.traces.contains(where: containsAnimalIngredient)
}

func analyzeVegan(_ product: Product) -> VeganAnalysis {
    analyzeVegan(
        ingredientsAnalysisTags: product.ingredientsAnalysisTags,
        ingredients: product.ingredients,
        ingredientsText: product.ingredientsText,
        additivesTags: product.additivesTags,
        categoriesTags: product.categoriesTags,
        labelsTags: product.labelsTags
    )
}

func analyzeVegan(
    ingredientsAnalysisTags: [String]?,
    ingredients: [OffIngredient]?,
    ingredientsText: String? = nil,
    additivesTags: [String]? = nil,
    categoriesTags: [String]? = nil,
    labelsTags: [String]? = nil
) -> VeganAnalysis {
    let ingredientList = flattenIngredients(ingredients)
    let normalizedIngredients = ingredientList.compactMap { ingredient -> NormalizedIngredient? in
        guard let vegan = ingredient.vegan?.lowercased(), let cleanedText = cleanFoodFactsLabel(ingredient.text) else {
            return nil
        }
        return NormalizedIngredient(
            status: vegan,
            name: cleanedText,
            isTrace: ["no", "maybe"].contains(vegan) &&
                isTraceIngredient(ingredient, ingredientsText: ingredientsText)
        )
    }

    let nonVegan = normalizedIngredients
        .filter { $0.status == "no" && !$0.isTrace }
        .map(\.name)
        .orderedUnique()

    let doubtful = normalizedIngredients
        .filter { $0.status == "maybe" && !$0.isTrace }
        .map(\.name)
        .orderedUnique()

    let traceIngredients = normalizedIngredients
        .filter { ["no", "maybe"].contains($0.status) && $0.isTrace }
        .map(\.name)
        .orderedUnique()
    let structuredAnimalIngredients = normalizedIngredients.filter {
        ["no", "maybe"].contains($0.status)
    }
    let tracesOnly = !structuredAnimalIngredients.isEmpty &&
        structuredAnimalIngredients.allSatisfy(\.isTrace)
    let hasYesIngredient = normalizedIngredients.contains { $0.status == "yes" }
    let additiveMatches = findAdditiveMatches(
        additivesTags: additivesTags,
        ingredientsText: ingredientsText,
        ingredients: ingredientList
    )
    let hasIngredients = !ingredientList.isEmpty
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

    let hasVeganSeal = labelsTags?.contains(where: isVeganSealTag) == true
    if hasVeganSeal {
        let sealConflicts = (nonVegan + additiveMatches.animal).orderedUnique()
        if !sealConflicts.isEmpty {
            return VeganAnalysis(
                status: .maybe,
                nonVeganIngredients: [],
                doubtfulIngredients: sealConflicts,
                reason: VeganReason(source: .sealConflict, evidence: sealConflicts)
            )
        }
        return VeganAnalysis(
            status: .vegan,
            nonVeganIngredients: [],
            doubtfulIngredients: [],
            reason: VeganReason(
                source: .veganSeal,
                evidence: Array(labelsTags?.filter(isVeganSealTag).prefix(1) ?? [])
            )
        )
    }

    let status: VeganStatus = {
        if !nonVegan.isEmpty { return .notVegan }
        if !additiveMatches.animal.isEmpty { return .notVegan }
        if decisiveStatus == .vegan { return .vegan }
        if !doubtful.isEmpty { return .maybe }
        if !additiveMatches.uncertain.isEmpty { return .maybe }
        if tracesOnly { return .vegan }
        if let decisiveStatus { return decisiveStatus }
        if hasYesIngredient { return .vegan }
        if !hasIngredients && !hasTags { return .unknown }
        return .unknown
    }()

    let reason: VeganReason? = {
        if !nonVegan.isEmpty {
            return VeganReason(source: .structuredNonVeganIngredient, evidence: nonVegan)
        }
        if !additiveMatches.animal.isEmpty {
            return VeganReason(source: .additiveAnimal, evidence: additiveMatches.animal)
        }
        if decisiveTag == "en:vegan" {
            return VeganReason(source: .decisiveTag, evidence: [decisiveTag])
        }
        if !doubtful.isEmpty {
            return VeganReason(source: .structuredDoubtfulIngredient, evidence: doubtful)
        }
        if !additiveMatches.uncertain.isEmpty {
            return VeganReason(source: .additiveUncertain, evidence: additiveMatches.uncertain)
        }
        if tracesOnly {
            return VeganReason(source: .tracesOnly, evidence: traceIngredients)
        }
        if let decisiveTag {
            return VeganReason(source: .decisiveTag, evidence: [decisiveTag])
        }
        if hasYesIngredient {
            return VeganReason(
                source: .structuredVeganIngredient,
                evidence: normalizedIngredients.filter { $0.status == "yes" }.map(\.name)
            )
        }
        return nil
    }()

    let finalStatus: VeganStatus
    let finalReason: VeganReason?
    if status == .unknown, categoriesTags?.contains(where: isMeatAlternativeCategoryTag) == true {
        finalStatus = .vegan
        finalReason = VeganReason(
            source: .meatAlternativeCategory,
            evidence: Array(categoriesTags?.filter(isMeatAlternativeCategoryTag).prefix(1) ?? [])
        )
    } else {
        finalStatus = status
        finalReason = reason
    }
    let reportedNonVeganIngredients = (nonVegan + additiveMatches.animal).orderedUnique()
    let reportedDoubtfulIngredients = decisiveTag == "en:vegan"
        ? doubtful
        : (doubtful + additiveMatches.uncertain).orderedUnique()

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
        nonVeganIngredients: reportedNonVeganIngredients,
        doubtfulIngredients: reportedDoubtfulIngredients,
        reason: finalReason
    )
}

private struct AdditiveMatches {
    let animal: [String]
    let uncertain: [String]
}

private func findAdditiveMatches(
    additivesTags: [String]?,
    ingredientsText: String?,
    ingredients: [OffIngredient]?
) -> AdditiveMatches {
    var codes: [String] = []
    for raw in additivesTags ?? [] {
        let tag = raw.components(separatedBy: ":").last ?? raw
        if let entry = additiveEntry(for: tag), !codes.contains(entry.code) {
            codes.append(entry.code)
        }
    }
    let text = ([ingredientsText ?? ""] + (ingredients ?? []).map { $0.text ?? "" }).joined(separator: " ")
    for rawCode in findAdditiveCodesInText(text) {
        if let entry = additiveEntry(for: rawCode), !codes.contains(entry.code) {
            codes.append(entry.code)
        }
    }

    return AdditiveMatches(
        animal: codes.filter { additiveEntry(for: $0)?.info.origin == .animal },
        uncertain: codes.filter { additiveEntry(for: $0)?.info.origin == .uncertain }
    )
}

private func findAdditiveCodesInText(_ text: String) -> [String] {
    let pattern = #"(?i)(?<![a-z0-9])e\d{3,4}[a-z]*(?![a-z0-9])"#
    guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
    let range = NSRange(text.startIndex..., in: text)
    return regex.matches(in: text, range: range).compactMap { match in
        guard let matchRange = Range(match.range, in: text) else { return nil }
        return normalizeAdditiveCode(String(text[matchRange]))
    }.orderedUnique()
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

func cleanFoodFactsMarkup(_ raw: String) -> String {
    raw.replacingOccurrences(
        of: #"</?[A-Za-z][^>]*>"#,
        with: "",
        options: .regularExpression
    )
}

private func htmlDecoded(_ raw: String) -> String {
    let withoutMarkup = cleanFoodFactsMarkup(raw)
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
