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
    let ingredientsLanguage: String?
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
    let packagings: [PackagingData]?

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case brands
        case imageUrl = "image_url"
        case ingredientsText = "ingredients_text"
        case ingredientsLanguage = "ingredients_lc"
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
        case packagings
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
        ecoscoreData: EnvironmentalScoreData? = nil,
        packagings: [PackagingData]? = nil,
        ingredientsLanguage: String? = nil
    ) {
        self.productName = productName
        self.ingredientsLanguage = ingredientsLanguage
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
        self.packagings = packagings
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        productName = try? container.decodeIfPresent(String.self, forKey: .productName)
        brands = try? container.decodeIfPresent(String.self, forKey: .brands)
        imageUrl = try? container.decodeIfPresent(String.self, forKey: .imageUrl)
        ingredientsText = try? container.decodeIfPresent(String.self, forKey: .ingredientsText)
        let languageContainer = try? decoder.container(keyedBy: ProductLanguageKeys.self)
        ingredientsLanguage = (try? container.decodeIfPresent(String.self, forKey: .ingredientsLanguage))
            ?? (try? languageContainer?.decodeIfPresent(String.self, forKey: .lang))
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
        packagings = try? container.decodeIfPresent([PackagingData].self, forKey: .packagings)
        novaGroup = container.decodeFlexibleInt(forKey: .novaGroup)
        quantity = try? container.decodeIfPresent(String.self, forKey: .quantity)
    }
}

private enum ProductLanguageKeys: String, CodingKey {
    case lang
}

struct OffIngredient: Codable {
    let id: String?
    let text: String?
    let vegan: String?
    let vegetarian: String?
    let ingredients: [OffIngredient]?

    init(
        id: String? = nil,
        text: String?,
        vegan: String?,
        vegetarian: String?,
        ingredients: [OffIngredient]? = nil
    ) {
        self.id = id
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
    let adjustments: EnvironmentalScoreAdjustments?
    let score: Int?
    let grade: String?
    let scores: [String: Int]?
    let grades: [String: String]?
    let status: String?
    let missing: [String: Int]?
    let missingDataWarning: Int?

    init(
        agribalyse: Agribalyse? = nil,
        adjustments: EnvironmentalScoreAdjustments? = nil,
        score: Int? = nil,
        grade: String? = nil,
        scores: [String: Int]? = nil,
        grades: [String: String]? = nil,
        status: String? = nil,
        missing: [String: Int]? = nil,
        missingDataWarning: Int? = nil
    ) {
        self.agribalyse = agribalyse
        self.adjustments = adjustments
        self.score = score
        self.grade = grade
        self.scores = scores
        self.grades = grades
        self.status = status
        self.missing = missing
        self.missingDataWarning = missingDataWarning
    }

    enum CodingKeys: String, CodingKey {
        case agribalyse
        case adjustments
        case score
        case grade
        case scores
        case grades
        case status
        case missing
        case missingDataWarning = "missing_data_warning"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        agribalyse = try? container.decodeIfPresent(Agribalyse.self, forKey: .agribalyse)
        adjustments = try? container.decodeIfPresent(EnvironmentalScoreAdjustments.self, forKey: .adjustments)
        score = container.decodeFlexibleInt(forKey: .score)
        grade = try? container.decodeIfPresent(String.self, forKey: .grade)
        scores = try? container.decodeIfPresent([String: Int].self, forKey: .scores)
        grades = try? container.decodeIfPresent([String: String].self, forKey: .grades)
        status = try? container.decodeIfPresent(String.self, forKey: .status)
        missing = try? container.decodeIfPresent([String: Int].self, forKey: .missing)
        missingDataWarning = container.decodeFlexibleInt(forKey: .missingDataWarning)
    }
}

struct Agribalyse: Codable {
    let co2Total: Double?
    let co2Agriculture: Double?
    let co2Processing: Double?
    let co2Packaging: Double?
    let co2Transportation: Double?
    let co2Distribution: Double?
    let co2Consumption: Double?
    let score: Int?
    let nameEn: String?
    let nameFr: String?

