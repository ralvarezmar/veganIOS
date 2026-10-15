import Foundation

enum AnimalLexemeMatchMode {
    case tokenExact
    case tokenPrefix
    case tokenContains
}

private let rawAnimalLexemeCatalog: Set<String> = [
    "molke", "whey", "lactos", "laktos", "lactosuero",
    "casein", "caseina", "kasein", "lactoglob", "lactalb",
    "suero de leche", "queso", "cheese", "kase", "fromage", "formagg",
    "parmesan", "parmigian", "mozzarella", "cheddar", "gouda", "emmental",
    "ovoalbum", "ovoprodu", "miel", "honey", "honig", "miele",
    "gelatin", "gelatina", "gelatine", "carne", "fleisch", "viande",
    "jamon", "tocino", "panceta", "bacon", "speck", "schinken",
    "pollo", "huhn", "poulet", "chicken", "cerdo", "schwein", "pork",
    "porc", "ternera", "vacuno", "beef", "cordero", "lamb", "agnello",
    "pavo", "pavos", "turkey", "chorizo", "salami", "wurst", "embutido",
    "pescado", "poisson", "fisch", "atun", "thunfisch", "thon", "tuna",
    "anchoa", "anchois", "sardin", "gamba", "camaron", "shrimp", "krill",
    "krebstier", "molusco", "calamar", "pulpo", "marisco", "seafood",
    "surimi", "salmon", "lachs", "saumon", "bacalao", "kabeljau", "trucha",
    "forelle", "schmalz", "saindoux", "sebo", "tallow", "talg", "suif",
    "lard", "lardo", "carmin", "karmin", "cochinill", "cochenill",
    "cochineal", "e120", "carminico", "shellac", "schellack", "goma laca",
    "e904", "albumin", "albumina", "lanolin", "lanolina", "cuajo", "rennet",
    "presure", "labferment", "chitin", "quitina", "manteca de cerdo",
    "cera de abeja", "beeswax", "bienenwachs", "cire d abeille", "e901",
    "royal jelly", "jalea real", "gelee royale", "propolis", "milch", "milk",
    "leche", "lait", "latte", "nata", "sahne", "cream", "creme", "panna",
    "crema", "butter", "mantequilla", "beurre", "burro", "obers", "rahm"
]

let animalLexemeModes = rawAnimalLexemeCatalog.reduce(into: [String: AnimalLexemeMatchMode]()) {
    switch $1 {
    case "tuna", "porc", "pavo", "pavos", "e120", "e901", "e904":
        $0[$1] = .tokenExact
    case "nata":
        $0[$1] = .tokenPrefix
    default:
        $0[$1] = .tokenContains
    }
}

let ambiguousAnimalLexemes: Set<String> = [
    "milch", "milk", "leche", "lait", "latte", "nata", "sahne", "cream",
    "creme", "panna", "crema", "butter", "mantequilla", "beurre", "burro",
    "obers", "rahm"
]

let flavourDescriptors: Set<String> = [
    "aroma", "aromas", "aromat", "aromatizante", "aromatisant", "arome",
    "aromes", "aromi", "aromen", "aromastoff", "sabor", "sabores",
    "saborizante", "flavour", "flavor", "flavouring", "flavoring",
    "geschmack", "gusto", "gout"
]

let degradableDairyLexemes: Set<String> = ambiguousAnimalLexemes.union([
    "queso", "cheese", "kase", "fromage", "formagg", "parmesan", "parmigian",
    "mozzarella", "cheddar", "gouda", "emmental"
])

let plantQualifiers = [
    "coco", "coconut", "kokos", "almendra", "almend", "almond", "mandel", "amande",
    "soja", "soy", "soya", "avena", "oat", "hafer", "avoine", "arroz", "rice", "reis",
    "riz", "cacahuete", "cacahuet", "peanut", "erdnuss", "arachide", "cacao", "cocoa",
    "kakao", "karite", "shea", "anacardo", "cashew", "avellana", "hazelnut", "haselnuss",
    "nuez", "walnut", "nogal", "vegetal", "vegetale", "vegetabil", "pflanzlich", "vegan",
    "tofu", "seitan", "oliva", "olive", "girasol", "sunflower", "sonnenblume", "tournesol",
    "palma", "palm"
]

let eggTokens: Set<String> = [
    "huevo", "huevos", "yema", "yemas", "ovoproducto", "egg", "eggs", "albumen",
    "ovalbumin", "ei", "eier", "eigelb", "eiklar", "vollei", "volleipulver", "eipulver",
    "trockenei", "huhnerei", "oeuf", "oeufs"
]

