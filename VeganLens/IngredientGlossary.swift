import Foundation

enum GlossaryIngredient: String, CaseIterable, Identifiable {
    case gelatin
    case casein
    case whey
    case lactose
    case butter
    case eggAlbumin = "egg_albumin"
    case honey
    case beeswax
    case shellac
    case carmine
    case lanolin
    case collagen
    case isinglass
    case animalFat = "animal_fat"
    case lCysteine = "l_cysteine"

    var id: String { rawValue }
    var name: String { L("glossary_\(rawValue)_name") }
    var explanation: String { L("glossary_\(rawValue)_description") }

    var keywords: [String] {
        switch self {
        case .gelatin:
            return ["gelatina", "gelatin", "gelatine"]
        case .casein:
            return ["caseina", "casein", "caseine", "kasein", "caseinato", "caseinate", "caseinat"]
        case .whey:
            return ["suero de leche", "lactosuero", "whey", "soro de leite", "siero di latte", "lactoserum", "molke"]
        case .lactose:
            return ["lactosa", "lactose", "lattosio", "laktose"]
        case .butter:
            return ["mantequilla", "butter", "manteiga", "burro", "beurre", "ghee", "butterfett", "butterreinfett"]
        case .eggAlbumin:
            return [
                "huevo", "huevos", "egg", "eggs", "ovo", "ovos", "uovo", "uova", "oeuf", "oeufs", "ei", "eier",
                "eigelb", "eiklar", "albumina", "albumin", "albumine", "albume", "ovoalbumina", "ovalbumin",
            ]
        case .honey:
            return ["miel", "honey", "mel", "miele", "honig"]
        case .beeswax:
            return ["cera de abeja", "beeswax", "cera de abelha", "cera d'api", "cire d'abeille", "bienenwachs", "e901"]
        case .shellac:
            return ["goma laca", "goma-laca", "shellac", "gommalacca", "gomme-laque", "schellack", "e904"]
        case .carmine:
            return [
                "carmin", "carmine", "carminio", "karmin", "cochinilla", "cochineal", "cochonilha", "cocciniglia",
                "cochenille", "e120",
            ]
        case .lanolin:
            return [
                "lanolina", "lanolin", "lanoline", "vitamina d3", "vitamin d3", "vitamine d3", "colecalciferol",
                "cholecalciferol",
            ]
        case .collagen:
            return ["colageno", "collagen", "colagenio", "collagene", "kollagen"]
        case .isinglass:
            return ["cola de pescado", "isinglass", "cola de peixe", "colla di pesce", "colle de poisson", "hausenblase"]
        case .animalFat:
            return [
                "manteca de cerdo", "sebo", "lard", "tallow", "banha", "strutto", "sego", "saindoux", "suif", "schmalz",
                "talg", "grasa animal", "animal fat",
            ]
        case .lCysteine:
            return ["cisteina", "l-cisteina", "cysteine", "l-cysteine", "cystein", "l-cystein", "e920"]
        }
    }
}

func normalizeGlossaryText(_ text: String) -> String {
    text.lowercased()
        .folding(options: .diacriticInsensitive, locale: Locale(identifier: "en_US_POSIX"))
        .replacingOccurrences(of: "œ", with: "oe")
        .replacingOccurrences(of: "’", with: "'")
        .trimmingCharacters(in: .whitespacesAndNewlines)
}

private func glossaryKeywordMatches(_ keyword: String, in normalizedText: String) -> Bool {
    let pattern = "(?<![\\p{L}\\p{N}])" + NSRegularExpression.escapedPattern(for: keyword) + "(?![\\p{L}\\p{N}])"
    return normalizedText.range(of: pattern, options: .regularExpression) != nil
}

func glossaryIngredients(for text: String) -> [GlossaryIngredient] {
    let normalized = normalizeGlossaryText(text)
    guard !normalized.isEmpty else { return [] }
    return GlossaryIngredient.allCases.filter { entry in
        entry.keywords.contains { glossaryKeywordMatches($0, in: normalized) }
    }
}

func glossaryIngredients(for texts: [String]) -> [GlossaryIngredient] {
    let matches = Set(texts.flatMap { glossaryIngredients(for: $0) })
    return GlossaryIngredient.allCases.filter { matches.contains($0) }
}

func glossaryQueryMatches(_ query: String, _ fields: [String?]) -> Bool {
    let normalizedQuery = normalizeGlossaryText(query)
    guard !normalizedQuery.isEmpty else { return true }
    return fields.contains { field in
        guard let field else { return false }
        return normalizeGlossaryText(field).contains(normalizedQuery)
    }
}