    enum CodingKeys: String, CodingKey {
        case co2Total = "co2_total"
        case co2Agriculture = "co2_agriculture"
        case co2Processing = "co2_processing"
        case co2Packaging = "co2_packaging"
        case co2Transportation = "co2_transportation"
        case co2Distribution = "co2_distribution"
        case co2Consumption = "co2_consumption"
        case score
        case nameEn = "name_en"
        case nameFr = "name_fr"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        co2Total = try container.decodeFlexibleDouble(forKey: .co2Total)
        co2Agriculture = try container.decodeFlexibleDouble(forKey: .co2Agriculture)
        co2Processing = try container.decodeFlexibleDouble(forKey: .co2Processing)
        co2Packaging = try container.decodeFlexibleDouble(forKey: .co2Packaging)
        co2Transportation = try container.decodeFlexibleDouble(forKey: .co2Transportation)
        co2Distribution = try container.decodeFlexibleDouble(forKey: .co2Distribution)
        co2Consumption = try container.decodeFlexibleDouble(forKey: .co2Consumption)
        score = container.decodeFlexibleInt(forKey: .score)
        nameEn = try? container.decodeIfPresent(String.self, forKey: .nameEn)
        nameFr = try? container.decodeIfPresent(String.self, forKey: .nameFr)
    }

    init(
        co2Total: Double? = nil,
        co2Agriculture: Double? = nil,
        co2Processing: Double? = nil,
        co2Packaging: Double? = nil,
        co2Transportation: Double? = nil,
        co2Distribution: Double? = nil,
        co2Consumption: Double? = nil,
        score: Int? = nil,
        nameEn: String? = nil,
        nameFr: String? = nil
    ) {
        self.co2Total = co2Total
        self.co2Agriculture = co2Agriculture
        self.co2Processing = co2Processing
        self.co2Packaging = co2Packaging
        self.co2Transportation = co2Transportation
        self.co2Distribution = co2Distribution
        self.co2Consumption = co2Consumption
        self.score = score
        self.nameEn = nameEn
        self.nameFr = nameFr
    }
}

struct EnvironmentalScoreAdjustments: Codable {
    let packaging: PackagingAdjustments?
    let originsOfIngredients: OriginsOfIngredientsAdjustments?
    let productionSystem: ProductionSystemAdjustments?
    let threatenedSpecies: ThreatenedSpeciesAdjustments?

    enum CodingKeys: String, CodingKey {
        case packaging
        case originsOfIngredients = "origins_of_ingredients"
        case productionSystem = "production_system"
        case threatenedSpecies = "threatened_species"
    }

    init(
        packaging: PackagingAdjustments? = nil,
        originsOfIngredients: OriginsOfIngredientsAdjustments? = nil,
        productionSystem: ProductionSystemAdjustments? = nil,
        threatenedSpecies: ThreatenedSpeciesAdjustments? = nil
    ) {
        self.packaging = packaging
        self.originsOfIngredients = originsOfIngredients
        self.productionSystem = productionSystem
        self.threatenedSpecies = threatenedSpecies
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        packaging = try? container.decodeIfPresent(PackagingAdjustments.self, forKey: .packaging)
        originsOfIngredients = try? container.decodeIfPresent(
            OriginsOfIngredientsAdjustments.self,
            forKey: .originsOfIngredients
        )
        productionSystem = try? container.decodeIfPresent(
            ProductionSystemAdjustments.self,
            forKey: .productionSystem
        )
        threatenedSpecies = try? container.decodeIfPresent(
            ThreatenedSpeciesAdjustments.self,
            forKey: .threatenedSpecies
        )
    }
}

struct PackagingAdjustments: Codable {
    let value: Int?
    let nonRecyclableAndNonBiodegradableMaterials: Int?
    let score: Int?
    let packagings: [PackagingData]?

    enum CodingKeys: String, CodingKey {
        case value
        case nonRecyclableAndNonBiodegradableMaterials = "non_recyclable_and_non_biodegradable_materials"
        case score
        case packagings
    }

