import Foundation
import SwiftData

struct OpenFactsResponse: Decodable {
    let status: Int
    let product: Product?
}

struct Product: Codable {
    let productName: String?
    let brands: String?
    let imageUrl: String?
    let ingredientsText: String?
    let ingredientsAnalysisTags: [String]?
    let ingredients: [OffIngredient]?
    let additivesTags: [String]?
    let allergensTags: [String]?
    let nutriments: Nutriments?
    let nutriscoreGrade: String?
    let quantity: String?

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case brands
        case imageUrl = "image_url"
        case ingredientsText = "ingredients_text"
        case ingredientsAnalysisTags = "ingredients_analysis_tags"
        case ingredients
        case additivesTags = "additives_tags"
        case allergensTags = "allergens_tags"
        case nutriments
        case nutriscoreGrade = "nutriscore_grade"
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

enum ProductSource: String, CaseIterable, Codable {
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