private let traceWarningTokenPattern =
    #"(?<![\p{L}\p{N}])(?:trazas?|traces?|tracce|traccia|spur(?:en)?|vestigios?|tracos?|sporen|spoor)(?![\p{L}\p{N}])"#

private let traceWarningPatterns = [
    #"\b(?:puede|pueden|podria|podrian|pode|podem|podera|peut|peuvent|puo|possono|may|might|can|could|pot|poden|kan|kunnen)"# +
        #"(?: \p{L}+){0,2} (?:contener|conter|contenir|contenere|contain|bevatten)\b"#,
    #"\b(?:kann|konnen|konnte|konnten)\b.*\benthalten\b"#,
    #"\benthalt moglicherweise\b"#,
    #"\bsusceptible de contenir\b"#
]

private let sharedFacilityMarkers = [
    "en una fabrica", "en una planta", "en instalaciones", "en la misma linea",
    "numa fabrica", "em uma fabrica", "numa unidade", "na mesma linha",
    "in a factory", "in a facility", "on equipment", "on shared equipment",
    "on the same line", "on a line",
    "dans un atelier", "dans une usine", "sur une ligne", "sur la meme ligne",
    "in uno stabilimento", "nello stabilimento", "sulla stessa linea",
    "in einem betrieb", "auf anlagen", "auf einer anlage", "auf derselben linie",
    "in een fabriek", "in een bedrijf"
]

private let traceSegmentSeparator = " , "
private let sentenceDelimiters = CharacterSet(charactersIn: ".!\n")
private let segmentDelimiters = CharacterSet(charactersIn: ",;()/")

struct IngredientTraceParts {
    let real: [String]
    let traces: [String]
}

private func traceWarningStart(_ normalized: String) -> Int? {
    guard !normalized.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
    func offset(of pattern: String, regex: Bool) -> Int? {
        guard let range = normalized.range(
            of: pattern,
            options: regex ? .regularExpression : []
        ) else {
            return nil
        }
        return normalized.distance(from: normalized.startIndex, to: range.lowerBound)
    }
    let starts = [offset(of: traceWarningTokenPattern, regex: true)] +
        traceWarningPatterns.map { offset(of: $0, regex: true) } +
        sharedFacilityMarkers.map { offset(of: $0, regex: false) }
    return starts.compactMap { $0 }.min()
}

func containsTraceWarning(_ segment: String) -> Bool {
    traceWarningStart(normalizeIngredientSegment(segment)) != nil
}

private func traceWarningSegmentIndex(_ segments: [String]) -> Int? {
    let normalized = segments.map(normalizeIngredientSegment)
    var segmentStarts: [Int] = []
    var offset = 0
    for segment in normalized {
        segmentStarts.append(offset)
        offset += segment.count + traceSegmentSeparator.count
    }
    guard let matchStart = traceWarningStart(normalized.joined(separator: traceSegmentSeparator)) else {
        return nil
    }
    return segmentStarts.lastIndex { $0 <= matchStart }
}

private struct IngredientPhrase {
    let text: String
    let endsWithLineBreak: Bool
}

private func ingredientPhrases(_ text: String) -> [IngredientPhrase] {
    var phrases: [IngredientPhrase] = []
    var current = ""
    for scalar in cleanFoodFactsMarkup(text).unicodeScalars {
        if sentenceDelimiters.contains(scalar) {
            phrases.append(IngredientPhrase(text: current, endsWithLineBreak: scalar == "\n"))
            current = ""
        } else {
            current.unicodeScalars.append(scalar)
        }
    }
    phrases.append(IngredientPhrase(text: current, endsWithLineBreak: false))
    return phrases
}

private func startsWithLowercaseLetter(_ text: String) -> Bool {
    text.first(where: \.isLetter)?.isLowercase == true
}

/// Splits ingredient text into real ingredients and precautionary trace statements
/// ("may contain", "traces of", "made in a factory that also handles"...). A trace
/// statement wrapped onto the next line (common in OCR text) keeps applying while the
/// next line continues in lowercase.
func splitIngredientTraceParts(_ text: String) -> IngredientTraceParts {
    var real: [String] = []
    var traces: [String] = []
    var traceContinues = false
    for phrase in ingredientPhrases(text) {
        let segments = phrase.text.components(separatedBy: segmentDelimiters)
        if traceContinues && startsWithLowercaseLetter(phrase.text) {
            traces.append(contentsOf: segments)
            traceContinues = phrase.endsWithLineBreak
            continue
        }
        guard let traceStart = traceWarningSegmentIndex(segments) else {
            real.append(contentsOf: segments)
            traceContinues = false
            continue
        }
        real.append(contentsOf: segments[..<traceStart])
        traces.append(contentsOf: segments[traceStart...])
        traceContinues = phrase.endsWithLineBreak
    }
    return IngredientTraceParts(real: real, traces: traces)
}

