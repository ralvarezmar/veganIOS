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
    let tracesTags: [String]?
    let ingredients: [OffIngredient]?
    let additivesTags: [String]?
    let allergensTags: [String]?
    let nutriments: Nutriments?
    let nutriscoreGrade: String?
    let ecoscoreGrade: String?
    let novaGroup: Int?
    let quantity: String?
    let environmentalScoreGrade: String?
    let environmentalScoreScore: Int?
    let ecoscoreScore: Int?
    let environmentalScoreData: EnvironmentalScoreData?
    let nutrientLevels: NutrientLevels?
    let ecoscoreData: EnvironmentalScoreData?

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case brands
        case imageUrl = "image_url"
        case ingredientsText = "ingredients_text"
        case ingredientsAnalysisTags = "ingredients_analysis_tags"
        case categoriesTags = "categories_tags"
        case labelsTags = "labels_tags"
        case tracesTags = "traces_tags"
        case ingredients
        case additivesTags = "additives_tags"
        case allergensTags = "allergens_tags"
        case nutriments
        case nutriscoreGrade = "nutriscore_grade"
        case ecoscoreGrade = "ecoscore_grade"
        case environmentalScoreGrade = "environmental_score_grade"
        case environmentalScoreScore = "environmental_score_score"
        case ecoscoreScore = "ecoscore_score"
        case environmentalScoreData = "environmental_score_data"
        case nutrientLevels = "nutrient_levels"
        case ecoscoreData = "ecoscore_data"
        case novaGroup = "nova_group"
        case quantity
    }

    init(
        productName: String?,
        brands: String?,
        imageUrl: String?,
        ingredientsText: String?,
        ingredientsAnalysisTags: [String]?,
        categoriesTags: [String]?,
        labelsTags: [String]?,
        ingredients: [OffIngredient]?,
        additivesTags: [String]?,
        allergensTags: [String]?,
        nutriments: Nutriments?,
        nutriscoreGrade: String?,
        ecoscoreGrade: String?,
        novaGroup: Int?,
        quantity: String?,
        tracesTags: [String]? = nil,
        environmentalScoreGrade: String? = nil,
        environmentalScoreScore: Int? = nil,
        ecoscoreScore: Int? = nil,
        environmentalScoreData: EnvironmentalScoreData? = nil,
        nutrientLevels: NutrientLevels? = nil,
        ecoscoreData: EnvironmentalScoreData? = nil
    ) {
        self.productName = productName
        self.brands = brands
        self.imageUrl = imageUrl
        self.ingredientsText = ingredientsText
        self.ingredientsAnalysisTags = ingredientsAnalysisTags
        self.categoriesTags = categoriesTags
        self.labelsTags = labelsTags
        self.tracesTags = tracesTags
        self.ingredients = ingredients
        self.additivesTags = additivesTags
        self.allergensTags = allergensTags
        self.nutriments = nutriments
        self.nutriscoreGrade = nutriscoreGrade
        self.ecoscoreGrade = ecoscoreGrade
        self.novaGroup = novaGroup
        self.quantity = quantity
        self.environmentalScoreGrade = environmentalScoreGrade
        self.environmentalScoreScore = environmentalScoreScore
        self.ecoscoreScore = ecoscoreScore
        self.environmentalScoreData = environmentalScoreData
        self.nutrientLevels = nutrientLevels
        self.ecoscoreData = ecoscoreData
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        productName = try? container.decodeIfPresent(String.self, forKey: .productName)
        brands = try? container.decodeIfPresent(String.self, forKey: .brands)
        imageUrl = try? container.decodeIfPresent(String.self, forKey: .imageUrl)
        ingredientsText = try? container.decodeIfPresent(String.self, forKey: .ingredientsText)
        ingredientsAnalysisTags = try? container.decodeIfPresent([String].self, forKey: .ingredientsAnalysisTags)
        categoriesTags = try? container.decodeIfPresent([String].self, forKey: .categoriesTags)
        labelsTags = try? container.decodeIfPresent([String].self, forKey: .labelsTags)
        tracesTags = try? container.decodeIfPresent([String].self, forKey: .tracesTags)
        ingredients = try? container.decodeIfPresent([OffIngredient].self, forKey: .ingredients)
        additivesTags = try? container.decodeIfPresent([String].self, forKey: .additivesTags)
        allergensTags = try? container.decodeIfPresent([String].self, forKey: .allergensTags)
        nutriments = try? container.decodeIfPresent(Nutriments.self, forKey: .nutriments)
        nutriscoreGrade = try? container.decodeIfPresent(String.self, forKey: .nutriscoreGrade)
        ecoscoreGrade = try? container.decodeIfPresent(String.self, forKey: .ecoscoreGrade)
        environmentalScoreGrade = try? container.decodeIfPresent(String.self, forKey: .environmentalScoreGrade)
        environmentalScoreScore = container.decodeFlexibleInt(forKey: .environmentalScoreScore)
        ecoscoreScore = container.decodeFlexibleInt(forKey: .ecoscoreScore)
        environmentalScoreData = try? container.decodeIfPresent(EnvironmentalScoreData.self, forKey: .environmentalScoreData)
        nutrientLevels = try? container.decodeIfPresent(NutrientLevels.self, forKey: .nutrientLevels)
        ecoscoreData = try? container.decodeIfPresent(EnvironmentalScoreData.self, forKey: .ecoscoreData)
        novaGroup = container.decodeFlexibleInt(forKey: .novaGroup)
        quantity = try? container.decodeIfPresent(String.self, forKey: .quantity)
    }
}

struct OffIngredient: Codable {
    let text: String?
    let vegan: String?
    let vegetarian: String?
    let ingredients: [OffIngredient]?

    init(
        text: String?,
        vegan: String?,
        vegetarian: String?,
        ingredients: [OffIngredient]? = nil
    ) {
        self.text = text
        self.vegan = vegan
        self.vegetarian = vegetarian
        self.ingredients = ingredients
    }
}

struct Nutriments: Codable {
    let energyKcal100g: Double?
    let energyKj100g: Double?
    let fat100g: Double?
    let saturatedFat100g: Double?
    let sugars100g: Double?
    let carbohydrates100g: Double?
    let salt100g: Double?
    let proteins100g: Double?
    let addedSugars100g: Double?
    let carbonFootprint100g: Double?
    let energyKcalPrepared100g: Double?
    let energyKjPrepared100g: Double?
    let fatPrepared100g: Double?
    let saturatedFatPrepared100g: Double?
    let sugarsPrepared100g: Double?
    let carbohydratesPrepared100g: Double?
    let saltPrepared100g: Double?
    let proteinsPrepared100g: Double?
    let addedSugarsPrepared100g: Double?

    enum CodingKeys: String, CodingKey {
        case energyKcal100g = "energy-kcal_100g"
        case energyKj100g = "energy-kj_100g"
        case fat100g = "fat_100g"
        case saturatedFat100g = "saturated-fat_100g"
        case sugars100g = "sugars_100g"
        case carbohydrates100g = "carbohydrates_100g"
        case salt100g = "salt_100g"
        case proteins100g = "proteins_100g"
        case addedSugars100g = "added-sugars_100g"
        case carbonFootprint100g = "carbon-footprint_100g"
        case energyKcalPrepared100g = "energy-kcal_prepared_100g"
        case energyKjPrepared100g = "energy-kj_prepared_100g"
        case fatPrepared100g = "fat_prepared_100g"
        case saturatedFatPrepared100g = "saturated-fat_prepared_100g"
        case sugarsPrepared100g = "sugars_prepared_100g"
        case carbohydratesPrepared100g = "carbohydrates_prepared_100g"
        case saltPrepared100g = "salt_prepared_100g"
        case proteinsPrepared100g = "proteins_prepared_100g"
        case addedSugarsPrepared100g = "added-sugars_prepared_100g"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        energyKcal100g = try container.decodeFlexibleDouble(forKey: .energyKcal100g)
        energyKj100g = try container.decodeFlexibleDouble(forKey: .energyKj100g)
        fat100g = try container.decodeFlexibleDouble(forKey: .fat100g)
        saturatedFat100g = try container.decodeFlexibleDouble(forKey: .saturatedFat100g)
        sugars100g = try container.decodeFlexibleDouble(forKey: .sugars100g)
        carbohydrates100g = try container.decodeFlexibleDouble(forKey: .carbohydrates100g)
        salt100g = try container.decodeFlexibleDouble(forKey: .salt100g)
        proteins100g = try container.decodeFlexibleDouble(forKey: .proteins100g)
        addedSugars100g = try container.decodeFlexibleDouble(forKey: .addedSugars100g)
        carbonFootprint100g = try container.decodeFlexibleDouble(forKey: .carbonFootprint100g)
        energyKcalPrepared100g = try container.decodeFlexibleDouble(forKey: .energyKcalPrepared100g)
        energyKjPrepared100g = try container.decodeFlexibleDouble(forKey: .energyKjPrepared100g)
        fatPrepared100g = try container.decodeFlexibleDouble(forKey: .fatPrepared100g)
        saturatedFatPrepared100g = try container.decodeFlexibleDouble(forKey: .saturatedFatPrepared100g)
        sugarsPrepared100g = try container.decodeFlexibleDouble(forKey: .sugarsPrepared100g)
        carbohydratesPrepared100g = try container.decodeFlexibleDouble(forKey: .carbohydratesPrepared100g)
        saltPrepared100g = try container.decodeFlexibleDouble(forKey: .saltPrepared100g)
        proteinsPrepared100g = try container.decodeFlexibleDouble(forKey: .proteinsPrepared100g)
        addedSugarsPrepared100g = try container.decodeFlexibleDouble(forKey: .addedSugarsPrepared100g)
    }
}

enum NutritionBasis: Equatable {
    case asSold
    case prepared
}

struct NutritionFacts {
    let basis: NutritionBasis
    let energyKcal: Double?
    let energyKj: Double?
    let fat: Double?
    let saturatedFat: Double?
    let carbohydrates: Double?
    let sugars: Double?
    let addedSugars: Double?
    let salt: Double?
    let proteins: Double?
}

struct EnvironmentalScoreData: Codable {
    let agribalyse: Agribalyse?
}

struct Agribalyse: Codable {
    let co2Total: Double?

    enum CodingKeys: String, CodingKey {
        case co2Total = "co2_total"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        co2Total = try container.decodeFlexibleDouble(forKey: .co2Total)
    }
}

struct NutrientLevels: Codable {
    let fat: String?
    let saturatedFat: String?
    let sugars: String?
    let salt: String?

    enum CodingKeys: String, CodingKey {
        case fat
        case saturatedFat = "saturated-fat"
        case sugars
        case salt
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

