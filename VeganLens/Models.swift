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
        quantity: String?
    ) {
        self.productName = productName
        self.brands = brands
        self.imageUrl = imageUrl
        self.ingredientsText = ingredientsText
        self.ingredientsAnalysisTags = ingredientsAnalysisTags
        self.categoriesTags = categoriesTags
        self.labelsTags = labelsTags
        self.ingredients = ingredients
        self.additivesTags = additivesTags
        self.allergensTags = allergensTags
        self.nutriments = nutriments
        self.nutriscoreGrade = nutriscoreGrade
        self.ecoscoreGrade = ecoscoreGrade
        self.novaGroup = novaGroup
        self.quantity = quantity
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
        ingredients = try? container.decodeIfPresent([OffIngredient].self, forKey: .ingredients)
        additivesTags = try? container.decodeIfPresent([String].self, forKey: .additivesTags)
        allergensTags = try? container.decodeIfPresent([String].self, forKey: .allergensTags)
        nutriments = try? container.decodeIfPresent(Nutriments.self, forKey: .nutriments)
        nutriscoreGrade = try? container.decodeIfPresent(String.self, forKey: .nutriscoreGrade)
        ecoscoreGrade = try? container.decodeIfPresent(String.self, forKey: .ecoscoreGrade)
        novaGroup = container.decodeFlexibleInt(forKey: .novaGroup)
        quantity = try? container.decodeIfPresent(String.self, forKey: .quantity)
    }
}

struct OffIngredient: Codable {
    let text: String?
    let vegan: String?
    let vegetarian: String?
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

    enum CodingKeys: String, CodingKey {
        case energyKcal100g = "energy-kcal_100g"
        case energyKj100g = "energy-kj_100g"
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
        energyKj100g = try container.decodeFlexibleDouble(forKey: .energyKj100g)
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
    "E270": LocalizedAdditiveRecord(
        commonName: ("Ácido láctico", "Lactic acid"),
        note: ("Regulador de acidez; se obtiene casi siempre por fermentación de azúcares vegetales, pero puede proceder de lácteos.", "Acidity regulator; almost always produced by fermenting plant sugars, but it may come from dairy."),
        origin: .uncertain
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
        note: ("Potenciador y corrector del sabor.", "Potenciador y corrector del sabor."),
        origin: .synthetic
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