    init(
        value: Int? = nil,
        nonRecyclableAndNonBiodegradableMaterials: Int? = nil,
        score: Int? = nil,
        packagings: [PackagingData]? = nil
    ) {
        self.value = value
        self.nonRecyclableAndNonBiodegradableMaterials = nonRecyclableAndNonBiodegradableMaterials
        self.score = score
        self.packagings = packagings
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = container.decodeFlexibleInt(forKey: .value)
        nonRecyclableAndNonBiodegradableMaterials = container.decodeFlexibleInt(
            forKey: .nonRecyclableAndNonBiodegradableMaterials
        )
        score = container.decodeFlexibleInt(forKey: .score)
        packagings = try? container.decodeIfPresent([PackagingData].self, forKey: .packagings)
    }
}

struct OriginsOfIngredientsAdjustments: Codable {
    let transportationValue: Int?
    let epiValue: Int?
    let warning: String?
    let aggregatedOrigins: [AggregatedOrigin]?

    enum CodingKeys: String, CodingKey {
        case transportationValue = "transportation_value"
        case epiValue = "epi_value"
        case warning
        case aggregatedOrigins = "aggregated_origins"
    }

    init(
        transportationValue: Int? = nil,
        warning: String? = nil,
        epiValue: Int? = nil,
        aggregatedOrigins: [AggregatedOrigin]? = nil
    ) {
        self.transportationValue = transportationValue
        self.epiValue = epiValue
        self.warning = warning
        self.aggregatedOrigins = aggregatedOrigins
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        transportationValue = container.decodeFlexibleInt(forKey: .transportationValue)
        epiValue = container.decodeFlexibleInt(forKey: .epiValue)
        warning = try? container.decodeIfPresent(String.self, forKey: .warning)
        aggregatedOrigins = try? container.decodeIfPresent([AggregatedOrigin].self, forKey: .aggregatedOrigins)
    }
}

struct ProductionSystemAdjustments: Codable {
    let value: Int?
    let labels: [String]?
    let warning: String?

    enum CodingKeys: String, CodingKey {
        case value
        case labels
        case warning
    }

    init(value: Int? = nil, labels: [String]? = nil, warning: String? = nil) {
        self.value = value
        self.labels = labels
        self.warning = warning
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = container.decodeFlexibleInt(forKey: .value)
        labels = try? container.decodeIfPresent([String].self, forKey: .labels)
        warning = try? container.decodeIfPresent(String.self, forKey: .warning)
    }
}

struct ThreatenedSpeciesAdjustments: Codable {
    let value: Int?

    enum CodingKeys: String, CodingKey {
        case value
    }

    init(value: Int? = nil) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = container.decodeFlexibleInt(forKey: .value)
    }
}

struct AggregatedOrigin: Codable {
    let origin: String?
    let percent: Double?

    init(origin: String? = nil, percent: Double? = nil) {
        self.origin = origin
        self.percent = percent
    }

    enum CodingKeys: String, CodingKey {
        case origin
        case percent
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        origin = try? container.decodeIfPresent(String.self, forKey: .origin)
        percent = try container.decodeFlexibleDouble(forKey: .percent)
    }
}

struct PackagingData: Codable {
    let material: String?
    let shape: String?
    let recycling: String?
    let nonRecyclableAndNonBiodegradable: String?

    init(
        material: String? = nil,
        shape: String? = nil,
        recycling: String? = nil,
        nonRecyclableAndNonBiodegradable: String? = nil
    ) {
        self.material = material
        self.shape = shape
        self.recycling = recycling
        self.nonRecyclableAndNonBiodegradable = nonRecyclableAndNonBiodegradable
    }

    enum CodingKeys: String, CodingKey {
        case material
        case shape
        case recycling
        case nonRecyclableAndNonBiodegradable = "non_recyclable_and_non_biodegradable"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        material = try? container.decodeIfPresent(String.self, forKey: .material)
        shape = try? container.decodeIfPresent(String.self, forKey: .shape)
        recycling = try? container.decodeIfPresent(String.self, forKey: .recycling)
        nonRecyclableAndNonBiodegradable = try? container.decodeIfPresent(
            String.self,
            forKey: .nonRecyclableAndNonBiodegradable
        )
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

