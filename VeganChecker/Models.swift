import Foundation
import SwiftData

struct OpenFactsResponse: Decodable {
    let status: Int
    let product: Product?
}

struct OpenFoodFactsSearchResponse: Codable {
    let products: [OpenFoodFactsSearchProduct]?
}

struct OpenFoodFactsSearchProduct: Codable {
    let code: String?
    let productName: String?
    let brands: String?
    let imageUrl: String?
    let ingredientsAnalysisTags: [String]?
    let ingredients: [OffIngredient]?

    enum CodingKeys: String, CodingKey {
        case code
        case productName = "product_name"
        case brands
        case imageUrl = "image_url"
        case ingredientsAnalysisTags = "ingredients_analysis_tags"
        case ingredients
    }
}

struct Product: Codable {
    let productName: String?
    let brands: String?
    let imageUrl: String?
    let ingredientsText: String?
    let ingredientsAnalysisTags: [String]?
    let categoriesTags: [String]?
    let labelsTags: [String]?
    let ingredients: [OffIngredient]?
    let additivesTags: [String]?
    let allergensTags: [String]?
    let nutriments: Nutriments?
    let nutriscoreGrade: String?
    let ecoscoreGrade: String?
    let novaGroup: Int?
    let quantity: String?

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case brands
        case imageUrl = "image_url"
        case ingredientsText = "ingredients_text"
        case ingredientsAnalysisTags = "ingredients_analysis_tags"
        case categoriesTags = "categories_tags"
        case labelsTags = "labels_tags"
        case ingredients
        case additivesTags = "additives_tags"
        case allergensTags = "allergens_tags"
        case nutriments
        case nutriscoreGrade = "nutriscore_grade"
        case ecoscoreGrade = "ecoscore_grade"
        case novaGroup = "nova_group"
        case quantity
    }
}

struct OffIngredient: Codable {
    let text: String?
    let vegan: String?
    let vegetarian: String?
}

struct Nutriments: Codable {
    let energyKcal100g: Double?
    let fat100g: Double?
    let saturatedFat100g: Double?
    let sugars100g: Double?
    let carbohydrates100g: Double?
    let salt100g: Double?
    let proteins100g: Double?

    enum CodingKeys: String, CodingKey {
        case energyKcal100g = "energy-kcal_100g"
        case fat100g = "fat_100g"
        case saturatedFat100g = "saturated-fat_100g"
        case sugars100g = "sugars_100g"
        case carbohydrates100g = "carbohydrates_100g"
        case salt100g = "salt_100g"
        case proteins100g = "proteins_100g"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        energyKcal100g = try container.decodeFlexibleDouble(forKey: .energyKcal100g)
        fat100g = try container.decodeFlexibleDouble(forKey: .fat100g)
        saturatedFat100g = try container.decodeFlexibleDouble(forKey: .saturatedFat100g)
        sugars100g = try container.decodeFlexibleDouble(forKey: .sugars100g)
        carbohydrates100g = try container.decodeFlexibleDouble(forKey: .carbohydrates100g)
        salt100g = try container.decodeFlexibleDouble(forKey: .salt100g)
        proteins100g = try container.decodeFlexibleDouble(forKey: .proteins100g)
    }
}

private extension KeyedDecodingContainer {
    // Open Food Facts returns nutriment values as either JSON numbers or
    // numeric strings depending on how they were entered. Accept both so a
    // single string-typed value does not blank out the whole nutrition table.
    func decodeFlexibleDouble(forKey key: Key) -> Double? {
        if let value = try? decode(Double.self, forKey: key) {
            return value
        }
        if let text = try? decode(String.self, forKey: key) {
            let normalized = text
                .trimmingCharacters(in: .whitespaces)
                .replacingOccurrences(of: ",", with: ".")
            return Double(normalized)
        }
        return nil
    }
}

extension Product {
    var hasUsefulData: Bool {
        !(productName?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) ||
        !(ingredientsText?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) ||
        !(ingredients?.isEmpty ?? true) ||
        !(ingredientsAnalysisTags?.isEmpty ?? true) ||
        nutriments != nil
    }

    var hasVeganData: Bool {
        !(ingredientsAnalysisTags?.isEmpty ?? true) ||
        (ingredients?.contains(where: { !($0.vegan?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) }) ?? false)
    }
}

enum ProductSource: String, CaseIterable, Codable, Hashable {
    case openFoodFacts
    case openBeautyFacts
    case openProductFacts
    case openPetFoodFacts

