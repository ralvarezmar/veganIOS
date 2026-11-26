import Foundation

enum VeganStatus: Equatable, Hashable {
    case vegan
    case notVegan
    case maybe
    case unknown

    var persistedValue: String {
        switch self {
        case .vegan:
            return "VEGAN"
        case .notVegan:
            return "NOT_VEGAN"
        case .maybe:
            return "MAYBE"
        case .unknown:
            return "UNKNOWN"
        }
    }

    init(persisted value: String?) {
        switch value?.uppercased() {
        case "VEGAN":
            self = .vegan
        case "NOT_VEGAN":
            self = .notVegan
        case "MAYBE":
            self = .maybe
        default:
            self = .unknown
        }
    }
}

enum VeganConfidence: Equatable {
    case high
    case medium
    case low
}

enum VeganReasonSource: Equatable {
    case structuredNonVeganIngredient
    case structuredDoubtfulIngredient
    case flavourDairyName
    case structuredVeganIngredient
    case decisiveTag
    case heuristicText
    case veganSeal
    case meatAlternativeCategory
    case additiveAnimal
    case additiveUncertain
    case tracesOnly
    case sealConflict
    case unverifiedNonVeganTag
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
    let hasIngredientData: Bool

    var confidence: VeganConfidence {
        if status == .unknown {
            return .low
        }
        switch reason?.source {
        case .structuredNonVeganIngredient, .structuredVeganIngredient, .veganSeal:
            return .high
        case .heuristicText, .unverifiedNonVeganTag, .additiveUncertain:
            return .low
        default:
            return heuristic ? .low : .medium
        }
    }

    init(
        status: VeganStatus,
        nonVeganIngredients: [String],
        doubtfulIngredients: [String],
        heuristic: Bool = false,
        reason: VeganReason? = nil,
        hasIngredientData: Bool = false
    ) {
        self.status = status
        self.nonVeganIngredients = nonVeganIngredients
        self.doubtfulIngredients = doubtfulIngredients
        self.heuristic = heuristic
        self.reason = reason
        self.hasIngredientData = hasIngredientData
    }
}

private struct NormalizedIngredient {
    let status: String
    let name: String
    let isTrace: Bool
}