    var greenScoreBreakdown: GreenScoreBreakdown? {
        (environmentalScoreData ?? ecoscoreData)?.greenScoreBreakdown(for: self)
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

    var carbonFootprintLevel: CarbonFootprintLevel? {
        guard let value = carbonFootprint?.value else { return nil }
        return carbonFootprintLevelFor(value)
    }

    var environmentalImpact: EnvironmentalImpact? {
        let data = environmentalScoreData ?? ecoscoreData
        let stages = data?.agribalyse?.carbonStages ?? []
        let categoryName: String? = {
            switch Locale.current.language.languageCode?.identifier.lowercased() {
            case "en": return data?.agribalyse?.nameEn
            case "fr": return data?.agribalyse?.nameFr
            default: return nil
            }
        }()
        let adjustmentPackagings = data?.adjustments?.packaging?.packagings ?? []
        let packagingData = adjustmentPackagings.isEmpty ? (packagings ?? []) : adjustmentPackagings
        let packaging = packagingData.compactMap { component -> PackagingComponent? in
            guard component.material?.isEmpty == false ||
                component.shape?.isEmpty == false ||
                component.recycling?.isEmpty == false else {
                return nil
            }
            let raw = component.nonRecyclableAndNonBiodegradable?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let recyclability: PackagingRecyclability
            switch raw {
            case "yes": recyclability = .nonRecyclable
            case "maybe": recyclability = .maybeNonRecyclable
            case "no": recyclability = .recyclable
            default: recyclability = .unknown
            }
            return PackagingComponent(
                materialTag: component.material?.isEmpty == false ? component.material : nil,
                shapeTag: component.shape?.isEmpty == false ? component.shape : nil,
                recyclingTag: component.recycling?.isEmpty == false ? component.recycling : nil,
                recyclability: recyclability
            )
        }
        guard !stages.isEmpty || !packaging.isEmpty else {
            return nil
        }
        return EnvironmentalImpact(
            stages: stages,
            categoryName: categoryName,
            packaging: packaging
        )
    }
}

private extension Agribalyse {
    var carbonStages: [CarbonFootprintStage] {
        let rawValues: [(CarbonStage, Double?)] = [
            (.agriculture, co2Agriculture),
            (.processing, co2Processing),
            (.transport, co2Transportation),
            (.packaging, co2Packaging),
            (.distribution, co2Distribution),
            (.consumption, co2Consumption)
        ]
        let values = rawValues.compactMap { (stage, value) -> (CarbonStage, Double)? in
            guard let value, value > 0 else { return nil }
            return (stage, value * 100)
        }.sorted { $0.1 > $1.1 }
        guard values.count >= 2 else { return [] }
        let total = values.reduce(0) { $0 + $1.1 }
        let exactShares = values.map { $0.1 / total * 100 }
        var shares = exactShares.map { Int(floor($0)) }
        let remaining = 100 - shares.reduce(0, +)
        exactShares.enumerated()
            .sorted {
                let leftFraction = $0.element - floor($0.element)
                let rightFraction = $1.element - floor($1.element)
                return leftFraction == rightFraction ? $0.offset < $1.offset : leftFraction > rightFraction
            }
            .prefix(remaining)
            .forEach { shares[$0.offset] += 1 }
        return values.enumerated().map { index, value in
            CarbonFootprintStage(stage: value.0, gramsPer100g: value.1, sharePercent: shares[index])
        }
    }
}

private extension EnvironmentalScoreData {
    func greenScoreBreakdown(for product: Product) -> GreenScoreBreakdown? {
        let adjustmentData = adjustments
        var adjustmentValues: [GreenScoreAdjustment] = []
        if let points = adjustmentData?.packaging?.value, points != 0 {
            adjustmentValues.append(GreenScoreAdjustment(kind: .packaging, points: points))
        }
        if let origins = adjustmentData?.originsOfIngredients {
            let points: Int
            if origins.epiValue != nil || origins.transportationValue != nil {
                points = (origins.epiValue ?? 0) + (origins.transportationValue ?? 0)
            } else {
                points = 0
            }
            let unknown = !(origins.warning?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            let unknownPoints = origins.epiValue != nil && origins.transportationValue != nil
                ? points
                : origins.transportationValue ?? 0
            if points != 0 || unknown {
                adjustmentValues.append(GreenScoreAdjustment(
                    kind: .origins,
                    points: unknown ? unknownPoints : points,
                    unknownOrigin: unknown
                ))
            }
        }
        if let production = adjustmentData?.productionSystem,
           (production.value ?? 0) != 0 || production.warning == "no_label" {
            adjustmentValues.append(GreenScoreAdjustment(
                kind: .productionSystem,
                points: production.value ?? 0,
                noProductionLabel: production.warning == "no_label"
            ))
        }
        if let points = adjustmentData?.threatenedSpecies?.value, points != 0 {
            adjustmentValues.append(GreenScoreAdjustment(kind: .threatenedSpecies, points: points))
        }
        let country = Locale.current.region?.identifier.lowercased() ?? ""
        let finalScore = (countryValues(scores, country: country) + [score, product.greenScoreValue].compactMap { $0 })
            .first { (0...100).contains($0) }
        let finalGrade = (countryValues(grades, country: country) + [grade, product.greenScoreGrade].compactMap { $0 })
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() }
            .first { ["A", "B", "C", "D", "E"].contains($0) }
        let breakdown = GreenScoreBreakdown(
            baseScore: agribalyse?.score.flatMap { (0...100).contains($0) ? $0 : nil },
            finalScore: finalScore.flatMap { (0...100).contains($0) ? $0 : nil },
            grade: finalGrade,
            adjustments: adjustmentValues
        )
        return breakdown.baseScore != nil ||
            breakdown.finalScore != nil ||
            breakdown.grade != nil ||
            !breakdown.adjustments.isEmpty ? breakdown : nil
    }
}

private func countryValues<T>(_ values: [String: T]?, country: String) -> [T] {
    guard let values else { return [] }
    let normalized = values.reduce(into: [String: T]()) {
        $0[$1.key.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()] = $1.value
    }
    var result: [T] = []
    if let value = normalized[country] {
        result.append(value)
    }
    if country != "world", let value = normalized["world"] {
        result.append(value)
    }
    return result
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

enum CarbonFootprintLevel: Equatable {
    case low
    case moderate
    case high
}

struct CarbonFootprint {
    let value: Double
    let source: CarbonFootprintSource
}

func carbonFootprintLevelFor(_ value: Double) -> CarbonFootprintLevel {
    if value < 150 { return .low }
    if value <= 500 { return .moderate }
    return .high
}

enum CarbonStage: Equatable {
    case agriculture
    case processing
    case transport
    case packaging
    case distribution
    case consumption
}

struct CarbonFootprintStage: Equatable {
    let stage: CarbonStage
    let gramsPer100g: Double
    let sharePercent: Int
}

enum GreenScoreAdjustmentKind: Equatable {
    case packaging
    case origins
    case productionSystem
    case threatenedSpecies
}

struct GreenScoreAdjustment: Equatable {
    let kind: GreenScoreAdjustmentKind
    let points: Int
    let unknownOrigin: Bool
    let noProductionLabel: Bool

    init(
        kind: GreenScoreAdjustmentKind,
        points: Int,
        unknownOrigin: Bool = false,
        noProductionLabel: Bool = false
    ) {
        self.kind = kind
        self.points = points
        self.unknownOrigin = unknownOrigin
        self.noProductionLabel = noProductionLabel
    }
}

struct GreenScoreBreakdown: Equatable {
    let baseScore: Int?
    let finalScore: Int?
    let grade: String?
    let adjustments: [GreenScoreAdjustment]
}

enum PackagingRecyclability: Equatable {
    case recyclable
    case maybeNonRecyclable
    case nonRecyclable
    case unknown
}

struct PackagingComponent: Equatable {
    let materialTag: String?
    let shapeTag: String?
    let recyclingTag: String?
    let recyclability: PackagingRecyclability
}

struct EnvironmentalImpact: Equatable {
    let stages: [CarbonFootprintStage]
    let categoryName: String?
    let packaging: [PackagingComponent]
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
            return URL(string: "https://world.openproductsfacts.org")!
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
    var verdict: String?
    var category: String?

    init(
        barcode: String,
        productName: String?,
        brand: String?,
        imageURL: String?,
        timestamp: Date = Date(),
        verdict: String? = nil,
        category: String? = nil
    ) {
        self.barcode = barcode
        self.productName = productName
        self.brand = brand
        self.imageURL = imageURL
        self.timestamp = timestamp
        self.verdict = verdict
        self.category = category
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
    var verdict: String?
    var category: String?

    init(
        barcode: String,
        productName: String?,
        brand: String?,
        imageURL: String?,
        addedAt: Date = Date(),
        verdict: String? = nil,
        category: String? = nil
    ) {
        self.barcode = barcode
        self.productName = productName
        self.brand = brand
        self.imageURL = imageURL
        self.addedAt = addedAt
        self.verdict = verdict
        self.category = category
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

private struct LocalizedAdditiveRecord: Decodable {
    let code: String
    let origin: String
    let name: [String: String]
    let note: [String: String]

    var additiveOrigin: AdditiveOrigin {
        switch origin {
        case "animal": return .animal
        case "plant": return .plant
        case "synthetic": return .synthetic
        case "uncertain": return .uncertain
        default: return .unknown
        }
    }
}

private struct AdditiveCatalogFile: Decodable {
    let additives: [LocalizedAdditiveRecord]
}

private final class AdditiveCatalogBundleToken {}

private let additiveCatalog: [String: LocalizedAdditiveRecord] = {
    guard let url = Bundle(for: AdditiveCatalogBundleToken.self).url(forResource: "additives", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let file = try? JSONDecoder().decode(AdditiveCatalogFile.self, from: data) else {
        assertionFailure("Missing or invalid additives.json")
        return [:]
    }
    return Dictionary(file.additives.map { ($0.code, $0) }, uniquingKeysWith: { first, _ in first })
}()

func additiveEntry(for rawCode: String) -> AdditiveEntry? {
    let code = normalizeAdditiveCode(rawCode)
    let resolvedCode = additiveCatalog[code] != nil ? code : romanParentCode(for: code)
    guard let resolvedCode, let record = additiveCatalog[resolvedCode] else { return nil }
    return AdditiveEntry(
        code: resolvedCode,
        info: AdditiveInfo(
            commonName: localizedAdditiveText(record.name),
            origin: record.additiveOrigin,
            note: localizedAdditiveText(record.note) ?? ""
        )
    )
}

func allAdditiveEntries() -> [AdditiveEntry] {
    func number(_ code: String) -> Int {
        Int(code.dropFirst().prefix { $0.isNumber }) ?? Int.max
    }
    return additiveCatalog.keys
        .filter { code in
            guard let parent = romanParentCode(for: code) else { return true }
            return additiveCatalog[parent] == nil
        }
        .sorted { lhs, rhs in
            let (left, right) = (number(lhs), number(rhs))
            return left != right ? left < right : lhs < rhs
        }
        .compactMap { additiveEntry(for: $0) }
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

private let additiveLanguages: Set<String> = ["es", "en", "pt", "it", "fr", "de"]

private func localizedAdditiveText(_ values: [String: String]) -> String? {
    values[additiveLanguageCode()] ?? values["es"]
}

func additiveLanguageCode(preferredLanguages: [String] = Locale.preferredLanguages) -> String {
    let identifier = (preferredLanguages.first ?? Locale.current.identifier).lowercased()
    let language = String(identifier.prefix { $0 != "-" && $0 != "_" })
    return additiveLanguages.contains(language) ? language : "es"
}

@Model
final class ShoppingListItem {
    @Attribute(.unique) var barcode: String
    var productName: String?
    var brand: String?
    var imageURL: String?
    var verdict: String?
    var addedAt: Date
    var checked: Bool

    init(
        barcode: String,
        productName: String?,
        brand: String?,
        imageURL: String?,
        verdict: String? = nil,
        addedAt: Date = Date(),
        checked: Bool = false
    ) {
        self.barcode = barcode
        self.productName = productName
        self.brand = brand
        self.imageURL = imageURL
        self.verdict = verdict
        self.addedAt = addedAt
        self.checked = checked
    }
}