    var baseURL: URL {
        switch self {
        case .openFoodFacts:
            return URL(string: "https://world.openfoodfacts.org")!
        case .openBeautyFacts:
            return URL(string: "https://world.openbeautyfacts.org")!
        case .openProductFacts:
            return URL(string: "https://world.openproductfacts.org")!
        case .openPetFoodFacts:
            return URL(string: "https://world.openpetfoodfacts.org")!
        }
    }

    var displayName: String {
        switch self {
        case .openFoodFacts:
            return L("product_source_open_food_facts")
        case .openBeautyFacts:
            return L("product_source_open_beauty_facts")
        case .openProductFacts:
            return L("product_source_open_product_facts")
        case .openPetFoodFacts:
            return L("product_source_open_pet_food_facts")
        }
    }
}

@Model
final class ScanRecord {
    @Attribute(.unique) var barcode: String
    var productName: String?
    var brand: String?
    var imageURL: String?
    var timestamp: Date

    init(barcode: String, productName: String?, brand: String?, imageURL: String?, timestamp: Date = Date()) {
        self.barcode = barcode
        self.productName = productName
        self.brand = brand
        self.imageURL = imageURL
        self.timestamp = timestamp
    }
}

@Model
final class CachedProduct {
    @Attribute(.unique) var barcode: String
    var productData: Data
    var sourceName: String
    var cachedAt: Date

    init(barcode: String, productData: Data, sourceName: String, cachedAt: Date = Date()) {
        self.barcode = barcode
        self.productData = productData
        self.sourceName = sourceName
        self.cachedAt = cachedAt
    }
}

@Model
final class FavoriteProduct {
    @Attribute(.unique) var barcode: String
    var productName: String?
    var brand: String?
    var imageURL: String?
    var addedAt: Date

    init(barcode: String, productName: String?, brand: String?, imageURL: String?, addedAt: Date = Date()) {
        self.barcode = barcode
        self.productName = productName
        self.brand = brand
        self.imageURL = imageURL
        self.addedAt = addedAt
    }
}

enum AdditiveOrigin {
    case animal
    case plant
    case synthetic
    case uncertain
    case unknown
}

struct AdditiveInfo {
    let commonName: String?
    let origin: AdditiveOrigin
    let note: String
}

struct AdditiveEntry: Identifiable {
    let code: String
    let info: AdditiveInfo

    var id: String { code }
}

private struct LocalizedAdditiveRecord {
    let commonName: (es: String?, en: String?)
    let note: (es: String, en: String)
    let origin: AdditiveOrigin
}