    func decodeFlexibleInt(forKey key: Key) -> Int? {
        if let value = try? decode(Int.self, forKey: key) {
            return value
        }
        if let text = try? decode(String.self, forKey: key) {
            return Int(text.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        return nil
    }
}

extension Product {
    var nutritionFacts: NutritionFacts? {
        guard let n = nutriments else { return nil }
        let hasAsSoldData = [
            n.energyKcal100g,
            n.energyKj100g,
            n.fat100g,
            n.saturatedFat100g,
            n.carbohydrates100g,
            n.sugars100g,
            n.salt100g,
            n.proteins100g
        ].contains { $0 != nil }
        if hasAsSoldData {
            return NutritionFacts(
                basis: .asSold,
                energyKcal: n.energyKcal100g,
                energyKj: n.energyKj100g,
                fat: n.fat100g,
                saturatedFat: n.saturatedFat100g,
                carbohydrates: n.carbohydrates100g,
                sugars: n.sugars100g,
                addedSugars: n.addedSugars100g,
                salt: n.salt100g,
                proteins: n.proteins100g
            )
        }

        let hasPreparedData = [
            n.energyKcalPrepared100g,
            n.energyKjPrepared100g,
            n.fatPrepared100g,
            n.saturatedFatPrepared100g,
            n.carbohydratesPrepared100g,
            n.sugarsPrepared100g,
            n.saltPrepared100g,
            n.proteinsPrepared100g
        ].contains { $0 != nil }
        if hasPreparedData {
            return NutritionFacts(
                basis: .prepared,
                energyKcal: n.energyKcalPrepared100g,
                energyKj: n.energyKjPrepared100g,
                fat: n.fatPrepared100g,
                saturatedFat: n.saturatedFatPrepared100g,
                carbohydrates: n.carbohydratesPrepared100g,
                sugars: n.sugarsPrepared100g,
                addedSugars: n.addedSugarsPrepared100g,
                salt: n.saltPrepared100g,
                proteins: n.proteinsPrepared100g
            )
        }
        return nil
    }

    var hasUsefulData: Bool {
        !(productName?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) ||
        !(ingredientsText?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) ||
        !(ingredients?.isEmpty ?? true) ||
        !(ingredientsAnalysisTags?.isEmpty ?? true) ||
        nutriments != nil ||
        greenScoreGrade != nil ||
        greenScoreValue != nil ||
        nutrientLevels != nil
    }

    var hasVeganData: Bool {
        !(ingredientsAnalysisTags?.isEmpty ?? true) ||
        (ingredients?.contains(where: { !($0.vegan?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) }) ?? false)
    }

    var greenScoreGrade: String? {
        let raw = environmentalScoreGrade ?? ecoscoreGrade
        let normalized = raw?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
        return normalized.flatMap { ["A", "B", "C", "D", "E"].contains($0) ? $0 : nil }
    }

    var greenScoreValue: Int? {
        let value = environmentalScoreScore ?? ecoscoreScore
        return value.flatMap { (0...100).contains($0) ? $0 : nil }
    }

    var nutrientLevelEntries: [(key: NutrientLevelKey, level: NutrientLevelValue)] {
        [
            (NutrientLevelKey.fat, nutrientLevels?.fat),
            (NutrientLevelKey.saturatedFat, nutrientLevels?.saturatedFat),
            (NutrientLevelKey.sugars, nutrientLevels?.sugars),
            (NutrientLevelKey.salt, nutrientLevels?.salt)
        ].compactMap { key, raw in
            guard let normalized = raw?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() else {
                return nil
            }
            let level: NutrientLevelValue?
            switch normalized {
            case "low":
                level = .low
            case "moderate":
                level = .moderate
            case "high":
                level = .high
            default:
                level = nil
            }
            return level.map { (key, $0) }
        }
    }

    var carbonFootprint: CarbonFootprint? {
        if let declared = nutriments?.carbonFootprint100g, declared >= 0 {
            return CarbonFootprint(value: declared, source: .declared)
        }
        if let estimated = (environmentalScoreData ?? ecoscoreData)?.agribalyse?.co2Total, estimated >= 0 {
            return CarbonFootprint(value: estimated * 100, source: .estimated)
        }
        return nil
    }
}

enum NutrientLevelKey: Equatable {
    case fat
    case saturatedFat
    case sugars
    case salt
}

enum NutrientLevelValue: Equatable {
    case low
    case moderate
    case high
}

enum CarbonFootprintSource: Equatable {
    case declared
    case estimated
}

struct CarbonFootprint {
    let value: Double
    let source: CarbonFootprintSource
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
    "E102": LocalizedAdditiveRecord(
        commonName: ("Tartrazina", "Tartrazine"),
        note: ("Colorante amarillo azoico de síntesis.", "Synthetic azo yellow colour."),
        origin: .synthetic
    ),
    "E104": LocalizedAdditiveRecord(
        commonName: ("Amarillo de quinoleína", "Quinoline Yellow"),
        note: ("Colorante amarillo de síntesis.", "Synthetic yellow colour."),
        origin: .synthetic
    ),
    "E110": LocalizedAdditiveRecord(
        commonName: ("Amarillo ocaso FCF", "Sunset Yellow FCF"),
        note: ("Colorante naranja azoico de síntesis.", "Synthetic azo orange colour."),
        origin: .synthetic
    ),
    "E120": LocalizedAdditiveRecord(
        commonName: ("Carmín", "Carmine"),
        note: ("Colorante rojo obtenido de la cochinilla.", "Red coloring obtained from cochineal."),
        origin: .animal
    ),
    "E122": LocalizedAdditiveRecord(
        commonName: ("Azorrubina", "Azorubine"),
        note: ("Colorante rojo azoico de síntesis.", "Synthetic azo red colour."),
        origin: .synthetic
    ),
    "E123": LocalizedAdditiveRecord(
        commonName: ("Amaranto", "Amaranth"),
        note: ("Colorante rojo azoico de uso muy limitado.", "Synthetic azo red colour with very limited use."),
        origin: .synthetic
    ),
    "E124": LocalizedAdditiveRecord(
        commonName: ("Rojo Ponceau 4R", "Ponceau 4R"),
        note: ("Colorante rojo azoico de síntesis.", "Synthetic azo red colour."),
        origin: .synthetic
    ),
    "E127": LocalizedAdditiveRecord(
        commonName: ("Eritrosina", "Erythrosine"),
        note: ("Colorante rojo de síntesis usado en cerezas confitadas.", "Synthetic red colour used in candied cherries."),
        origin: .synthetic
    ),
    "E129": LocalizedAdditiveRecord(
        commonName: ("Rojo allura AC", "Allura Red AC"),
        note: ("Colorante rojo azoico de síntesis.", "Synthetic azo red colour."),
        origin: .synthetic
    ),
    "E131": LocalizedAdditiveRecord(
        commonName: ("Azul patentado V", "Patent Blue V"),
        note: ("Colorante azul de síntesis.", "Synthetic blue colour."),
        origin: .synthetic
    ),
    "E132": LocalizedAdditiveRecord(
        commonName: ("Indigotina", "Indigotine"),
        note: ("Colorante azul de síntesis.", "Synthetic blue colour."),
        origin: .synthetic
    ),
    "E133": LocalizedAdditiveRecord(
        commonName: ("Azul brillante FCF", "Brilliant Blue FCF"),
        note: ("Colorante azul de síntesis.", "Synthetic blue colour."),
        origin: .synthetic
    ),
    "E140": LocalizedAdditiveRecord(
        commonName: ("Clorofilas", "Chlorophylls"),
        note: ("Pigmentos verdes de origen vegetal.", "Green pigments of plant origin."),
        origin: .plant
    ),
    "E142": LocalizedAdditiveRecord(
        commonName: ("Verde S", "Green S"),
        note: ("Colorante verde de síntesis.", "Synthetic green colour."),
        origin: .synthetic
    ),
    "E151": LocalizedAdditiveRecord(
        commonName: ("Negro brillante BN", "Brilliant Black BN"),
        note: ("Colorante negro azoico de síntesis.", "Synthetic azo black colour."),
        origin: .synthetic
    ),
    "E153": LocalizedAdditiveRecord(
        commonName: ("Carbón vegetal", "Vegetable carbon"),
        note: ("Colorante negro de origen vegetal.", "Black coloring of plant origin."),
        origin: .plant
    ),
    "E155": LocalizedAdditiveRecord(
        commonName: ("Marrón HT", "Brown HT"),
        note: ("Colorante marrón azoico de síntesis.", "Synthetic azo brown colour."),
        origin: .synthetic
    ),
    "E160A": LocalizedAdditiveRecord(
        commonName: ("Carotenos", "Carotenes"),
        note: ("Pigmentos anaranjados de origen vegetal.", "Orange pigments of plant origin."),
        origin: .plant
    ),
    "E161G": LocalizedAdditiveRecord(
        commonName: ("Cantaxantina", "Canthaxanthin"),
        note: ("Carotenoide rojo anaranjado obtenido por síntesis.", "Synthetic orange-red carotenoid."),
        origin: .synthetic
    ),
    "E163": LocalizedAdditiveRecord(
        commonName: ("Antocianinas", "Anthocyanins"),
        note: ("Pigmentos vegetales rojos y morados.", "Red and purple plant pigments."),
        origin: .plant
    ),
    "E180": LocalizedAdditiveRecord(
        commonName: ("Litolrubina BK", "Lithol Rubine BK"),
        note: ("Colorante rojo usado en la corteza de quesos.", "Synthetic red colour used on cheese rind."),
        origin: .synthetic
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
    "E222": LocalizedAdditiveRecord(
        commonName: ("Bisulfito sódico", "Sodium bisulphite"),
        note: ("Conservante y antioxidante sulfitado.", "Sulphite preservative and antioxidant."),
        origin: .synthetic
    ),
    "E227": LocalizedAdditiveRecord(
        commonName: ("Bisulfito cálcico", "Calcium bisulphite"),
        note: ("Conservante y antioxidante sulfitado.", "Sulphite preservative and antioxidant."),
        origin: .synthetic
    ),
    "E228": LocalizedAdditiveRecord(
        commonName: ("Bisulfito potásico", "Potassium bisulphite"),
        note: ("Conservante y antioxidante sulfitado.", "Sulphite preservative and antioxidant."),
        origin: .synthetic
    ),
    "E242": LocalizedAdditiveRecord(
        commonName: ("Dicarbonato de dimetilo", "Dimethyl dicarbonate"),
        note: ("Conservante usado en bebidas.", "Preservative used in beverages."),
        origin: .synthetic
    ),
    "E249": LocalizedAdditiveRecord(
        commonName: ("Nitrito potásico", "Potassium nitrite"),
        note: ("Conservante de curado usado en carnes.", "Curing preservative used in meat."),
        origin: .synthetic
    ),
    "E260": LocalizedAdditiveRecord(
        commonName: ("Ácido acético", "Acetic acid"),
        note: ("Regulador de acidez y conservante, el ácido del vinagre.", "Acidity regulator and preservative, the acid in vinegar."),
        origin: .synthetic
    ),
    "E261": LocalizedAdditiveRecord(
        commonName: ("Acetato potásico", "Potassium acetate"),
        note: ("Conservante y regulador de acidez.", "Preservative and acidity regulator."),
        origin: .synthetic
    ),
    "E262": LocalizedAdditiveRecord(
        commonName: ("Acetatos de sodio", "Sodium acetates"),
        note: ("Conservante y regulador de acidez.", "Preservative and acidity regulator."),
        origin: .synthetic
    ),
    "E263": LocalizedAdditiveRecord(
        commonName: ("Acetato cálcico", "Calcium acetate"),
        note: ("Conservante y regulador de acidez.", "Preservative and acidity regulator."),
        origin: .synthetic
    ),
    "E270": LocalizedAdditiveRecord(
        commonName: ("Ácido láctico", "Lactic acid"),
        note: ("Regulador de acidez; se obtiene casi siempre por fermentación de azúcares vegetales, pero puede proceder de lácteos.", "Acidity regulator; almost always produced by fermenting plant sugars, but it may come from dairy."),
        origin: .uncertain
    ),
    "E280": LocalizedAdditiveRecord(
        commonName: ("Ácido propiónico", "Propionic acid"),
        note: ("Conservante antifúngico usado en panadería.", "Antifungal preservative used in bakery."),
        origin: .synthetic
    ),
    "E281": LocalizedAdditiveRecord(
        commonName: ("Propionato sódico", "Sodium propionate"),
        note: ("Conservante antifúngico usado en panadería.", "Antifungal preservative used in bakery."),
        origin: .synthetic
    ),
    "E282": LocalizedAdditiveRecord(
        commonName: ("Propionato cálcico", "Calcium propionate"),
        note: ("Conservante antifúngico usado en panadería.", "Antifungal preservative used in bakery."),
        origin: .synthetic
    ),
    "E283": LocalizedAdditiveRecord(
        commonName: ("Propionato potásico", "Potassium propionate"),
        note: ("Conservante antifúngico usado en panadería.", "Antifungal preservative used in bakery."),
        origin: .synthetic
    ),
    "E284": LocalizedAdditiveRecord(
        commonName: ("Ácido bórico", "Boric acid"),
        note: ("Conservante de uso muy limitado.", "Preservative with very limited use."),
        origin: .synthetic
    ),
    "E285": LocalizedAdditiveRecord(
        commonName: ("Tetraborato sódico", "Sodium tetraborate"),
        note: ("Conservante de uso muy limitado.", "Preservative with very limited use."),
        origin: .synthetic
    ),
    "E290": LocalizedAdditiveRecord(
        commonName: ("Dióxido de carbono", "Carbon dioxide"),
        note: ("Gas de envasado y carbonatación.", "Packaging and carbonation gas."),
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
    "E325": LocalizedAdditiveRecord(
        commonName: ("Lactato sódico", "Sodium lactate"),
        note: ("Sal del ácido láctico; la fermentación puede partir de sustratos lácteos.", "Lactic acid salt; fermentation may start from dairy substrates."),
        origin: .uncertain
    ),
    "E326": LocalizedAdditiveRecord(
        commonName: ("Lactato potásico", "Potassium lactate"),
        note: ("Sal del ácido láctico; la fermentación puede partir de sustratos lácteos.", "Lactic acid salt; fermentation may start from dairy substrates."),
        origin: .uncertain
    ),
    "E327": LocalizedAdditiveRecord(
        commonName: ("Lactato cálcico", "Calcium lactate"),
        note: ("Sal del ácido láctico; la fermentación puede partir de sustratos lácteos.", "Lactic acid salt; fermentation may start from dairy substrates."),
        origin: .uncertain
    ),
    "E330": LocalizedAdditiveRecord(
        commonName: ("Ácido cítrico", "Citric acid"),
        note: ("Regulador de acidez y antioxidante.", "Acidity regulator and antioxidant."),
        origin: .synthetic
    ),
    "E343": LocalizedAdditiveRecord(
        commonName: ("Fosfatos de magnesio", "Magnesium phosphates"),
        note: ("Regulador de acidez y antiaglomerante de origen mineral.", "Mineral acidity regulator and anti-caking agent."),
        origin: .synthetic
    ),
    "E350": LocalizedAdditiveRecord(
        commonName: ("Malatos de sodio", "Sodium malates"),
        note: ("Regulador de acidez derivado del ácido málico.", "Acidity regulator derived from malic acid."),
        origin: .synthetic
    ),
    "E351": LocalizedAdditiveRecord(
        commonName: ("Malato potásico", "Potassium malate"),
        note: ("Regulador de acidez derivado del ácido málico.", "Acidity regulator derived from malic acid."),
        origin: .synthetic
    ),
    "E352": LocalizedAdditiveRecord(
        commonName: ("Malatos de calcio", "Calcium malates"),
        note: ("Regulador de acidez derivado del ácido málico.", "Acidity regulator derived from malic acid."),
        origin: .synthetic
    ),
    "E353": LocalizedAdditiveRecord(
        commonName: ("Ácido metatartárico", "Metatartaric acid"),
        note: ("Estabilizante derivado del ácido tartárico usado en vinos.", "Stabiliser derived from tartaric acid, used in wine."),
        origin: .synthetic
    ),
    "E354": LocalizedAdditiveRecord(
        commonName: ("Tartrato cálcico", "Calcium tartrate"),
        note: ("Regulador de acidez derivado del ácido tartárico.", "Acidity regulator derived from tartaric acid."),
        origin: .synthetic
    ),
    "E355": LocalizedAdditiveRecord(
        commonName: ("Ácido adípico", "Adipic acid"),
        note: ("Regulador de acidez de síntesis.", "Synthetic acidity regulator."),
        origin: .synthetic
    ),
    "E363": LocalizedAdditiveRecord(
        commonName: ("Ácido succínico", "Succinic acid"),
        note: ("Regulador de acidez de síntesis.", "Synthetic acidity regulator."),
        origin: .synthetic
    ),
    "E380": LocalizedAdditiveRecord(
        commonName: ("Citrato triamónico", "Triammonium citrate"),
        note: ("Regulador de acidez derivado del ácido cítrico.", "Acidity regulator derived from citric acid."),
        origin: .synthetic
    ),
    "E386": LocalizedAdditiveRecord(
        commonName: ("EDTA disódico", "Disodium EDTA"),
        note: ("Secuestrante que protege contra la oxidación.", "Sequestrant that protects against oxidation."),
        origin: .synthetic
    ),
    "E400": LocalizedAdditiveRecord(
        commonName: ("Ácido algínico", "Alginic acid"),
        note: ("Espesante extraído de algas.", "Thickener extracted from seaweed."),
        origin: .plant
    ),
    "E401": LocalizedAdditiveRecord(
        commonName: ("Alginato sódico", "Sodium alginate"),
        note: ("Espesante extraído de algas.", "Thickener extracted from seaweed."),
        origin: .plant
    ),
    "E402": LocalizedAdditiveRecord(
        commonName: ("Alginato potásico", "Potassium alginate"),
        note: ("Espesante extraído de algas.", "Thickener extracted from seaweed."),
        origin: .plant
    ),
    "E403": LocalizedAdditiveRecord(
        commonName: ("Alginato amónico", "Ammonium alginate"),
        note: ("Espesante extraído de algas.", "Thickener extracted from seaweed."),
        origin: .plant
    ),
    "E404": LocalizedAdditiveRecord(
        commonName: ("Alginato cálcico", "Calcium alginate"),
        note: ("Espesante extraído de algas.", "Thickener extracted from seaweed."),
        origin: .plant
    ),
    "E405": LocalizedAdditiveRecord(
        commonName: ("Alginato de propilenglicol", "Propylene glycol alginate"),
        note: ("Derivado de alginatos de algas.", "Derived from seaweed alginates."),
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
    "E417": LocalizedAdditiveRecord(
        commonName: ("Goma tara", "Tara gum"),
        note: ("Espesante de la semilla de tara.", "Thickener from tara seed."),
        origin: .plant
    ),
    "E418": LocalizedAdditiveRecord(
        commonName: ("Goma gellan", "Gellan gum"),
        note: ("Espesante producido por fermentación microbiana.", "Thickener produced by microbial fermentation."),
        origin: .plant
    ),
    "E422": LocalizedAdditiveRecord(
        commonName: ("Glicerina / glicerol", "Glycerin / glycerol"),
        note: ("Puede ser de origen vegetal, animal o sintético.", "May be of plant, animal, or synthetic origin."),
        origin: .uncertain
    ),
    "E426": LocalizedAdditiveRecord(
        commonName: ("Hemicelulosa de soja", "Soybean hemicellulose"),
        note: ("Espesante obtenido de la soja.", "Thickener obtained from soybean."),
        origin: .plant
    ),
    "E427": LocalizedAdditiveRecord(
        commonName: ("Goma cassia", "Cassia gum"),
        note: ("Espesante de la semilla de casia.", "Thickener from cassia seed."),
        origin: .plant
    ),
    "E428": LocalizedAdditiveRecord(
        commonName: ("Gelatina", "Gelatine"),
        note: ("Gelificante proteico obtenido de colágeno animal.", "Protein gelling agent obtained from animal collagen."),
        origin: .animal
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
    "E444": LocalizedAdditiveRecord(
        commonName: ("Acetato isobutirato de sacarosa", "Sucrose acetate isobutyrate"),
        note: ("Emulsionante usado en bebidas.", "Emulsifier used in beverages."),
        origin: .synthetic
    ),
    "E445": LocalizedAdditiveRecord(
        commonName: ("Ésteres glicéricos de resina de madera", "Glycerol esters of wood rosin"),
        note: ("Estabilizante de bebidas obtenido de resina de pino.", "Beverage stabiliser obtained from pine rosin."),
        origin: .plant
    ),
    "E450": LocalizedAdditiveRecord(
        commonName: ("Difosfatos", "Diphosphates"),
        note: ("Estabilizante y gasificante de origen mineral.", "Mineral stabiliser and raising agent."),
        origin: .synthetic
    ),
    "E451": LocalizedAdditiveRecord(
        commonName: ("Trifosfatos", "Triphosphates"),
        note: ("Estabilizante y regulador de acidez de origen mineral.", "Mineral stabiliser and acidity regulator."),
        origin: .synthetic
    ),
    "E452": LocalizedAdditiveRecord(
        commonName: ("Polifosfatos", "Polyphosphates"),
        note: ("Estabilizante y emulsionante de origen mineral.", "Mineral stabiliser and emulsifier."),
        origin: .synthetic
    ),
    "E459": LocalizedAdditiveRecord(
        commonName: ("Beta-ciclodextrina", "Beta-cyclodextrin"),
        note: ("Estabilizante obtenido a partir de almidón.", "Stabiliser obtained from starch."),
        origin: .plant
    ),
    "E462": LocalizedAdditiveRecord(
        commonName: ("Etilcelulosa", "Ethyl cellulose"),
        note: ("Derivado de la celulosa vegetal.", "Derived from plant cellulose."),
        origin: .plant
    ),
    "E467": LocalizedAdditiveRecord(
        commonName: ("Etilhidroxietilcelulosa", "Ethyl hydroxyethyl cellulose"),
        note: ("Derivado de la celulosa vegetal.", "Derived from plant cellulose."),
        origin: .plant
    ),
    "E468": LocalizedAdditiveRecord(
        commonName: ("Carboximetilcelulosa sódica reticulada", "Crosslinked sodium carboxymethyl cellulose"),
        note: ("Derivado de la celulosa vegetal.", "Derived from plant cellulose."),
        origin: .plant
    ),
    "E469": LocalizedAdditiveRecord(
        commonName: ("Carboximetilcelulosa hidrolizada enzimáticamente", "Enzymatically hydrolysed carboxymethyl cellulose"),
        note: ("Derivado de la celulosa vegetal.", "Derived from plant cellulose."),
        origin: .plant
    ),
    "E471": LocalizedAdditiveRecord(
        commonName: ("Mono y diglicéridos de ácidos grasos", "Mono- and diglycerides of fatty acids"),
        note: ("Puede proceder de grasas vegetales o animales.", "May be derived from plant or animal fats."),
        origin: .uncertain
    ),
    "E476": LocalizedAdditiveRecord(
        commonName: ("Polirricinoleato de poliglicerol", "Polyglycerol polyricinoleate"),
        note: ("Emulsionante del chocolate obtenido de aceite de ricino y glicerol de origen variable.", "Chocolate emulsifier obtained from castor oil and glycerol of variable origin."),
        origin: .uncertain
    ),
    "E477": LocalizedAdditiveRecord(
        commonName: ("Ésteres de propilenglicol de ácidos grasos", "Propylene glycol esters of fatty acids"),
        note: ("Emulsionante de origen graso variable.", "Emulsifier with variable fat source."),
        origin: .uncertain
    ),
    "E479B": LocalizedAdditiveRecord(
        commonName: ("Aceite de soja oxidado térmicamente con mono y diglicéridos", "Thermally oxidised soya bean oil with mono- and diglycerides"),
        note: ("Emulsionante de origen graso variable.", "Emulsifier with variable fat source."),
        origin: .uncertain
    ),
    "E483": LocalizedAdditiveRecord(
        commonName: ("Tartrato de estearilo", "Stearyl tartrate"),
        note: ("Emulsionante de origen graso variable.", "Emulsifier with variable fat source."),
        origin: .uncertain
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
    "E535": LocalizedAdditiveRecord(
        commonName: ("Ferrocianuro sódico", "Sodium ferrocyanide"),
        note: ("Antiaglomerante de la sal de origen mineral.", "Mineral anti-caking agent used in salt."),
        origin: .synthetic
    ),
    "E536": LocalizedAdditiveRecord(
        commonName: ("Ferrocianuro potásico", "Potassium ferrocyanide"),
        note: ("Antiaglomerante de la sal de origen mineral.", "Mineral anti-caking agent used in salt."),
        origin: .synthetic
    ),
    "E538": LocalizedAdditiveRecord(
        commonName: ("Ferrocianuro cálcico", "Calcium ferrocyanide"),
        note: ("Antiaglomerante de la sal de origen mineral.", "Mineral anti-caking agent used in salt."),
        origin: .synthetic
    ),
    "E541": LocalizedAdditiveRecord(
        commonName: ("Fosfato de aluminio y sodio ácido", "Sodium aluminium phosphate, acidic"),
        note: ("Gasificante de origen mineral usado en repostería.", "Mineral raising agent used in bakery."),
        origin: .synthetic
    ),
    "E542": LocalizedAdditiveRecord(
        commonName: ("Fosfato de hueso", "Bone phosphate"),
        note: ("Fosfato obtenido de huesos animales.", "Phosphate obtained from animal bones."),
        origin: .animal
    ),
    "E550": LocalizedAdditiveRecord(
        commonName: ("Silicatos de sodio", "Sodium silicates"),
        note: ("Antiaglomerante de origen mineral.", "Mineral anti-caking agent."),
        origin: .synthetic
    ),
    "E552": LocalizedAdditiveRecord(
        commonName: ("Silicato cálcico", "Calcium silicate"),
        note: ("Antiaglomerante de origen mineral.", "Mineral anti-caking agent."),
        origin: .synthetic
    ),
    "E553A": LocalizedAdditiveRecord(
        commonName: ("Silicato de magnesio", "Magnesium silicate"),
        note: ("Antiaglomerante de origen mineral.", "Mineral anti-caking agent."),
        origin: .synthetic
    ),
    "E554": LocalizedAdditiveRecord(
        commonName: ("Silicato de aluminio y sodio", "Sodium aluminium silicate"),
        note: ("Antiaglomerante de origen mineral.", "Mineral anti-caking agent."),
        origin: .synthetic
    ),
    "E555": LocalizedAdditiveRecord(
        commonName: ("Silicato de aluminio y potasio", "Potassium aluminium silicate"),
        note: ("Antiaglomerante de origen mineral.", "Mineral anti-caking agent."),
        origin: .synthetic
    ),
    "E556": LocalizedAdditiveRecord(
        commonName: ("Silicato de aluminio y calcio", "Calcium aluminium silicate"),
        note: ("Antiaglomerante de origen mineral.", "Mineral anti-caking agent."),
        origin: .synthetic
    ),
    "E558": LocalizedAdditiveRecord(
        commonName: ("Bentonita", "Bentonite"),
        note: ("Antiaglomerante de origen mineral.", "Mineral anti-caking agent."),
        origin: .synthetic
    ),
    "E559": LocalizedAdditiveRecord(
        commonName: ("Silicato de aluminio", "Aluminium silicate"),
        note: ("Antiaglomerante de origen mineral.", "Mineral anti-caking agent."),
        origin: .synthetic
    ),
    "E570": LocalizedAdditiveRecord(
        commonName: ("Ácidos grasos", "Fatty acids"),
        note: ("Puede proceder de grasas vegetales o animales.", "May come from plant or animal fats."),
        origin: .uncertain
    ),
    "E574": LocalizedAdditiveRecord(
        commonName: ("Ácido glucónico", "Gluconic acid"),
        note: ("Regulador de acidez obtenido por fermentación.", "Acidity regulator obtained by fermentation."),
        origin: .synthetic
    ),
    "E575": LocalizedAdditiveRecord(
        commonName: ("Glucono-delta-lactona", "Glucono-delta-lactone"),
        note: ("Regulador de acidez y coagulante obtenido por fermentación.", "Acidity regulator and coagulant obtained by fermentation."),
        origin: .synthetic
    ),
    "E576": LocalizedAdditiveRecord(
        commonName: ("Gluconato sódico", "Sodium gluconate"),
        note: ("Secuestrante derivado del ácido glucónico.", "Sequestrant derived from gluconic acid."),
        origin: .synthetic
    ),
    "E577": LocalizedAdditiveRecord(
        commonName: ("Gluconato potásico", "Potassium gluconate"),
        note: ("Secuestrante derivado del ácido glucónico.", "Sequestrant derived from gluconic acid."),
        origin: .synthetic
    ),
    "E578": LocalizedAdditiveRecord(
        commonName: ("Gluconato cálcico", "Calcium gluconate"),
        note: ("Secuestrante derivado del ácido glucónico.", "Sequestrant derived from gluconic acid."),
        origin: .synthetic
    ),
    "E579": LocalizedAdditiveRecord(
        commonName: ("Gluconato ferroso", "Ferrous gluconate"),
        note: ("Estabilizante del color usado en aceitunas.", "Colour stabiliser used in olives."),
        origin: .synthetic
    ),
    "E585": LocalizedAdditiveRecord(
        commonName: ("Lactato ferroso", "Ferrous lactate"),
        note: ("Sal del ácido láctico; la fermentación puede partir de sustratos lácteos.", "Lactic acid salt; fermentation may start from dairy substrates."),
        origin: .uncertain
    ),
    "E586": LocalizedAdditiveRecord(
        commonName: ("4-hexilresorcinol", "4-hexylresorcinol"),
        note: ("Antioxidante usado en crustáceos frescos.", "Antioxidant used on fresh crustaceans."),
        origin: .synthetic
    ),
    "E626": LocalizedAdditiveRecord(
        commonName: ("Ácido guanílico", "Guanylic acid"),
        note: ("Potenciador del sabor de origen variable.", "Flavour enhancer with variable source."),
        origin: .uncertain
    ),
    "E629": LocalizedAdditiveRecord(
        commonName: ("Guanilato cálcico", "Calcium guanylate"),
        note: ("Potenciador del sabor de origen variable.", "Flavour enhancer with variable source."),
        origin: .uncertain
    ),
    "E630": LocalizedAdditiveRecord(
        commonName: ("Ácido inosínico", "Inosinic acid"),
        note: ("Potenciador del sabor de origen variable.", "Flavour enhancer with variable source."),
        origin: .uncertain
    ),
    "E631": LocalizedAdditiveRecord(
        commonName: ("Inosinato disódico", "Disodium inosinate"),
        note: ("Potenciador del sabor de origen variable.", "Flavour enhancer with variable origin."),
        origin: .uncertain
    ),
    "E632": LocalizedAdditiveRecord(
        commonName: ("Inosinato dipotásico", "Dipotassium inosinate"),
        note: ("Potenciador del sabor de origen variable.", "Flavour enhancer with variable source."),
        origin: .uncertain
    ),
    "E633": LocalizedAdditiveRecord(
        commonName: ("Inosinato cálcico", "Calcium inosinate"),
        note: ("Potenciador del sabor de origen variable.", "Flavour enhancer with variable source."),
        origin: .uncertain
    ),
    "E634": LocalizedAdditiveRecord(
        commonName: ("Ribonucleótidos cálcicos", "Calcium ribonucleotides"),
        note: ("Potenciador del sabor de origen variable.", "Flavour enhancer with variable source."),
        origin: .uncertain
    ),
    "E635": LocalizedAdditiveRecord(
        commonName: ("Ribonucleótidos disódicos", "Disodium ribonucleotides"),
        note: ("Potenciador del sabor de origen variable.", "Flavour enhancer with variable origin."),
        origin: .uncertain
    ),
    "E636": LocalizedAdditiveRecord(
        commonName: ("Maltol", "Maltol"),
        note: ("Potenciador del sabor con aroma a caramelo.", "Flavour enhancer with a caramel aroma."),
        origin: .synthetic
    ),
    "E637": LocalizedAdditiveRecord(
        commonName: ("Etilmaltol", "Ethyl maltol"),
        note: ("Potenciador del sabor con aroma a caramelo.", "Flavour enhancer with a caramel aroma."),
        origin: .synthetic
    ),
    "E650": LocalizedAdditiveRecord(
        commonName: ("Acetato de zinc", "Zinc acetate"),
        note: ("Potenciador del sabor usado en chicles.", "Flavour enhancer used in chewing gum."),
        origin: .synthetic
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
    "E938": LocalizedAdditiveRecord(
        commonName: ("Argón", "Argon"),
        note: ("Gas inerte de envasado.", "Inert packaging gas."),
        origin: .synthetic
    ),
    "E939": LocalizedAdditiveRecord(
        commonName: ("Helio", "Helium"),
        note: ("Gas inerte de envasado.", "Inert packaging gas."),
        origin: .synthetic
    ),
    "E941": LocalizedAdditiveRecord(
        commonName: ("Nitrógeno", "Nitrogen"),
        note: ("Gas inerte de envasado.", "Inert packaging gas."),
        origin: .synthetic
    ),
    "E942": LocalizedAdditiveRecord(
        commonName: ("Óxido nitroso", "Nitrous oxide"),
        note: ("Gas propelente usado en nata en espray.", "Propellant gas used in whipped cream."),
        origin: .synthetic
    ),
    "E943A": LocalizedAdditiveRecord(
        commonName: ("Butano", "Butane"),
        note: ("Gas propelente de origen petroquímico.", "Petrochemical propellant gas."),
        origin: .synthetic
    ),
    "E943B": LocalizedAdditiveRecord(
        commonName: ("Isobutano", "Isobutane"),
        note: ("Gas propelente de origen petroquímico.", "Petrochemical propellant gas."),
        origin: .synthetic
    ),
    "E944": LocalizedAdditiveRecord(
        commonName: ("Propano", "Propane"),
        note: ("Gas propelente de origen petroquímico.", "Petrochemical propellant gas."),
        origin: .synthetic
    ),
    "E948": LocalizedAdditiveRecord(
        commonName: ("Oxígeno", "Oxygen"),
        note: ("Gas de envasado.", "Packaging gas."),
        origin: .synthetic
    ),
    "E949": LocalizedAdditiveRecord(
        commonName: ("Hidrógeno", "Hydrogen"),
        note: ("Gas de envasado.", "Packaging gas."),
        origin: .synthetic
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
    "E952": LocalizedAdditiveRecord(
        commonName: ("Ciclamato", "Cyclamate"),
        note: ("Edulcorante intenso de síntesis.", "Synthetic intense sweetener."),
        origin: .synthetic
    ),
    "E953": LocalizedAdditiveRecord(
        commonName: ("Isomalt", "Isomalt"),
        note: ("Poliol obtenido a partir de azúcar de remolacha.", "Polyol obtained from beet sugar."),
        origin: .plant
    ),
    "E954": LocalizedAdditiveRecord(
        commonName: ("Sacarina", "Saccharin"),
        note: ("Edulcorante intenso de síntesis.", "Synthetic intense sweetener."),
        origin: .synthetic
    ),
    "E955": LocalizedAdditiveRecord(
        commonName: ("Sucralosa", "Sucralose"),
        note: ("Edulcorante intenso obtenido a partir del azúcar.", "Intense sweetener obtained from sugar."),
        origin: .synthetic
    ),
    "E957": LocalizedAdditiveRecord(
        commonName: ("Taumatina", "Thaumatin"),
        note: ("Proteína edulcorante de origen vegetal.", "Sweet protein of plant origin."),
        origin: .plant
    ),
    "E959": LocalizedAdditiveRecord(
        commonName: ("Neohesperidina dihidrochalcona", "Neohesperidin dihydrochalcone"),
        note: ("Edulcorante derivado de cítricos.", "Sweetener derived from citrus fruit."),
        origin: .plant
    ),
    "E960": LocalizedAdditiveRecord(
        commonName: ("Glicósidos de esteviol", "Steviol glycosides"),
        note: ("Edulcorantes extraídos de la estevia.", "Sweeteners extracted from stevia."),
        origin: .plant
    ),
    "E961": LocalizedAdditiveRecord(
        commonName: ("Neotamo", "Neotame"),
        note: ("Edulcorante intenso de síntesis.", "Synthetic intense sweetener."),
        origin: .synthetic
    ),
    "E962": LocalizedAdditiveRecord(
        commonName: ("Sal de aspartamo y acesulfamo", "Salt of aspartame-acesulfame"),
        note: ("Edulcorante intenso de síntesis.", "Synthetic intense sweetener."),
        origin: .synthetic
    ),
    "E964": LocalizedAdditiveRecord(
        commonName: ("Jarabe de poliglicitol", "Polyglycitol syrup"),
        note: ("Poliol obtenido a partir de almidón.", "Polyol obtained from starch."),
        origin: .plant
    ),
    "E969": LocalizedAdditiveRecord(
        commonName: ("Advantamo", "Advantame"),
        note: ("Edulcorante intenso de síntesis.", "Synthetic intense sweetener."),
        origin: .synthetic
    ),
    "E1000": LocalizedAdditiveRecord(
        commonName: ("Ácido cólico", "Cholic acid"),
        note: ("Emulsionante obtenido de la bilis animal.", "Emulsifier obtained from animal bile."),
        origin: .animal
    ),
    "E1103": LocalizedAdditiveRecord(
        commonName: ("Invertasa", "Invertase"),
        note: ("Enzima obtenida por fermentación de levaduras.", "Enzyme obtained by yeast fermentation."),
        origin: .synthetic
    ),
    "E1105": LocalizedAdditiveRecord(
        commonName: ("Lisozima", "Lysozyme"),
        note: ("Enzima obtenida habitualmente de la clara de huevo.", "Enzyme usually obtained from egg white."),
        origin: .animal
    ),
    "E101I": LocalizedAdditiveRecord(
        commonName: ("Riboflavina", "Riboflavina"),
        note: ("Vitamina B2 usada como colorante amarillo; suele obtenerse por fermentación.", "Vitamina B2 usada como colorante amarillo; suele obtenerse por fermentación."),
        origin: .synthetic
    ),
    "E141": LocalizedAdditiveRecord(
        commonName: ("Complejos cúpricos de clorofilas", "Complejos cúpricos de clorofilas"),
        note: ("Derivado de clorofilas vegetales con cobre.", "Derivado de clorofilas vegetales con cobre."),
        origin: .plant
    ),
    "E150A": LocalizedAdditiveRecord(
        commonName: ("Caramelo simple", "Caramelo simple"),
        note: ("Colorante marrón obtenido por caramelización controlada.", "Colorante marrón obtenido por caramelización controlada."),
        origin: .synthetic
    ),
    "E150B": LocalizedAdditiveRecord(
        commonName: ("Caramelo sulfito cáustico", "Caramelo sulfito cáustico"),
        note: ("Colorante marrón producido con compuestos sulfitados.", "Colorante marrón producido con compuestos sulfitados."),
        origin: .synthetic
    ),
    "E150C": LocalizedAdditiveRecord(
        commonName: ("Caramelo amónico", "Caramelo amónico"),
        note: ("Colorante marrón producido con compuestos amónicos.", "Colorante marrón producido con compuestos amónicos."),
        origin: .synthetic
    ),
    "E150D": LocalizedAdditiveRecord(
        commonName: ("Caramelo sulfito amónico", "Caramelo sulfito amónico"),
        note: ("Colorante marrón obtenido con sulfitos y amonio.", "Colorante marrón obtenido con sulfitos y amonio."),
        origin: .synthetic
    ),
    "E160B": LocalizedAdditiveRecord(
        commonName: ("Annatto", "Annatto"),
        note: ("Colorante amarillo-anaranjado procedente de semillas vegetales.", "Colorante amarillo-anaranjado procedente de semillas vegetales."),
        origin: .plant
    ),
    "E160C": LocalizedAdditiveRecord(
        commonName: ("Extracto de pimentón", "Extracto de pimentón"),
        note: ("Colorante rojo extraído del pimentón.", "Colorante rojo extraído del pimentón."),
        origin: .plant
    ),
    "E160D": LocalizedAdditiveRecord(
        commonName: ("Licopeno", "Licopeno"),
        note: ("Pigmento rojo presente en tomate y otras frutas.", "Pigmento rojo presente en tomate y otras frutas."),
        origin: .plant
    ),
    "E160E": LocalizedAdditiveRecord(
        commonName: ("Beta-apo-8'-carotenal", "Beta-apo-8'-carotenal"),
        note: ("Colorante anaranjado de síntesis.", "Colorante anaranjado de síntesis."),
        origin: .synthetic
    ),
    "E160F": LocalizedAdditiveRecord(
        commonName: ("Éster etílico del ácido beta-apo-8'-carotenoico", "Éster etílico del ácido beta-apo-8'-carotenoico"),
        note: ("Colorante anaranjado de síntesis.", "Colorante anaranjado de síntesis."),
        origin: .synthetic
    ),
    "E161B": LocalizedAdditiveRecord(
        commonName: ("Luteína", "Luteína"),
        note: ("Pigmento amarillo de hojas y flores.", "Pigmento amarillo de hojas y flores."),
        origin: .plant
    ),
    "E162": LocalizedAdditiveRecord(
        commonName: ("Rojo de remolacha", "Rojo de remolacha"),
        note: ("Colorante rojo de la remolacha.", "Colorante rojo de la remolacha."),
        origin: .plant
    ),
    "E170": LocalizedAdditiveRecord(
        commonName: ("Carbonato cálcico", "Carbonato cálcico"),
        note: ("Colorante blanco y regulador de acidez de origen mineral.", "Colorante blanco y regulador de acidez de origen mineral."),
        origin: .synthetic
    ),
    "E171": LocalizedAdditiveRecord(
        commonName: ("Dióxido de titanio", "Dióxido de titanio"),
        note: ("Colorante blanco de origen mineral.", "Colorante blanco de origen mineral."),
        origin: .synthetic
    ),
    "E172": LocalizedAdditiveRecord(
        commonName: ("Óxidos e hidróxidos de hierro", "Óxidos e hidróxidos de hierro"),
        note: ("Pigmentos minerales amarillos, rojos y negros.", "Pigmentos minerales amarillos, rojos y negros."),
        origin: .synthetic
    ),
    "E173": LocalizedAdditiveRecord(
        commonName: ("Aluminio", "Aluminio"),
        note: ("Colorante metálico de uso muy limitado.", "Colorante metálico de uso muy limitado."),
        origin: .synthetic
    ),
    "E174": LocalizedAdditiveRecord(
        commonName: ("Plata", "Plata"),
        note: ("Colorante metálico usado como decorativo.", "Colorante metálico usado como decorativo."),
        origin: .synthetic
    ),
    "E201": LocalizedAdditiveRecord(
        commonName: ("Sorbato sódico", "Sorbato sódico"),
        note: ("Conservante derivado del ácido sórbico.", "Conservante derivado del ácido sórbico."),
        origin: .synthetic
    ),
    "E203": LocalizedAdditiveRecord(
        commonName: ("Sorbato cálcico", "Sorbato cálcico"),
        note: ("Conservante derivado del ácido sórbico.", "Conservante derivado del ácido sórbico."),
        origin: .synthetic
    ),
    "E210": LocalizedAdditiveRecord(
        commonName: ("Ácido benzoico", "Ácido benzoico"),
        note: ("Conservante contra bacterias y mohos.", "Conservante contra bacterias y mohos."),
        origin: .synthetic
    ),
    "E212": LocalizedAdditiveRecord(
        commonName: ("Benzoato cálcico", "Benzoato cálcico"),
        note: ("Conservante de la familia de los benzoatos.", "Conservante de la familia de los benzoatos."),
        origin: .synthetic
    ),
    "E213": LocalizedAdditiveRecord(
        commonName: ("Benzoato potásico", "Benzoato potásico"),
        note: ("Conservante de la familia de los benzoatos.", "Conservante de la familia de los benzoatos."),
        origin: .synthetic
    ),
    "E214": LocalizedAdditiveRecord(
        commonName: ("Etilparabeno", "Etilparabeno"),
        note: ("Conservante parabeno de síntesis.", "Conservante parabeno de síntesis."),
        origin: .synthetic
    ),
    "E218": LocalizedAdditiveRecord(
        commonName: ("Metilparabeno", "Metilparabeno"),
        note: ("Conservante parabeno de síntesis.", "Conservante parabeno de síntesis."),
        origin: .synthetic
    ),
    "E221": LocalizedAdditiveRecord(
        commonName: ("Sulfito sódico", "Sulfito sódico"),
        note: ("Conservante y antioxidante sulfitado.", "Conservante y antioxidante sulfitado."),
        origin: .synthetic
    ),
    "E223": LocalizedAdditiveRecord(
        commonName: ("Metabisulfito sódico", "Metabisulfito sódico"),
        note: ("Conservante sulfitado.", "Conservante sulfitado."),
        origin: .synthetic
    ),
    "E224": LocalizedAdditiveRecord(
        commonName: ("Metabisulfito potásico", "Metabisulfito potásico"),
        note: ("Conservante sulfitado.", "Conservante sulfitado."),
        origin: .synthetic
    ),
    "E226": LocalizedAdditiveRecord(
        commonName: ("Sulfito cálcico", "Sulfito cálcico"),
        note: ("Conservante sulfitado.", "Conservante sulfitado."),
        origin: .synthetic
    ),
    "E230": LocalizedAdditiveRecord(
        commonName: ("Bifenilo", "Bifenilo"),
        note: ("Conservante de cáscaras de frutas.", "Conservante de cáscaras de frutas."),
        origin: .synthetic
    ),
    "E231": LocalizedAdditiveRecord(
        commonName: ("Ortofenilfenol", "Ortofenilfenol"),
        note: ("Conservante superficial para cítricos.", "Conservante superficial para cítricos."),
        origin: .synthetic
    ),
    "E234": LocalizedAdditiveRecord(
        commonName: ("Nisina", "Nisina"),
        note: ("Bacteriocina producida por fermentación bacteriana.", "Bacteriocina producida por fermentación bacteriana."),
        origin: .uncertain
    ),
    "E235": LocalizedAdditiveRecord(
        commonName: ("Natamicina", "Natamicina"),
        note: ("Antifúngico obtenido por fermentación microbiana.", "Antifúngico obtenido por fermentación microbiana."),
        origin: .uncertain
    ),
    "E250": LocalizedAdditiveRecord(
        commonName: ("Nitrito sódico", "Nitrito sódico"),
        note: ("Conservante de carnes curadas.", "Conservante de carnes curadas."),
        origin: .synthetic
    ),
    "E251": LocalizedAdditiveRecord(
        commonName: ("Nitrato sódico", "Nitrato sódico"),
        note: ("Conservante de carnes curadas.", "Conservante de carnes curadas."),
        origin: .synthetic
    ),
    "E252": LocalizedAdditiveRecord(
        commonName: ("Nitrato potásico", "Nitrato potásico"),
        note: ("Conservante de carnes curadas.", "Conservante de carnes curadas."),
        origin: .synthetic
    ),
    "E296": LocalizedAdditiveRecord(
        commonName: ("Ácido málico", "Ácido málico"),
        note: ("Regulador de acidez y sabor ácido.", "Regulador de acidez y sabor ácido."),
        origin: .synthetic
    ),
    "E297": LocalizedAdditiveRecord(
        commonName: ("Ácido fumárico", "Ácido fumárico"),
        note: ("Regulador de acidez.", "Regulador de acidez."),
        origin: .synthetic
    ),
    "E300": LocalizedAdditiveRecord(
        commonName: ("Ácido ascórbico", "Ácido ascórbico"),
        note: ("Puede ser de origen vegetal o por síntesis.", "Puede ser de origen vegetal o por síntesis."),
        origin: .uncertain
    ),
    "E301": LocalizedAdditiveRecord(
        commonName: ("Ascorbato sódico", "Ascorbato sódico"),
        note: ("Antioxidante derivado del ácido ascórbico.", "Antioxidante derivado del ácido ascórbico."),
        origin: .synthetic
    ),
    "E302": LocalizedAdditiveRecord(
        commonName: ("Ascorbato cálcico", "Ascorbato cálcico"),
        note: ("Antioxidante derivado del ácido ascórbico.", "Antioxidante derivado del ácido ascórbico."),
        origin: .synthetic
    ),
    "E304": LocalizedAdditiveRecord(
        commonName: ("Palmitato de ascorbilo", "Palmitato de ascorbilo"),
        note: ("Antioxidante liposoluble derivado de la vitamina C.", "Antioxidante liposoluble derivado de la vitamina C."),
        origin: .synthetic
    ),
    "E307": LocalizedAdditiveRecord(
        commonName: ("Alfa-tocoferol", "Alfa-tocoferol"),
        note: ("Vitamina E con función antioxidante.", "Vitamina E con función antioxidante."),
        origin: .plant
    ),
    "E308": LocalizedAdditiveRecord(
        commonName: ("Gamma-tocoferol", "Gamma-tocoferol"),
        note: ("Vitamina E con función antioxidante.", "Vitamina E con función antioxidante."),
        origin: .plant
    ),
    "E309": LocalizedAdditiveRecord(
        commonName: ("Delta-tocoferol", "Delta-tocoferol"),
        note: ("Vitamina E con función antioxidante.", "Vitamina E con función antioxidante."),
        origin: .plant
    ),
    "E310": LocalizedAdditiveRecord(
        commonName: ("Galato de propilo", "Galato de propilo"),
        note: ("Antioxidante sintético.", "Antioxidante sintético."),
        origin: .synthetic
    ),
    "E311": LocalizedAdditiveRecord(
        commonName: ("Galato de octilo", "Galato de octilo"),
        note: ("Antioxidante sintético.", "Antioxidante sintético."),
        origin: .synthetic
    ),
    "E312": LocalizedAdditiveRecord(
        commonName: ("Galato de dodecilo", "Galato de dodecilo"),
        note: ("Antioxidante sintético.", "Antioxidante sintético."),
        origin: .synthetic
    ),
    "E315": LocalizedAdditiveRecord(
        commonName: ("Ácido eritórbico", "Ácido eritórbico"),
        note: ("Antioxidante isómero del ácido ascórbico.", "Antioxidante isómero del ácido ascórbico."),
        origin: .synthetic
    ),
    "E316": LocalizedAdditiveRecord(
        commonName: ("Eritorbato sódico", "Eritorbato sódico"),
        note: ("Antioxidante derivado del ácido eritórbico.", "Antioxidante derivado del ácido eritórbico."),
        origin: .synthetic
    ),
    "E319": LocalizedAdditiveRecord(
        commonName: ("TBHQ", "TBHQ"),
        note: ("Antioxidante sintético.", "Antioxidante sintético."),
        origin: .synthetic
    ),
    "E320": LocalizedAdditiveRecord(
        commonName: ("BHA", "BHA"),
        note: ("Antioxidante sintético.", "Antioxidante sintético."),
        origin: .synthetic
    ),
    "E321": LocalizedAdditiveRecord(
        commonName: ("BHT", "BHT"),
        note: ("Antioxidante sintético.", "Antioxidante sintético."),
        origin: .synthetic
    ),
    "E331": LocalizedAdditiveRecord(
        commonName: ("Citrato sódico", "Citrato sódico"),
        note: ("Regulador de acidez.", "Regulador de acidez."),
        origin: .synthetic
    ),
    "E332": LocalizedAdditiveRecord(
        commonName: ("Citrato potásico", "Citrato potásico"),
        note: ("Regulador de acidez.", "Regulador de acidez."),
        origin: .synthetic
    ),
    "E333": LocalizedAdditiveRecord(
        commonName: ("Citrato cálcico", "Citrato cálcico"),
        note: ("Regulador de acidez.", "Regulador de acidez."),
        origin: .synthetic
    ),
    "E334": LocalizedAdditiveRecord(
        commonName: ("Ácido tartárico", "Ácido tartárico"),
        note: ("Regulador de acidez presente en uvas y vino.", "Regulador de acidez presente en uvas y vino."),
        origin: .plant
    ),
    "E335": LocalizedAdditiveRecord(
        commonName: ("Tartrato sódico", "Tartrato sódico"),
        note: ("Regulador de acidez derivado del ácido tartárico.", "Regulador de acidez derivado del ácido tartárico."),
        origin: .synthetic
    ),
    "E336": LocalizedAdditiveRecord(
        commonName: ("Tartrato potásico", "Tartrato potásico"),
        note: ("Regulador de acidez derivado del ácido tartárico.", "Regulador de acidez derivado del ácido tartárico."),
        origin: .synthetic
    ),
    "E337": LocalizedAdditiveRecord(
        commonName: ("Tartrato sódico y potásico", "Tartrato sódico y potásico"),
        note: ("Regulador de acidez derivado del ácido tartárico.", "Regulador de acidez derivado del ácido tartárico."),
        origin: .synthetic
    ),
    "E338": LocalizedAdditiveRecord(
        commonName: ("Ácido fosfórico", "Ácido fosfórico"),
        note: ("Regulador de acidez.", "Regulador de acidez."),
        origin: .synthetic
    ),
    "E339": LocalizedAdditiveRecord(
        commonName: ("Fosfatos de sodio", "Fosfatos de sodio"),
        note: ("Regulador de acidez y sales tampón.", "Regulador de acidez y sales tampón."),
        origin: .synthetic
    ),
    "E340": LocalizedAdditiveRecord(
        commonName: ("Fosfatos de potasio", "Fosfatos de potasio"),
        note: ("Regulador de acidez y sales tampón.", "Regulador de acidez y sales tampón."),
        origin: .synthetic
    ),
    "E341": LocalizedAdditiveRecord(
        commonName: ("Fosfatos de calcio", "Fosfatos de calcio"),
        note: ("Regulador de acidez y sales tampón.", "Regulador de acidez y sales tampón."),
        origin: .synthetic
    ),
    "E385": LocalizedAdditiveRecord(
        commonName: ("EDTA cálcico disódico", "EDTA cálcico disódico"),
        note: ("Secuestrante que protege contra la oxidación.", "Secuestrante que protege contra la oxidación."),
        origin: .synthetic
    ),
    "E407": LocalizedAdditiveRecord(
        commonName: ("Carragenano", "Carragenano"),
        note: ("Gelificante y espesante de algas rojas.", "Gelificante y espesante de algas rojas."),
        origin: .plant
    ),
    "E407A": LocalizedAdditiveRecord(
        commonName: ("Carragenano procesado de Eucheuma", "Carragenano procesado de Eucheuma"),
        note: ("Derivado de algas rojas.", "Derivado de algas rojas."),
        origin: .plant
    ),
    "E410": LocalizedAdditiveRecord(
        commonName: ("Harina de algarroba", "Harina de algarroba"),
        note: ("Espesante vegetal de la semilla de algarrobo.", "Espesante vegetal de la semilla de algarrobo."),
        origin: .plant
    ),
    "E413": LocalizedAdditiveRecord(
        commonName: ("Goma tragacanto", "Goma tragacanto"),
        note: ("Espesante vegetal de la savia de plantas leguminosas.", "Espesante vegetal de la savia de plantas leguminosas."),
        origin: .plant
    ),
    "E415": LocalizedAdditiveRecord(
        commonName: ("Goma xantana", "Goma xantana"),
        note: ("Espesante producido por fermentación microbiana.", "Espesante producido por fermentación microbiana."),
        origin: .plant
    ),
    "E416": LocalizedAdditiveRecord(
        commonName: ("Goma karaya", "Goma karaya"),
        note: ("Espesante vegetal de exudados arbóreos.", "Espesante vegetal de exudados arbóreos."),
        origin: .plant
    ),
    "E420": LocalizedAdditiveRecord(
        commonName: ("Sorbitol", "Sorbitol"),
        note: ("Poliol obtenido de glucosa; la fuente puede variar.", "Poliol obtenido de glucosa; la fuente puede variar."),
        origin: .uncertain
    ),
    "E421": LocalizedAdditiveRecord(
        commonName: ("Manitol", "Manitol"),
        note: ("Poliol de origen vegetal, fúngico o por síntesis.", "Poliol de origen vegetal, fúngico o por síntesis."),
        origin: .uncertain
    ),
    "E425": LocalizedAdditiveRecord(
        commonName: ("Konjac", "Konjac"),
        note: ("Gelificante de la raíz de konjac.", "Gelificante de la raíz de konjac."),
        origin: .plant
    ),
    "E432": LocalizedAdditiveRecord(
        commonName: ("Polisorbato 20", "Polisorbato 20"),
        note: ("Emulsionante de síntesis.", "Emulsionante de síntesis."),
        origin: .synthetic
    ),
    "E433": LocalizedAdditiveRecord(
        commonName: ("Polisorbato 80", "Polisorbato 80"),
        note: ("Emulsionante de síntesis.", "Emulsionante de síntesis."),
        origin: .synthetic
    ),
    "E434": LocalizedAdditiveRecord(
        commonName: ("Polisorbato 40", "Polisorbato 40"),
        note: ("Emulsionante de síntesis.", "Emulsionante de síntesis."),
        origin: .synthetic
    ),
    "E435": LocalizedAdditiveRecord(
        commonName: ("Polisorbato 60", "Polisorbato 60"),
        note: ("Emulsionante de síntesis.", "Emulsionante de síntesis."),
        origin: .synthetic
    ),
    "E436": LocalizedAdditiveRecord(
        commonName: ("Polisorbato 65", "Polisorbato 65"),
        note: ("Emulsionante de síntesis.", "Emulsionante de síntesis."),
        origin: .synthetic
    ),
    "E460": LocalizedAdditiveRecord(
        commonName: ("Celulosa", "Celulosa"),
        note: ("Fibra vegetal usada como agente de carga.", "Fibra vegetal usada como agente de carga."),
        origin: .plant
    ),
    "E461": LocalizedAdditiveRecord(
        commonName: ("Metilcelulosa", "Metilcelulosa"),
        note: ("Derivado de la celulosa vegetal.", "Derivado de la celulosa vegetal."),
        origin: .plant
    ),
    "E463": LocalizedAdditiveRecord(
        commonName: ("Hidroxipropilcelulosa", "Hidroxipropilcelulosa"),
        note: ("Derivado de la celulosa vegetal.", "Derivado de la celulosa vegetal."),
        origin: .plant
    ),
    "E464": LocalizedAdditiveRecord(
        commonName: ("Hidroxipropilmetilcelulosa", "Hidroxipropilmetilcelulosa"),
        note: ("Derivado de la celulosa vegetal.", "Derivado de la celulosa vegetal."),
        origin: .plant
    ),
    "E465": LocalizedAdditiveRecord(
        commonName: ("Etilmetilcelulosa", "Etilmetilcelulosa"),
        note: ("Derivado de la celulosa vegetal.", "Derivado de la celulosa vegetal."),
        origin: .plant
    ),
    "E466": LocalizedAdditiveRecord(
        commonName: ("Carboximetilcelulosa sódica", "Carboximetilcelulosa sódica"),
        note: ("Derivado de la celulosa vegetal.", "Derivado de la celulosa vegetal."),
        origin: .plant
    ),
    "E470A": LocalizedAdditiveRecord(
        commonName: ("Sales sódicas de ácidos grasos", "Sales sódicas de ácidos grasos"),
        note: ("Emulsionante obtenido a partir de grasas; la fuente puede variar.", "Emulsionante obtenido a partir de grasas; la fuente puede variar."),
        origin: .uncertain
    ),
    "E470B": LocalizedAdditiveRecord(
        commonName: ("Sales de potasio de ácidos grasos", "Sales de potasio de ácidos grasos"),
        note: ("Emulsionante obtenido a partir de grasas; la fuente puede variar.", "Emulsionante obtenido a partir de grasas; la fuente puede variar."),
        origin: .uncertain
    ),
    "E472A": LocalizedAdditiveRecord(
        commonName: ("Ésteres acéticos de mono y diglicéridos de ácidos grasos", "Ésteres acéticos de mono y diglicéridos de ácidos grasos"),
        note: ("Emulsionante de origen graso variable.", "Emulsionante de origen graso variable."),
        origin: .uncertain
    ),
    "E472B": LocalizedAdditiveRecord(
        commonName: ("Ésteres lácticos de mono y diglicéridos de ácidos grasos", "Ésteres lácticos de mono y diglicéridos de ácidos grasos"),
        note: ("Emulsionante de origen graso variable.", "Emulsionante de origen graso variable."),
        origin: .uncertain
    ),
    "E472C": LocalizedAdditiveRecord(
        commonName: ("Ésteres cítricos de mono y diglicéridos de ácidos grasos", "Ésteres cítricos de mono y diglicéridos de ácidos grasos"),
        note: ("Emulsionante de origen graso variable.", "Emulsionante de origen graso variable."),
        origin: .uncertain
    ),
    "E472D": LocalizedAdditiveRecord(
        commonName: ("Ésteres tartáricos de mono y diglicéridos de ácidos grasos", "Ésteres tartáricos de mono y diglicéridos de ácidos grasos"),
        note: ("Emulsionante de origen graso variable.", "Emulsionante de origen graso variable."),
        origin: .uncertain
    ),
    "E472E": LocalizedAdditiveRecord(
        commonName: ("Ésteres monoacetiltartáricos de mono y diglicéridos de ácidos grasos", "Ésteres monoacetiltartáricos de mono y diglicéridos de ácidos grasos"),
        note: ("Emulsionante de origen graso variable.", "Emulsionante de origen graso variable."),
        origin: .uncertain
    ),
    "E472F": LocalizedAdditiveRecord(
        commonName: ("Ésteres mixtos de mono y diglicéridos de ácidos grasos", "Ésteres mixtos de mono y diglicéridos de ácidos grasos"),
        note: ("Emulsionante de origen graso variable.", "Emulsionante de origen graso variable."),
        origin: .uncertain
    ),
    "E473": LocalizedAdditiveRecord(
        commonName: ("Ésteres de sacarosa de ácidos grasos", "Ésteres de sacarosa de ácidos grasos"),
        note: ("Emulsionante de origen graso variable.", "Emulsionante de origen graso variable."),
        origin: .uncertain
    ),
    "E474": LocalizedAdditiveRecord(
        commonName: ("Sacaroglicéridos", "Sacaroglicéridos"),
        note: ("Emulsionante de origen graso variable.", "Emulsionante de origen graso variable."),
        origin: .uncertain
    ),
    "E475": LocalizedAdditiveRecord(
        commonName: ("Ésteres poliglicéricos de ácidos grasos", "Ésteres poliglicéricos de ácidos grasos"),
        note: ("Emulsionante de origen graso variable.", "Emulsionante de origen graso variable."),
        origin: .uncertain
    ),
    "E481": LocalizedAdditiveRecord(
        commonName: ("Estearoil-2-lactilato sódico", "Estearoil-2-lactilato sódico"),
        note: ("Emulsionante con origen graso variable.", "Emulsionante con origen graso variable."),
        origin: .uncertain
    ),
    "E482": LocalizedAdditiveRecord(
        commonName: ("Estearoil-2-lactilato cálcico", "Estearoil-2-lactilato cálcico"),
        note: ("Emulsionante con origen graso variable.", "Emulsionante con origen graso variable."),
        origin: .uncertain
    ),
    "E491": LocalizedAdditiveRecord(
        commonName: ("Monoestearato de sorbitán", "Monoestearato de sorbitán"),
        note: ("Emulsionante de origen graso variable.", "Emulsionante de origen graso variable."),
        origin: .uncertain
    ),
    "E492": LocalizedAdditiveRecord(
        commonName: ("Triestearato de sorbitán", "Triestearato de sorbitán"),
        note: ("Emulsionante de origen graso variable.", "Emulsionante de origen graso variable."),
        origin: .uncertain
    ),
    "E493": LocalizedAdditiveRecord(
        commonName: ("Monolaurato de sorbitán", "Monolaurato de sorbitán"),
        note: ("Emulsionante de origen graso variable.", "Emulsionante de origen graso variable."),
        origin: .uncertain
    ),
    "E494": LocalizedAdditiveRecord(
        commonName: ("Monooleato de sorbitán", "Monooleato de sorbitán"),
        note: ("Emulsionante de origen graso variable.", "Emulsionante de origen graso variable."),
        origin: .uncertain
    ),
    "E495": LocalizedAdditiveRecord(
        commonName: ("Monopalmitato de sorbitán", "Monopalmitato de sorbitán"),
        note: ("Emulsionante de origen graso variable.", "Emulsionante de origen graso variable."),
        origin: .uncertain
    ),
    "E501": LocalizedAdditiveRecord(
        commonName: ("Carbonatos de potasio", "Carbonatos de potasio"),
        note: ("Gasificante y regulador de acidez.", "Gasificante y regulador de acidez."),
        origin: .synthetic
    ),
    "E504": LocalizedAdditiveRecord(
        commonName: ("Carbonatos de magnesio", "Carbonatos de magnesio"),
        note: ("Antiaglomerante y regulador de acidez.", "Antiaglomerante y regulador de acidez."),
        origin: .synthetic
    ),
    "E507": LocalizedAdditiveRecord(
        commonName: ("Ácido clorhídrico", "Ácido clorhídrico"),
        note: ("Regulador de acidez.", "Regulador de acidez."),
        origin: .synthetic
    ),
    "E509": LocalizedAdditiveRecord(
        commonName: ("Cloruro cálcico", "Cloruro cálcico"),
        note: ("Regulador de acidez y firmeza.", "Regulador de acidez y firmeza."),
        origin: .synthetic
    ),
    "E510": LocalizedAdditiveRecord(
        commonName: ("Cloruro amónico", "Cloruro amónico"),
        note: ("Regulador de acidez.", "Regulador de acidez."),
        origin: .synthetic
    ),
    "E524": LocalizedAdditiveRecord(
        commonName: ("Hidróxido sódico", "Hidróxido sódico"),
        note: ("Regulador de acidez.", "Regulador de acidez."),
        origin: .synthetic
    ),
    "E525": LocalizedAdditiveRecord(
        commonName: ("Hidróxido potásico", "Hidróxido potásico"),
        note: ("Regulador de acidez.", "Regulador de acidez."),
        origin: .synthetic
    ),
    "E526": LocalizedAdditiveRecord(
        commonName: ("Hidróxido cálcico", "Hidróxido cálcico"),
        note: ("Regulador de acidez.", "Regulador de acidez."),
        origin: .synthetic
    ),
    "E527": LocalizedAdditiveRecord(
        commonName: ("Hidróxido amónico", "Hidróxido amónico"),
        note: ("Regulador de acidez.", "Regulador de acidez."),
        origin: .synthetic
    ),
    "E528": LocalizedAdditiveRecord(
        commonName: ("Hidróxido magnésico", "Hidróxido magnésico"),
        note: ("Regulador de acidez.", "Regulador de acidez."),
        origin: .synthetic
    ),
    "E530": LocalizedAdditiveRecord(
        commonName: ("Óxido magnésico", "Óxido magnésico"),
        note: ("Antiaglomerante y regulador de acidez.", "Antiaglomerante y regulador de acidez."),
        origin: .synthetic
    ),
    "E551": LocalizedAdditiveRecord(
        commonName: ("Dióxido de silicio", "Dióxido de silicio"),
        note: ("Antiaglomerante de origen mineral.", "Antiaglomerante de origen mineral."),
        origin: .synthetic
    ),
    "E553B": LocalizedAdditiveRecord(
        commonName: ("Talco", "Talco"),
        note: ("Antiaglomerante de origen mineral.", "Antiaglomerante de origen mineral."),
        origin: .synthetic
    ),
    "E620": LocalizedAdditiveRecord(
        commonName: ("Ácido glutámico", "Ácido glutámico"),
        note: ("Potenciador del sabor.", "Potenciador del sabor."),
        origin: .synthetic
    ),
    "E621": LocalizedAdditiveRecord(
        commonName: ("Glutamato monosódico", "Glutamato monosódico"),
        note: ("Potenciador del sabor.", "Potenciador del sabor."),
        origin: .synthetic
    ),
    "E622": LocalizedAdditiveRecord(
        commonName: ("Glutamato monopotásico", "Glutamato monopotásico"),
        note: ("Potenciador del sabor.", "Potenciador del sabor."),
        origin: .synthetic
    ),
    "E623": LocalizedAdditiveRecord(
        commonName: ("Glutamato cálcico", "Glutamato cálcico"),
        note: ("Potenciador del sabor.", "Potenciador del sabor."),
        origin: .synthetic
    ),
    "E624": LocalizedAdditiveRecord(
        commonName: ("Glutamato monoamónico", "Glutamato monoamónico"),
        note: ("Potenciador del sabor.", "Potenciador del sabor."),
        origin: .synthetic
    ),
    "E625": LocalizedAdditiveRecord(
        commonName: ("Glutamato magnésico", "Glutamato magnésico"),
        note: ("Potenciador del sabor.", "Potenciador del sabor."),
        origin: .synthetic
    ),
    "E627": LocalizedAdditiveRecord(
        commonName: ("Guanilato disódico", "Guanilato disódico"),
        note: ("Potenciador del sabor de origen variable.", "Potenciador del sabor de origen variable."),
        origin: .uncertain
    ),
    "E628": LocalizedAdditiveRecord(
        commonName: ("Guanilato dipotásico", "Guanilato dipotásico"),
        note: ("Potenciador del sabor de origen variable.", "Potenciador del sabor de origen variable."),
        origin: .uncertain
    ),
    "E640": LocalizedAdditiveRecord(
        commonName: ("Glicina y su sal sódica", "Glicina y su sal sódica"),
        note: ("Suele obtenerse por síntesis, pero puede proceder de hidrolizados animales.", "Usually produced synthetically, but may come from animal hydrolysates."),
        origin: .uncertain
    ),
    "E900": LocalizedAdditiveRecord(
        commonName: ("Dimetilpolisiloxano", "Dimetilpolisiloxano"),
        note: ("Antiespumante de origen sintético.", "Antiespumante de origen sintético."),
        origin: .synthetic
    ),
    "E902": LocalizedAdditiveRecord(
        commonName: ("Cera de candelilla", "Cera de candelilla"),
        note: ("Cera vegetal usada como recubrimiento.", "Cera vegetal usada como recubrimiento."),
        origin: .plant
    ),
    "E905": LocalizedAdditiveRecord(
        commonName: ("Parafina", "Parafina"),
        note: ("Agente de recubrimiento de origen petroquímico.", "Agente de recubrimiento de origen petroquímico."),
        origin: .synthetic
    ),
    "E907": LocalizedAdditiveRecord(
        commonName: ("Polietileno hidrogenado", "Polietileno hidrogenado"),
        note: ("Agente de recubrimiento sintético.", "Agente de recubrimiento sintético."),
        origin: .synthetic
    ),
    "E913": LocalizedAdditiveRecord(
        commonName: ("Lanolina", "Lanolina"),
        note: ("Agente de recubrimiento procedente de la lana.", "Agente de recubrimiento procedente de la lana."),
        origin: .animal
    ),
    "E914": LocalizedAdditiveRecord(
        commonName: ("Cera oxidada de polietileno", "Cera oxidada de polietileno"),
        note: ("Agente de recubrimiento sintético.", "Agente de recubrimiento sintético."),
        origin: .synthetic
    ),
    "E965": LocalizedAdditiveRecord(
        commonName: ("Maltitol", "Maltitol"),
        note: ("Poliol obtenido industrialmente a partir de almidón.", "Poliol obtenido industrialmente a partir de almidón."),
        origin: .synthetic
    ),
    "E966": LocalizedAdditiveRecord(
        commonName: ("Lactitol", "Lactitol"),
        note: ("Poliol con vínculo lácteo; la materia prima puede variar.", "Poliol con vínculo lácteo; la materia prima puede variar."),
        origin: .uncertain
    ),
    "E967": LocalizedAdditiveRecord(
        commonName: ("Xilitol", "Xilitol"),
        note: ("Poliol de origen vegetal usado como edulcorante.", "Poliol de origen vegetal usado como edulcorante."),
        origin: .plant
    ),
    "E968": LocalizedAdditiveRecord(
        commonName: ("Eritritol", "Eritritol"),
        note: ("Poliol obtenido por fermentación de azúcares.", "Poliol obtenido por fermentación de azúcares."),
        origin: .plant
    ),
    "E999": LocalizedAdditiveRecord(
        commonName: ("Quilaya", "Quilaya"),
        note: ("Extracto vegetal usado como agente espumante.", "Extracto vegetal usado como agente espumante."),
        origin: .plant
    ),
    "E1200": LocalizedAdditiveRecord(
        commonName: ("Polidextrosa", "Polydextrose"),
        note: ("Agente de carga obtenido a partir de glucosa.", "Bulking agent obtained from glucose."),
        origin: .plant
    ),
    "E1201": LocalizedAdditiveRecord(
        commonName: ("Polivinilpirrolidona", "Polyvinylpyrrolidone"),
        note: ("Estabilizante sintético usado en comprimidos.", "Synthetic stabiliser used in tablets."),
        origin: .synthetic
    ),
    "E1202": LocalizedAdditiveRecord(
        commonName: ("Polivinilpolipirrolidona", "Polyvinylpolypyrrolidone"),
        note: ("Clarificante sintético usado en bebidas.", "Synthetic clarifying agent used in beverages."),
        origin: .synthetic
    ),
    "E1204": LocalizedAdditiveRecord(
        commonName: ("Pululano", "Pullulan"),
        note: ("Agente de recubrimiento obtenido por fermentación.", "Coating agent obtained by fermentation."),
        origin: .plant
    ),
    "E1400": LocalizedAdditiveRecord(
        commonName: ("Dextrinas", "Dextrins"),
        note: ("Almidón modificado de origen vegetal.", "Plant-based modified starch."),
        origin: .plant
    ),
    "E1401": LocalizedAdditiveRecord(
        commonName: ("Almidón tratado con ácido", "Acid-treated starch"),
        note: ("Almidón modificado de origen vegetal.", "Plant-based modified starch."),
        origin: .plant
    ),
    "E1402": LocalizedAdditiveRecord(
        commonName: ("Almidón tratado con álcali", "Alkaline-treated starch"),
        note: ("Almidón modificado de origen vegetal.", "Plant-based modified starch."),
        origin: .plant
    ),
    "E1403": LocalizedAdditiveRecord(
        commonName: ("Almidón blanqueado", "Bleached starch"),
        note: ("Almidón modificado de origen vegetal.", "Plant-based modified starch."),
        origin: .plant
    ),
    "E1404": LocalizedAdditiveRecord(
        commonName: ("Almidón oxidado", "Oxidised starch"),
        note: ("Almidón modificado de origen vegetal.", "Plant-based modified starch."),
        origin: .plant
    ),
    "E1410": LocalizedAdditiveRecord(
        commonName: ("Fosfato de monoalmidón", "Monostarch phosphate"),
        note: ("Almidón modificado de origen vegetal.", "Plant-based modified starch."),
        origin: .plant
    ),
    "E1412": LocalizedAdditiveRecord(
        commonName: ("Fosfato de dialmidón", "Distarch phosphate"),
        note: ("Almidón modificado de origen vegetal.", "Plant-based modified starch."),
        origin: .plant
    ),
    "E1413": LocalizedAdditiveRecord(
        commonName: ("Fosfato de dialmidón fosfatado", "Phosphated distarch phosphate"),
        note: ("Almidón modificado de origen vegetal.", "Plant-based modified starch."),
        origin: .plant
    ),
    "E1414": LocalizedAdditiveRecord(
        commonName: ("Fosfato de dialmidón acetilado", "Acetylated distarch phosphate"),
        note: ("Almidón modificado de origen vegetal.", "Plant-based modified starch."),
        origin: .plant
    ),
    "E1420": LocalizedAdditiveRecord(
        commonName: ("Almidón acetilado", "Acetylated starch"),
        note: ("Almidón modificado de origen vegetal.", "Plant-based modified starch."),
        origin: .plant
    ),
    "E1422": LocalizedAdditiveRecord(
        commonName: ("Adipato de dialmidón acetilado", "Acetylated distarch adipate"),
        note: ("Almidón modificado de origen vegetal.", "Plant-based modified starch."),
        origin: .plant
    ),
    "E1440": LocalizedAdditiveRecord(
        commonName: ("Almidón hidroxipropilado", "Hydroxypropyl starch"),
        note: ("Almidón modificado de origen vegetal.", "Plant-based modified starch."),
        origin: .plant
    ),
    "E1442": LocalizedAdditiveRecord(
        commonName: ("Fosfato de dialmidón hidroxipropilado", "Hydroxypropyl distarch phosphate"),
        note: ("Almidón modificado de origen vegetal.", "Plant-based modified starch."),
        origin: .plant
    ),
    "E1450": LocalizedAdditiveRecord(
        commonName: ("Octenilsuccinato sódico de almidón", "Starch sodium octenyl succinate"),
        note: ("Almidón modificado de origen vegetal.", "Plant-based modified starch."),
        origin: .plant
    ),
    "E1451": LocalizedAdditiveRecord(
        commonName: ("Almidón oxidado acetilado", "Acetylated oxidised starch"),
        note: ("Almidón modificado de origen vegetal.", "Plant-based modified starch."),
        origin: .plant
    ),
    "E1452": LocalizedAdditiveRecord(
        commonName: ("Octenilsuccinato de almidón y aluminio", "Starch aluminium octenyl succinate"),
        note: ("Almidón modificado de origen vegetal.", "Plant-based modified starch."),
        origin: .plant
    ),
    "E1505": LocalizedAdditiveRecord(
        commonName: ("Citrato de trietilo", "Triethyl citrate"),
        note: ("Disolvente y agente de recubrimiento de síntesis.", "Synthetic solvent and coating agent."),
        origin: .synthetic
    ),
    "E1517": LocalizedAdditiveRecord(
        commonName: ("Diacetato de glicerilo", "Glyceryl diacetate"),
        note: ("Disolvente de origen graso variable.", "Solvent with variable fat source."),
        origin: .uncertain
    ),
    "E1518": LocalizedAdditiveRecord(
        commonName: ("Triacetato de glicerilo", "Glyceryl triacetate"),
        note: ("Disolvente de origen graso variable.", "Solvent with variable fat source."),
        origin: .uncertain
    ),
    "E1519": LocalizedAdditiveRecord(
        commonName: ("Alcohol bencílico", "Benzyl alcohol"),
        note: ("Disolvente de aromas de síntesis.", "Synthetic flavour solvent."),
        origin: .synthetic
    ),
    "E1520": LocalizedAdditiveRecord(
        commonName: ("Propilenglicol", "Propylene glycol"),
        note: ("Humectante y disolvente de síntesis.", "Synthetic humectant and solvent."),
        origin: .synthetic
    ),
]

func additiveEntry(for rawCode: String) -> AdditiveEntry? {
    let code = normalizeAdditiveCode(rawCode)
    let resolvedCode = additiveCatalog[code] != nil ? code : romanParentCode(for: code)
    guard let resolvedCode, let record = additiveCatalog[resolvedCode] else { return nil }
    return AdditiveEntry(
        code: resolvedCode,
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

func normalizeAdditiveCode(_ rawCode: String) -> String {
    let trimmed = rawCode.trimmingCharacters(in: .whitespacesAndNewlines)
    let codeOnly: String
    if let colonIndex = trimmed.firstIndex(of: ":") {
        codeOnly = String(trimmed[trimmed.index(after: colonIndex)...])
    } else {
        codeOnly = trimmed
    }
    return codeOnly.uppercased()
}

private func romanParentCode(for code: String) -> String? {
    guard code.range(of: #"^E\d{3,4}[IVX]+$"#, options: .regularExpression) != nil else {
        return nil
    }
    return code.replacingOccurrences(
        of: #"[IVX]+$"#,
        with: "",
        options: .regularExpression
    )
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
