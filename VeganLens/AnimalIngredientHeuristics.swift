import Foundation

enum AnimalLexemeMatchMode {
    case tokenExact
    case tokenPrefix
    case tokenContains
}

let animalLexemeModes: [String: AnimalLexemeMatchMode] = [
    "molke": .tokenPrefix, "whey": .tokenPrefix, "lactos": .tokenPrefix,
    "laktos": .tokenPrefix, "lactosuero": .tokenPrefix,
    "casein": .tokenPrefix, "caseina": .tokenPrefix, "kasein": .tokenPrefix,
    "lactoglob": .tokenPrefix, "lactalb": .tokenPrefix,
    "suero de leche": .tokenExact, "queso": .tokenPrefix, "cheese": .tokenPrefix,
    "kase": .tokenContains, "fromage": .tokenPrefix, "formagg": .tokenPrefix,
    "parmesan": .tokenPrefix, "parmigian": .tokenPrefix,
    "mozzarella": .tokenPrefix, "cheddar": .tokenPrefix, "gouda": .tokenPrefix,
    "emmental": .tokenPrefix, "ovoalbum": .tokenPrefix, "ovoprodu": .tokenPrefix,
    "miel": .tokenPrefix, "honey": .tokenPrefix, "honig": .tokenPrefix,
    "miele": .tokenPrefix, "gelatin": .tokenPrefix, "gelatina": .tokenPrefix,
    "gelatine": .tokenPrefix, "carne": .tokenPrefix, "fleisch": .tokenContains,
    "viande": .tokenPrefix, "jamon": .tokenPrefix, "tocino": .tokenPrefix,
    "panceta": .tokenPrefix, "bacon": .tokenPrefix, "speck": .tokenPrefix,
    "schinken": .tokenContains, "pollo": .tokenPrefix, "huhn": .tokenPrefix,
    "poulet": .tokenPrefix, "chicken": .tokenPrefix, "cerdo": .tokenPrefix,
    "schwein": .tokenPrefix, "pork": .tokenPrefix, "porc": .tokenPrefix,
    "ternera": .tokenPrefix, "vacuno": .tokenPrefix, "beef": .tokenPrefix,
    "cordero": .tokenPrefix, "lamb": .tokenPrefix, "agnello": .tokenPrefix,
    "pavo": .tokenPrefix, "turkey": .tokenPrefix, "chorizo": .tokenPrefix,
    "salami": .tokenPrefix, "wurst": .tokenContains, "embutido": .tokenPrefix,
    "pescado": .tokenPrefix, "poisson": .tokenPrefix, "fisch": .tokenPrefix,
    "atun": .tokenPrefix, "thunfisch": .tokenPrefix, "thon": .tokenPrefix,
    "tuna": .tokenExact, "anchoa": .tokenPrefix, "anchois": .tokenPrefix,
    "sardin": .tokenPrefix, "gamba": .tokenPrefix, "camaron": .tokenPrefix,
    "shrimp": .tokenPrefix, "krill": .tokenPrefix, "krebstier": .tokenPrefix,
    "molusco": .tokenPrefix, "calamar": .tokenPrefix, "pulpo": .tokenPrefix,
    "marisco": .tokenPrefix, "seafood": .tokenPrefix, "surimi": .tokenPrefix,
    "salmon": .tokenPrefix, "lachs": .tokenPrefix, "saumon": .tokenPrefix,
    "bacalao": .tokenPrefix, "kabeljau": .tokenPrefix, "trucha": .tokenPrefix,
    "forelle": .tokenPrefix, "schmalz": .tokenContains, "saindoux": .tokenPrefix,
    "sebo": .tokenPrefix, "tallow": .tokenPrefix, "talg": .tokenPrefix,
    "suif": .tokenPrefix, "lard": .tokenPrefix, "lardo": .tokenPrefix,
    "carmin": .tokenPrefix, "karmin": .tokenPrefix, "cochinill": .tokenPrefix,
    "cochenill": .tokenPrefix, "cochineal": .tokenPrefix, "e120": .tokenExact,
    "carminico": .tokenPrefix, "shellac": .tokenPrefix, "schellack": .tokenPrefix,
    "goma laca": .tokenExact, "e904": .tokenExact, "albumin": .tokenPrefix,
    "albumina": .tokenPrefix, "lanolin": .tokenPrefix, "lanolina": .tokenPrefix,
    "cuajo": .tokenPrefix, "rennet": .tokenPrefix, "presure": .tokenPrefix,
    "labferment": .tokenPrefix, "chitin": .tokenPrefix, "quitina": .tokenPrefix,
    "manteca de cerdo": .tokenExact, "cera de abeja": .tokenExact,
    "beeswax": .tokenExact, "bienenwachs": .tokenExact,
    "cire d abeille": .tokenExact, "e901": .tokenExact,
    "royal jelly": .tokenExact, "jalea real": .tokenExact,
    "gelee royale": .tokenExact, "propolis": .tokenExact,
    "milch": .tokenContains, "milk": .tokenContains, "leche": .tokenContains,
    "lait": .tokenContains, "latte": .tokenContains, "nata": .tokenPrefix,
    "sahne": .tokenContains, "cream": .tokenContains, "creme": .tokenContains,
    "panna": .tokenContains, "crema": .tokenContains, "butter": .tokenContains,
    "mantequilla": .tokenPrefix, "beurre": .tokenContains, "burro": .tokenContains,
    "obers": .tokenContains, "rahm": .tokenContains
]

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