private let additiveCatalog: [String: LocalizedAdditiveRecord] = [
    "E100": LocalizedAdditiveRecord(
        commonName: ("Curcumina", "Curcumin"),
        note: ("Colorante amarillo de la cúrcuma.", "Yellow coloring from turmeric."),
        origin: .plant
    ),
    "E101": LocalizedAdditiveRecord(
        commonName: ("Riboflavina", "Riboflavin"),
        note: ("Vitamina B2 usada como colorante amarillo.", "Vitamin B2 used as a yellow coloring."),
        origin: .synthetic
    ),
    "E120": LocalizedAdditiveRecord(
        commonName: ("Carmín", "Carmine"),
        note: ("Colorante rojo obtenido de la cochinilla.", "Red coloring obtained from cochineal."),
        origin: .animal
    ),
    "E140": LocalizedAdditiveRecord(
        commonName: ("Clorofilas", "Chlorophylls"),
        note: ("Pigmentos verdes de origen vegetal.", "Green pigments of plant origin."),
        origin: .plant
    ),
    "E153": LocalizedAdditiveRecord(
        commonName: ("Carbón vegetal", "Vegetable carbon"),
        note: ("Colorante negro de origen vegetal.", "Black coloring of plant origin."),
        origin: .plant
    ),
    "E160A": LocalizedAdditiveRecord(
        commonName: ("Carotenos", "Carotenes"),
        note: ("Pigmentos anaranjados de origen vegetal.", "Orange pigments of plant origin."),
        origin: .plant
    ),
    "E163": LocalizedAdditiveRecord(
        commonName: ("Antocianinas", "Anthocyanins"),
        note: ("Pigmentos vegetales rojos y morados.", "Red and purple plant pigments."),
        origin: .plant
    ),
    "E200": LocalizedAdditiveRecord(
        commonName: ("Ácido sórbico", "Sorbic acid"),
        note: ("Conservante contra mohos y levaduras.", "Preservative against mould and yeast."),
        origin: .synthetic
    ),
    "E202": LocalizedAdditiveRecord(
        commonName: ("Sorbato potásico", "Potassium sorbate"),
        note: ("Conservante derivado del ácido sórbico.", "Preservative derived from sorbic acid."),
        origin: .synthetic
    ),
    "E211": LocalizedAdditiveRecord(
        commonName: ("Benzoato sódico", "Sodium benzoate"),
        note: ("Conservante que inhibe el deterioro.", "Preservative that helps prevent spoilage."),
        origin: .synthetic
    ),
    "E220": LocalizedAdditiveRecord(
        commonName: ("Dióxido de azufre", "Sulphur dioxide"),
        note: ("Conservante y antioxidante.", "Preservative and antioxidant."),
        origin: .synthetic
    ),
    "E306": LocalizedAdditiveRecord(
        commonName: ("Extracto rico en tocoferoles", "Tocopherol-rich extract"),
        note: ("Extracto de vitamina E con función antioxidante.", "Vitamin E extract with antioxidant function."),
        origin: .plant
    ),
    "E322": LocalizedAdditiveRecord(
        commonName: ("Lecitinas", "Lecithins"),
        note: ("Puede proceder de soja, girasol o huevo.", "May come from soy, sunflower, or egg."),
        origin: .uncertain
    ),
    "E330": LocalizedAdditiveRecord(
        commonName: ("Ácido cítrico", "Citric acid"),
        note: ("Regulador de acidez y antioxidante.", "Acidity regulator and antioxidant."),
        origin: .synthetic
    ),
    "E401": LocalizedAdditiveRecord(
        commonName: ("Alginato sódico", "Sodium alginate"),
        note: ("Espesante extraído de algas.", "Thickener extracted from seaweed."),
        origin: .plant
    ),
    "E406": LocalizedAdditiveRecord(
        commonName: ("Agar", "Agar"),
        note: ("Gelificante de algas rojas.", "Gelling agent from red algae."),
        origin: .plant
    ),
    "E412": LocalizedAdditiveRecord(
        commonName: ("Goma guar", "Guar gum"),
        note: ("Espesante de la semilla de guar.", "Thickener from guar beans."),
        origin: .plant
    ),
    "E414": LocalizedAdditiveRecord(
        commonName: ("Goma arábiga", "Gum arabic"),
        note: ("Goma natural de la acacia.", "Natural gum from acacia trees."),
        origin: .plant
    ),
    "E422": LocalizedAdditiveRecord(
        commonName: ("Glicerina / glicerol", "Glycerin / glycerol"),
        note: ("Puede ser de origen vegetal, animal o sintético.", "May be of plant, animal, or synthetic origin."),
        origin: .uncertain
    ),
    "E440": LocalizedAdditiveRecord(
        commonName: ("Pectinas", "Pectins"),
        note: ("Gelificante de fibras de fruta.", "Gelling agent from fruit fibres."),
        origin: .plant
    ),
    "E441": LocalizedAdditiveRecord(
        commonName: ("Gelatina", "Gelatine"),
        note: ("Gelificante proteico procedente de colágeno animal.", "Protein gelling agent from animal collagen."),
        origin: .animal
    ),
    "E442": LocalizedAdditiveRecord(
        commonName: ("Fosfatidos de amonio", "Ammonium phosphatides"),
        note: ("Emulsionante usado en chocolate y repostería.", "Emulsifier used in chocolate and baking."),
        origin: .synthetic
    ),
    "E471": LocalizedAdditiveRecord(
        commonName: ("Mono y diglicéridos de ácidos grasos", "Mono- and diglycerides of fatty acids"),
        note: ("Puede proceder de grasas vegetales o animales.", "May be derived from plant or animal fats."),
        origin: .uncertain
    ),
    "E476": LocalizedAdditiveRecord(
        commonName: ("Ésteres poliglicéridos de ácidos grasos", "Polyglycerol esters of fatty acids"),
        note: ("Emulsionante para textura y estabilidad.", "Emulsifier for texture and stability."),
        origin: .synthetic
    ),
    "E500": LocalizedAdditiveRecord(
        commonName: ("Carbonatos de sodio", "Sodium carbonates"),
        note: ("Gasificante y regulador de acidez.", "Raising agent and acidity regulator."),
        origin: .synthetic
    ),
    "E503": LocalizedAdditiveRecord(
        commonName: ("Carbonatos de amonio", "Ammonium carbonates"),
        note: ("Gasificante usado en repostería.", "Raising agent used in baking."),
        origin: .synthetic
    ),
    "E542": LocalizedAdditiveRecord(
        commonName: ("Fosfato de hueso", "Bone phosphate"),
        note: ("Fosfato obtenido de huesos animales.", "Phosphate obtained from animal bones."),
        origin: .animal
    ),
    "E631": LocalizedAdditiveRecord(
        commonName: ("Inosinato disódico", "Disodium inosinate"),
        note: ("Potenciador del sabor de origen variable.", "Flavour enhancer with variable origin."),
        origin: .uncertain
    ),
    "E635": LocalizedAdditiveRecord(
        commonName: ("Ribonucleótidos disódicos", "Disodium ribonucleotides"),
        note: ("Potenciador del sabor de origen variable.", "Flavour enhancer with variable origin."),
        origin: .uncertain
    ),
    "E901": LocalizedAdditiveRecord(
        commonName: ("Cera de abejas", "Beeswax"),
        note: ("Cera producida por las abejas.", "Wax produced by bees."),
        origin: .animal
    ),
    "E903": LocalizedAdditiveRecord(
        commonName: ("Cera de carnauba", "Carnauba wax"),
        note: ("Cera vegetal de brillo alimentario.", "Plant-based glazing wax."),
        origin: .plant
    ),
    "E904": LocalizedAdditiveRecord(
        commonName: ("Goma laca", "Shellac"),
        note: ("Agente de recubrimiento procedente del insecto lac.", "Coating agent from the lac insect."),
        origin: .animal
    ),
    "E920": LocalizedAdditiveRecord(
        commonName: ("L-cisteína", "L-cysteine"),
        note: ("A menudo procede de pelo, plumas o fermentación.", "Often comes from hair, feathers, or fermentation."),
        origin: .uncertain
    ),
    "E950": LocalizedAdditiveRecord(
        commonName: ("Acesulfamo K", "Acesulfame K"),
        note: ("Edulcorante intenso.", "Intense sweetener."),
        origin: .synthetic
    ),
    "E951": LocalizedAdditiveRecord(
        commonName: ("Aspartamo", "Aspartame"),
        note: ("Edulcorante artificial.", "Artificial sweetener."),
        origin: .synthetic
    ),
    "E960": LocalizedAdditiveRecord(
        commonName: ("Glicósidos de esteviol", "Steviol glycosides"),
        note: ("Edulcorantes extraídos de la estevia.", "Sweeteners extracted from stevia."),
        origin: .plant
    ),
    "E1105": LocalizedAdditiveRecord(
        commonName: ("Lisozima", "Lysozyme"),
        note: ("Enzima obtenida habitualmente de la clara de huevo.", "Enzyme usually obtained from egg white."),
        origin: .animal
    ),
]

