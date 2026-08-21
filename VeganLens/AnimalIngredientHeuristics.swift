import Foundation

private let unambiguousAnimalStems = [
    "molke", "whey", "lactos", "laktos", "casein", "caseina", "kasein", "lactoglob",
    "lactalb", "suero de leche", "lactosuero", "queso", "cheese", "kase", "fromage",
    "formagg", "parmesan", "parmigian", "mozzarella", "cheddar", "gouda", "emmental",
    "ovoalbum", "ovoprodu", "miel", "honey", "honig", "miele", "gelatin", "gelatina",
    "gelatine", "carne", "fleisch", "viande", "jamon", "tocino", "panceta", "bacon",
    "speck", "schinken", "pollo", "huhn", "poulet", "chicken", "cerdo", "schwein",
    "pork", "porc", "ternera", "vacuno", "beef", "cordero", "lamb", "agnello", "pavo",
    "turkey", "chorizo", "salami", "wurst", "embutido", "pescado", "poisson", "fisch",
    "atun", "thunfisch", "thon", "tuna", "anchoa", "anchois", "sardin", "gamba",
    "camaron", "shrimp", "krill", "krebstier", "molusco", "calamar", "pulpo",
    "marisco", "seafood", "surimi", "salmon", "lachs", "saumon", "bacalao", "kabeljau",
    "trucha", "forelle", "schmalz", "saindoux", "manteca de cerdo", "sebo", "tallow",
    "talg", "suif", "lard", "lardo", "carmin", "karmin", "cochinill", "cochenill",
    "cochineal", "e120", "carminico", "shellac", "schellack", "goma laca", "e904",
    "cera de abeja", "beeswax", "bienenwachs", "cire d abeille", "e901", "royal jelly",
    "jalea real", "gelee royale", "propolis", "albumin", "albumina", "lanolin", "lanolina",
    "cuajo", "rennet", "presure", "labferment", "chitin", "quitina"
]

private let ambiguousAnimalStems = [
    "milch", "milk", "leche", "lait", "latte", "nata", "sahne", "cream", "creme",
    "panna", "crema", "butter", "mantequilla", "beurre", "burro", "obers", "rahm"
]

private let plantQualifiers = [
    "coco", "coconut", "kokos", "almendra", "almend", "almond", "mandel", "amande",
    "soja", "soy", "soya", "avena", "oat", "hafer", "avoine", "arroz", "rice", "reis",
    "riz", "cacahuete", "cacahuet", "peanut", "erdnuss", "arachide", "cacao", "cocoa",
    "kakao", "karite", "shea", "anacardo", "cashew", "avellana", "hazelnut", "haselnuss",
    "nuez", "walnut", "nogal", "vegetal", "vegetale", "vegetabil", "pflanzlich", "vegan",
    "tofu", "seitan", "oliva", "olive", "girasol", "sunflower", "sonnenblume", "tournesol",
    "palma", "palm"
]

private let eggTokens: Set<String> = [
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
            let hasUnambiguousMatch = unambiguousAnimalStems.contains { norm.contains($0) }
            let hasAmbiguousMatch = ambiguousAnimalStems.contains { norm.contains($0) } &&
                !plantQualifiers.contains { norm.contains($0) }
            let tokens = norm.components(separatedBy: CharacterSet.letters.inverted)
                .filter { !$0.isEmpty }
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
    let hasUnambiguousMatch = unambiguousAnimalStems.contains { normalized.contains($0) }
    let hasAmbiguousMatch = ambiguousAnimalStems.contains { normalized.contains($0) } &&
        !plantQualifiers.contains { normalized.contains($0) }
    let tokens = normalized.components(separatedBy: CharacterSet.letters.inverted)
        .filter { !$0.isEmpty }
    let hasEggToken = tokens.contains { eggTokens.contains($0) }
    return hasUnambiguousMatch || hasAmbiguousMatch || hasEggToken
}

func normalizeIngredientSegment(_ segment: String) -> String {
    segment
        .lowercased()
        .folding(options: .diacriticInsensitive, locale: Locale(identifier: "en"))
        .replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
        .trimmingCharacters(in: .whitespacesAndNewlines)
}