func flattenIngredients(_ ingredients: [OffIngredient]?) -> [OffIngredient] {
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

struct IngredientTraceParts {
    let real: [String]
    let traces: [String]
}

private let traceSegmentRegex = try! NSRegularExpression(pattern: #"[^,;()/.!\n]+|[().!\n]"#)
private let traceWordRegex = try! NSRegularExpression(pattern: #"[\p{L}\p{M}\p{N}]+"#)
private let ingredientHeadingRegex = try! NSRegularExpression(
    pattern: #"(?i)^\s*(?:ingredients|ingredientes|ingrédients|ingrediënten|zutaten|ingredienti):\s*"#
)
let additiveCodeInTextRegex = try! NSRegularExpression(
    pattern: #"(?i)(?<![\p{L}\p{N}])e[\p{Zs}\t]*-?[\p{Zs}\t]*\d{3,4}[a-z]*(?![\p{L}\p{N}])"#
)
private let traceAliases: [[String]] = [
    ["milk", "leche", "lait", "milch", "latte", "leite"],
    ["egg", "eggs", "huevo", "huevos", "oeuf", "oeufs", "ei", "eier", "ovo", "ovos", "uovo", "uova"],
    ["gelatin", "gelatine", "gelatina"],
    ["whey", "molke", "suero de leche"]
]

private func regexRanges(_ regex: NSRegularExpression, in text: String) -> [Range<String.Index>] {
    regex.matches(in: text, range: NSRange(text.startIndex..., in: text)).compactMap { Range($0.range, in: text) }
}

private func hasIngredientHeading(_ text: String) -> Bool {
    regex(ingredientHeadingRegex, matches: text)
}

private func regex(_ regex: NSRegularExpression, matches text: String) -> Bool {
    regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) != nil
}

func replacingAdditiveCodes(in text: String, with transform: (String) -> String) -> String {
    var result = text
    for range in regexRanges(additiveCodeInTextRegex, in: text).reversed() {
        result.replaceSubrange(range, with: transform(String(text[range])))
    }
    return result
}

private func traceWarningStart(_ segment: String) -> String.Index? {
    guard containsTraceWarning(segment) else { return nil }
    let tokens = regexRanges(traceWordRegex, in: segment)
    guard !tokens.isEmpty else { return nil }
    var low = 0
    var high = tokens.count - 1
    while low < high {
        let mid = low + (high - low) / 2
        if containsTraceWarning(String(segment[..<tokens[mid].upperBound])) {
            high = mid
        } else {
            low = mid + 1
        }
    }
    let end = tokens[low].upperBound
    return (0...low).reversed().lazy
        .map { tokens[$0].lowerBound }
        .first { containsTraceWarning(String(segment[$0..<end])) }
}

func traceParts(_ text: String) -> IngredientTraceParts {
    var real: [String] = []
    var traces: [String] = []
    var depth = 0
    var traceDepth: Int?
    let cleaned = cleanFoodFactsMarkup(text)
    for range in regexRanges(traceSegmentRegex, in: cleaned) {
        let segment = String(cleaned[range])
        switch segment {
        case "(":
            depth += 1
        case ")":
            if traceDepth == depth { traceDepth = nil }
            depth = max(depth - 1, 0)
        case ".", "!":
            traceDepth = nil
        case "\n":
            break
        default:
            if traceDepth != nil && !hasIngredientHeading(segment) {
                traces.append(segment)
            } else {
                traceDepth = nil
                if let start = traceWarningStart(segment) {
                    let head = String(segment[..<start])
                    if !head.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        real.append(head)
                    }
                    traces.append(String(segment[start...]))
                    traceDepth = depth
                } else {
                    real.append(segment)
                }
            }
        }
    }
    return IngredientTraceParts(real: real, traces: traces)
}

private func ingredientKey(_ label: String) -> String {
    let withCodes = replacingAdditiveCodes(in: label) { normalizeAdditiveCode($0) }
    return ingredientTokens(normalizeIngredientSegment(withCodes)).joined(separator: " ")
}

private func isTraceIngredient(_ name: String, parts: IngredientTraceParts) -> Bool {
    let own = traceParts(name)
    if !own.traces.isEmpty &&
        !own.real.contains(where: { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) {
        return true
    }
    guard !parts.traces.isEmpty else { return false }
    let key = ingredientKey(name)
    guard !key.isEmpty else { return false }
    let names = traceAliases.first { $0.contains(key) } ?? [key]
    func mentions(_ segment: String) -> Bool {
        let phrase = " \(ingredientKey(segment)) "
        return names.contains { phrase.contains(" \($0) ") }
    }
    return !parts.real.contains(where: mentions) && parts.traces.contains(where: mentions)
}

func analyzeVegan(_ product: Product, displayLanguage: String? = additiveLanguageCode()) -> VeganAnalysis {
    let analysis = analyzeVegan(
        ingredientsAnalysisTags: product.ingredientsAnalysisTags,
        ingredients: product.ingredients,
        ingredientsText: product.ingredientsText,
        additivesTags: product.additivesTags,
        categoriesTags: product.categoriesTags,
        labelsTags: product.labelsTags
    )
    guard let displayLanguage else { return analysis }
    return analysis.withLocalizedIngredientNames(
        ingredients: product.ingredients,
        productLanguage: product.ingredientsLanguage,
        languageCode: displayLanguage
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
    let parts = traceParts(ingredientsText ?? "")
    let normalizedIngredients = ingredientList.compactMap { ingredient -> NormalizedIngredient? in
        let name = cleanFoodFactsLabel(ingredient.text) ?? cleanFoodFactsLabel(ingredient.id) ?? ""
        guard !isIngredientConnector(name) else { return nil }
        return NormalizedIngredient(
            status: ingredient.vegan?.lowercased() ?? "",
            name: name,
            isTrace: isTraceIngredient(name, parts: parts)
        )
    }

    let structuredDairyFlavourIngredients = normalizedIngredients
        .filter { $0.status == "no" && !$0.isTrace && containsDoubtfulFlavourIngredient($0.name) }
        .map(\.name)
        .orderedUnique()
    let nonVegan = normalizedIngredients
        .filter { $0.status == "no" && !$0.isTrace && !structuredDairyFlavourIngredients.contains($0.name) }
        .map(\.name)
        .orderedUnique()
    let doubtful = (
        normalizedIngredients.filter { $0.status == "maybe" && !$0.isTrace }.map(\.name) +
            structuredDairyFlavourIngredients
    ).orderedUnique()
    let traceIngredients = normalizedIngredients
        .filter { ["no", "maybe"].contains($0.status) && $0.isTrace }
        .map(\.name)
        .orderedUnique()
    let structuredAnimalIngredients = normalizedIngredients.filter { ["no", "maybe"].contains($0.status) }
    let tracesOnly = !structuredAnimalIngredients.isEmpty && structuredAnimalIngredients.allSatisfy(\.isTrace)
    let actualIngredients = normalizedIngredients.filter { !$0.isTrace }
    let fullyClassified = actualIngredients.allSatisfy { !$0.name.isEmpty && $0.status == "yes" }
    let classifiedNames = Set(actualIngredients.map { ingredientKey($0.name) })
    let realTextLabels = parts.real.compactMap { cleanFoodFactsLabel($0) }
    let uncoveredLabels = realTextLabels.filter { !classifiedNames.contains(ingredientKey($0)) }
    let knownYesIngredients = !actualIngredients.isEmpty && fullyClassified && uncoveredLabels.isEmpty
    let explainedByTraces = tracesOnly && fullyClassified &&
        (!actualIngredients.isEmpty || !realTextLabels.isEmpty) &&
        uncoveredLabels.allSatisfy { isRecognizedPhotoPlantOrNeutral($0) }
    let realSegments = (parts.real + actualIngredients.flatMap { traceParts($0.name).real }).orderedUnique()
    let additiveMatches = findAdditiveMatches(
        additivesTags: additivesTags,
        realSegments: realSegments,
        traceSegments: parts.traces
    )
    let wordsOnly = realSegments.map { replacingAdditiveCodes(in: $0) { _ in " " } }
    let corroboratingAnimalIngredients = wordsOnly.filter(containsAnimalIngredient)
        .compactMap { cleanFoodFactsLabel($0) }
        .orderedUnique()
    let corroboratingDoubtfulFlavourIngredients = wordsOnly.filter(containsDoubtfulFlavourIngredient)
        .compactMap { cleanFoodFactsLabel($0) }
        .orderedUnique()
    let hasText = !(ingredientsText?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    let hasIngredientData = !ingredientList.isEmpty || hasText

    let decisiveTag: String? = {
        guard let tags = ingredientsAnalysisTags else { return nil }
        if tags.contains("en:non-vegan") { return "en:non-vegan" }
        if tags.contains("en:maybe-vegan") { return "en:maybe-vegan" }
        if tags.contains("en:vegan") { return "en:vegan" }
        return nil
    }()

    var confirmedKeys = Set<String>()
    let confirmed = (nonVegan + additiveMatches.animal + corroboratingAnimalIngredients).filter { name in
        let key = ingredientKey(name)
        let canonical = traceAliases.first { $0.contains(key) }?.first ?? key
        return confirmedKeys.insert(canonical).inserted
    }

    if let veganSeal = labelsTags?.first(where: isVeganSealTag) {
        let negativeLabel = labelsTags?.first { $0.lowercased() == "en:non-vegan" }
        let conflictingTag = negativeLabel ?? (decisiveTag == "en:non-vegan" && !tracesOnly ? decisiveTag : nil)
        if !confirmed.isEmpty || conflictingTag != nil {
            return VeganAnalysis(
                status: .maybe,
                nonVeganIngredients: [],
                doubtfulIngredients: confirmed,
                reason: VeganReason(
                    source: .sealConflict,
                    evidence: confirmed.isEmpty ? [conflictingTag].compactMap { $0 } : confirmed
                ),
                hasIngredientData: hasIngredientData
            )
        }
        return VeganAnalysis(
            status: .vegan,
            nonVeganIngredients: [],
            doubtfulIngredients: [],
            reason: VeganReason(source: .veganSeal, evidence: [veganSeal]),
            hasIngredientData: hasIngredientData
        )
    }

    let (status, reason): (VeganStatus, VeganReason?) = {
        if !nonVegan.isEmpty {
            return (.notVegan, VeganReason(source: .structuredNonVeganIngredient, evidence: nonVegan))
        }
        if !additiveMatches.animal.isEmpty {
            return (.notVegan, VeganReason(source: .additiveAnimal, evidence: additiveMatches.animal))
        }
        if !corroboratingAnimalIngredients.isEmpty {
            return (.notVegan, VeganReason(source: .heuristicText, evidence: corroboratingAnimalIngredients))
        }
        if decisiveTag == "en:non-vegan" && !hasIngredientData {
            return (.notVegan, VeganReason(source: .decisiveTag, evidence: ["en:non-vegan"]))
        }
        if decisiveTag == "en:vegan" {
            return (.vegan, VeganReason(source: .decisiveTag, evidence: ["en:vegan"]))
        }
        if !corroboratingDoubtfulFlavourIngredients.isEmpty {
            return (.maybe, VeganReason(source: .flavourDairyName, evidence: corroboratingDoubtfulFlavourIngredients))
        }
        if !doubtful.isEmpty {
            return (.maybe, VeganReason(source: .structuredDoubtfulIngredient, evidence: doubtful))
        }
        if !additiveMatches.uncertain.isEmpty {
            return (.maybe, VeganReason(source: .additiveUncertain, evidence: additiveMatches.uncertain))
        }
        if explainedByTraces {
            return (.vegan, VeganReason(source: .tracesOnly, evidence: traceIngredients))
        }
        if decisiveTag == "en:non-vegan" {
            return (.maybe, VeganReason(source: .unverifiedNonVeganTag))
        }
        if decisiveTag == "en:maybe-vegan" {
            return (.maybe, VeganReason(source: .decisiveTag, evidence: ["en:maybe-vegan"]))
        }
        if knownYesIngredients {
            return (
                .vegan,
                VeganReason(
                    source: .structuredVeganIngredient,
                    evidence: actualIngredients.map(\.name).orderedUnique()
                )
            )
        }
        if hasText {
            return (.maybe, VeganReason(source: .heuristicText))
        }
        return (.unknown, nil)
    }()
    let uncertain = (doubtful + corroboratingDoubtfulFlavourIngredients + additiveMatches.uncertain)
        .orderedUnique()
        .filter { !confirmed.contains($0) }
    return VeganAnalysis(
        status: status,
        nonVeganIngredients: confirmed,
        doubtfulIngredients: status == .vegan ? [] : uncertain,
        heuristic: reason?.source == .heuristicText ||
            (reason?.source == .flavourDairyName && structuredDairyFlavourIngredients.isEmpty),
        reason: reason,
        hasIngredientData: hasIngredientData
    )
}

private func isIngredientConnector(_ name: String) -> Bool {
    [
        "a",
        "as",
        "da",
        "das",
        "de",
        "do",
        "dos",
        "e",
        "em",
        "na",
        "nas",
        "no",
        "nos",
        "o",
        "os"
    ].contains(normalizeIngredientSegment(name))
}

private struct AdditiveMatches {
    let animal: [String]
    let uncertain: [String]
}

private func canonicalAdditiveCode(_ raw: String) -> String {
    additiveEntry(for: raw)?.code ?? normalizeAdditiveCode(raw)
}

private func findAdditiveMatches(
    additivesTags: [String]?,
    realSegments: [String],
    traceSegments: [String]
) -> AdditiveMatches {
    let traceCodes = Set(traceSegments.flatMap(findAdditiveCodesInText).map(canonicalAdditiveCode))
    let realCodes = realSegments.flatMap(findAdditiveCodesInText).map(canonicalAdditiveCode)
    let taggedCodes = (additivesTags ?? []).map { raw in
        canonicalAdditiveCode(cleanFoodFactsMarkup(raw.components(separatedBy: ":").last ?? raw))
    }
    let codes = (realCodes + taggedCodes.filter { !traceCodes.contains($0) }).orderedUnique()
    return AdditiveMatches(
        animal: codes.filter { additiveEntry(for: $0)?.info.origin == .animal },
        uncertain: codes.filter { additiveEntry(for: $0)?.info.origin == .uncertain }
    )
}

private func findAdditiveCodesInText(_ text: String) -> [String] {
    regexRanges(additiveCodeInTextRegex, in: text)
        .map { normalizeAdditiveCode(String(text[$0])) }
        .orderedUnique()
}

private let veganLabelIds: Set<String> = [
    "en:vegan",
    "en:certified-vegan",
    "en:vegan-society",
    "en:european-vegetarian-union-vegan",
    "en:v-label-vegan"
]

func isVeganSealTag(_ tag: String) -> Bool {
    veganLabelIds.contains(tag.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())
}

private let languagePrefixRegex = try! NSRegularExpression(
    pattern: "^(?:\(Locale.isoLanguageCodes.joined(separator: "|"))):",
    options: .caseInsensitive
)

private func removingFirst(_ regex: NSRegularExpression, from text: String) -> String {
    regex.stringByReplacingMatches(
        in: text,
        range: NSRange(text.startIndex..., in: text),
        withTemplate: ""
    )
}

func cleanFoodFactsLabel(_ raw: String?) -> String? {
    guard let raw = raw?.trimmingCharacters(in: .whitespacesAndNewlines), !raw.isEmpty else {
        return nil
    }

    let decoded = htmlDecoded(raw).trimmingCharacters(in: .whitespacesAndNewlines)
    guard !decoded.isEmpty else { return nil }

    var normalized = removingFirst(
        ingredientHeadingRegex,
        from: removingFirst(languagePrefixRegex, from: decoded)
    )

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