func additiveEntry(for rawCode: String) -> AdditiveEntry? {
    let code = normalizeAdditiveCode(rawCode)
    guard let record = additiveCatalog[code] else { return nil }
    return AdditiveEntry(
        code: code,
        info: AdditiveInfo(
            commonName: localizedValue(record.commonName),
            origin: record.origin,
            note: localizedValue(record.note)
        )
    )
}

func additiveEntries(from tags: [String]?) -> [AdditiveEntry] {
    var seen = Set<String>()
    return (tags ?? []).compactMap { tag in
        guard let entry = additiveEntry(for: tag), seen.insert(entry.code).inserted else {
            return nil
        }
        return entry
    }
}

private func normalizeAdditiveCode(_ rawCode: String) -> String {
    let trimmed = rawCode.trimmingCharacters(in: .whitespacesAndNewlines)
    let codeOnly: String
    if let colonIndex = trimmed.firstIndex(of: ":") {
        codeOnly = String(trimmed[trimmed.index(after: colonIndex)...])
    } else {
        codeOnly = trimmed
    }
    return codeOnly.uppercased()
}

private func localizedValue(_ values: (es: String?, en: String?)) -> String? {
    if preferredLanguageCode() == "en" {
        return values.en ?? values.es
    }
    return values.es ?? values.en
}

private func localizedValue(_ values: (es: String, en: String)) -> String {
    return preferredLanguageCode() == "en" ? values.en : values.es
}

private func preferredLanguageCode() -> String {
    let identifier = Locale.preferredLanguages.first ?? Locale.current.identifier
    return identifier.lowercased().hasPrefix("en") ? "en" : "es"
}
