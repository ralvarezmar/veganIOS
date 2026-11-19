import Foundation

enum GlutenStatus: Equatable {
    case contains
    case notDeclared
    case unknown
}

struct MedicineAnalysis: Equatable {
    let veganStatus: VeganStatus
    let animalItems: [String]
    let doubtfulItems: [String]
    let glutenStatus: GlutenStatus
    let glutenItems: [String]
    /// Allergen key from `AllergenCatalog` to the excipients that triggered it.
    let allergenItems: [String: [String]]
    let hasExcipientData: Bool

    var flaggedItems: Set<String> {
        Set(animalItems + doubtfulItems + glutenItems + allergenItems.values.flatMap { $0 })
    }
}

private let animalTerms = [
    "gelatina", "gelatin", "lactosa", "lactose", "lanolina", "lanolin", "grasa de lana", "wool fat",
    "cera de abeja", "beeswax", "cera blanca", "cera amarilla", "white wax", "yellow wax",
    "goma laca", "shellac", "carmin", "cochinilla", "carmine", "cochineal", "e120", "acido carminico",
    "carminic acid", "caseina", "casein", "caseinato", "caseinate", "colageno", "collagen", "quitosano", "chitosan",
    "miel", "honey", "propoleo", "propolis", "jalea real", "royal jelly", "albumina de huevo", "ovoalbumina",
    "egg", "huevo", "lisozima", "lysozyme", "higado de bacalao", "cod liver", "aceite de pescado", "fish oil",
    "heparina", "heparin", "pancreatina", "pancreatin", "condroitina", "chondroitin", "suero de leche", "whey",
    "leche", "milk", "sebo", "tallow", "espermaceti", "spermaceti", "calcitonina de salmon", "salmon calcitonin",
    "omega-3", "acidos grasos omega 3", "cera de lana", "pepsina", "pepsin", "tripsina", "trypsin",
]

private let doubtfulTerms = [
    "estearato de magnesio", "magnesium stearate", "estearato magnesico", "estearato de calcio",
    "estearato calcico", "calcium stearate", "acido estearico", "stearic acid", "estearato", "stearate",
    "glicerol", "glycerol", "glicerina", "glycerin", "monoestearato de glicerol", "glyceryl monostearate",
    "mono y digliceridos", "mono- and diglycerides", "escualeno", "squalene", "glucosamina", "glucosamine",
    "colecalciferol", "cholecalciferol", "vitamina d3", "vitamin d3", "acido hialuronico", "hyaluronic acid",
    "hialuronato", "hyaluronate", "lecitina", "lecithin", "taurina", "taurine", "cisteina", "cysteine",
]

private let veganLecithinSources = ["soja", "soy", "girasol", "sunflower", "colza", "rapeseed"]

private let glutenTerms = [
    "trigo", "wheat", "gluten", "cebada", "barley", "centeno", "rye", "avena", "oat", "malta", "malt",
    "espelta", "spelt", "kamut", "triticale",
]

private let allergenTerms: [String: [String]] = [
    "gluten": glutenTerms,
    "milk": ["lactosa", "lactose", "leche", "milk", "caseina", "casein", "caseinato", "caseinate", "suero de leche", "whey"],
    "eggs": ["huevo", "egg", "ovoalbumina", "albumina de huevo", "lisozima", "lysozyme"],
    "soybeans": ["soja", "soy", "soya", "soybean"],
    "peanuts": ["cacahuete", "cacahuate", "mani", "peanut", "arachis", "araquis"],
    "fish": ["pescado", "fish", "bacalao", "cod liver", "salmon"],
    "crustaceans": ["quitosano", "chitosan", "crustaceo", "crustacean", "gamba", "shrimp", "glucosamina", "glucosamine"],
    "nuts": ["almendra", "almond", "avellana", "hazelnut", "nuez", "walnut"],
    "sesame-seeds": ["sesamo", "sesame"],
    "sulphites": ["sulfito", "bisulfito", "metabisulfito", "sulfite", "bisulfite", "metabisulfite"],
]

func normalizeMedicineText(_ text: String) -> String {
    text.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "en_US_POSIX"))
        .lowercased()
        .replacingOccurrences(of: "[^a-z0-9-]+", with: " ", options: .regularExpression)
        .trimmingCharacters(in: .whitespaces)
}

private func containsTerm(_ normalizedText: String, _ term: String) -> Bool {
    let normalizedTerm = normalizeMedicineText(term)
    guard !normalizedTerm.isEmpty else { return false }
    let pattern = "(^|\\s)\(NSRegularExpression.escapedPattern(for: normalizedTerm))(s|es)?(\\s|$)"
    return normalizedText.range(of: pattern, options: .regularExpression) != nil
}

private func matchesAny(_ item: String, _ terms: [String]) -> Bool {
    let normalized = normalizeMedicineText(item)
    return terms.contains { containsTerm(normalized, $0) }
}

private func isDoubtful(_ item: String) -> Bool {
    guard matchesAny(item, doubtfulTerms) else { return false }
    let isLecithin = matchesAny(item, ["lecitina", "lecithin"])
    return !(isLecithin && matchesAny(item, veganLecithinSources))
}

private func uniqueOrdered(_ values: [String]) -> [String] {
    var seen = Set<String>()
    return values.filter { seen.insert($0).inserted }
}

func analyzeMedicine(_ info: MedicineInfo) -> MedicineAnalysis {
    let items = uniqueOrdered(info.excipients + info.activeIngredients)
    let freeText = info.excipients.isEmpty ? info.extraText.map(normalizeMedicineText) : nil
    let hasData = !info.excipients.isEmpty || freeText != nil

    func matching(_ terms: [String], _ predicate: ((String) -> Bool)? = nil) -> [String] {
        let test = predicate ?? { matchesAny($0, terms) }
        let fromItems = items.filter(test)
        let fromText = freeText.map { text in terms.filter { containsTerm(text, $0) } } ?? []
        return uniqueOrdered(fromItems + fromText)
    }

    let animal = matching(animalTerms)
    let doubtful = matching(doubtfulTerms, isDoubtful).filter { !animal.contains($0) }
    let gluten = matching(glutenTerms)
    let allergens = allergenTerms
        .mapValues { matching($0) }
        .filter { !$0.value.isEmpty }

    let status: VeganStatus
    if !animal.isEmpty {
        status = .notVegan
    } else if !doubtful.isEmpty {
        status = .maybe
    } else if hasData {
        status = .vegan
    } else {
        status = .unknown
    }

    let glutenStatus: GlutenStatus
    if !gluten.isEmpty {
        glutenStatus = .contains
    } else if hasData {
        glutenStatus = .notDeclared
    } else {
        glutenStatus = .unknown
    }

    return MedicineAnalysis(
        veganStatus: status,
        animalItems: animal,
        doubtfulItems: doubtful,
        glutenStatus: glutenStatus,
        glutenItems: gluten,
        allergenItems: allergens,
        hasExcipientData: hasData
    )
}