func detectAnimalIngredients(_ text: String) -> [String] {
    guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return [] }

    var results: [String] = []
    var seen = Set<String>()
    for segment in splitIngredientTraceParts(text).real {
        guard containsAnimalIngredient(segment),
              let cleaned = cleanFoodFactsLabel(segment),
              seen.insert(cleaned).inserted else {
            continue
        }
        results.append(cleaned)
    }
    return results
}

func containsAnimalIngredient(_ segment: String) -> Bool {
    let normalized = normalizeIngredientSegment(segment)
    if containsDoubtfulFlavourIngredient(segment) { return false }
    let hasUnambiguousMatch = animalLexemeModes.contains { entry in
        !ambiguousAnimalLexemes.contains(entry.key) &&
            matchesAnimalLexeme(entry.key, mode: entry.value, normalized: normalized)
    }
    let hasAmbiguousMatch = animalLexemeModes.contains { entry in
        ambiguousAnimalLexemes.contains(entry.key) &&
            matchesAnimalLexeme(entry.key, mode: entry.value, normalized: normalized)
    } &&
        !plantQualifiers.contains { normalized.contains($0) }
    let tokens = ingredientTokens(normalized)
    let hasEggToken = tokens.contains { eggTokens.contains($0) }
    return hasUnambiguousMatch || hasAmbiguousMatch || hasEggToken
}

func containsDoubtfulFlavourIngredient(_ segment: String) -> Bool {
    guard !containsTraceWarning(segment) else { return false }
    let normalized = normalizeIngredientSegment(segment)
    guard !plantQualifiers.contains(where: { normalized.contains($0) }) else { return false }
    let tokens = ingredientTokens(normalized)
    let hasFlavourDescriptor = tokens.contains { token in
        flavourDescriptors.contains { descriptor in
            token.hasPrefix(descriptor) ||
                (descriptor == "aroma" && token.hasSuffix(descriptor))
        }
    }
    guard hasFlavourDescriptor else { return false }
    let matchedAnimalLexemes = Set(animalLexemeModes.compactMap { entry in
        matchesAnimalLexeme(entry.key, mode: entry.value, normalized: normalized)
            ? entry.key
            : nil
    })
    let hasEggToken = tokens.contains { eggTokens.contains($0) }
    return !matchedAnimalLexemes.isEmpty &&
        matchedAnimalLexemes.allSatisfy { degradableDairyLexemes.contains($0) } &&
        !hasEggToken
}

func detectDoubtfulFlavourIngredients(_ text: String) -> [String] {
    guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return [] }

    var results: [String] = []
    var seen = Set<String>()
    for segment in splitIngredientTraceParts(text).real {
        guard containsDoubtfulFlavourIngredient(segment),
              let cleaned = cleanFoodFactsLabel(segment),
              seen.insert(cleaned).inserted else {
            continue
        }
        results.append(cleaned)
    }
    return results
}

func ingredientTokens(_ normalized: String) -> [String] {
    normalized.components(separatedBy: CharacterSet.alphanumerics.inverted)
        .filter { !$0.isEmpty }
}

func matchesAnimalLexeme(
    _ lexeme: String,
    mode: AnimalLexemeMatchMode,
    normalized: String
) -> Bool {
    if lexeme.contains(" ") {
        return normalized == lexeme ||
            normalized.hasPrefix("\(lexeme) ") ||
            normalized.hasSuffix(" \(lexeme)") ||
            normalized.contains(" \(lexeme) ")
    }
    return ingredientTokens(normalized).contains { token in
        switch mode {
        case .tokenExact: return token == lexeme
        case .tokenPrefix: return token.hasPrefix(lexeme)
        case .tokenContains: return token.contains(lexeme)
        }
    }
}

func normalizeIngredientSegment(_ segment: String) -> String {
    segment
        .lowercased()
        .folding(options: .diacriticInsensitive, locale: Locale(identifier: "en"))
        .replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
        .trimmingCharacters(in: .whitespacesAndNewlines)
}
