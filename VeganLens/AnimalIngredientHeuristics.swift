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

private let traceWarningMarkers = [
    "puede contener", "pode conter", "may contain", "peut contenir",
    "puo contenere", "kann spuren", "spuren von", "trazas de", "traza de",
    "tracce di", "traces of", "traces de", "vestigios de", "tracos de"
]

func detectAnimalIngredients(_ text: String) -> [String] {
    guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return [] }

    var results: [String] = []
    var seen = Set<String>()
    let textWithoutMarkup = cleanFoodFactsMarkup(text)
    for sentence in textWithoutMarkup.components(separatedBy: CharacterSet(charactersIn: ".!\n")) {
        for segment in sentence.components(separatedBy: CharacterSet(charactersIn: ",;()/")) {
            let norm = normalizeIngredientSegment(segment)
            if traceWarningMarkers.contains(where: { norm.contains($0) }) { break }
            let hasUnambiguousMatch = animalLexemeModes.contains { entry in
                !ambiguousAnimalLexemes.contains(entry.key) &&
                    matchesAnimalLexeme(entry.key, mode: entry.value, normalized: norm)
            }
            let hasAmbiguousMatch = animalLexemeModes.contains { entry in
                ambiguousAnimalLexemes.contains(entry.key) &&
                    matchesAnimalLexeme(entry.key, mode: entry.value, normalized: norm)
            } && !plantQualifiers.contains { norm.contains($0) }
            let tokens = ingredientTokens(norm)
            let hasEggToken = tokens.contains { eggTokens.contains($0) }

            guard hasUnambiguousMatch || hasAmbiguousMatch || hasEggToken,
                  let cleaned = cleanFoodFactsLabel(segment),
                  seen.insert(cleaned).inserted else {
                continue
            }
            results.append(cleaned)
        }
    }
    return results
}

func ingredientSegments(_ text: String) -> [String] {
    cleanFoodFactsMarkup(text)
        .components(separatedBy: CharacterSet(charactersIn: ".!\n"))
        .flatMap { sentence in
            sentence.components(separatedBy: CharacterSet(charactersIn: ",;()/"))
        }
}

func containsTraceWarning(_ segment: String) -> Bool {
    traceWarningMarkers.contains { normalizeIngredientSegment(segment).contains($0) }
}

func containsAnimalIngredient(_ segment: String) -> Bool {
    let normalized = normalizeIngredientSegment(segment)
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
