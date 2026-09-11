import Foundation

enum ProductCategory: String, CaseIterable, Codable, Hashable {
    case beverages = "BEVERAGES"
    case dairyAndAlternatives = "DAIRY_AND_ALTERNATIVES"
    case sweetSnacks = "SWEET_SNACKS"
    case saltySnacks = "SALTY_SNACKS"
    case bakeryAndCereals = "BAKERY_AND_CEREALS"
    case fruitsAndVegetables = "FRUITS_AND_VEGETABLES"
    case legumesPastaRice = "LEGUMES_PASTA_RICE"
    case saucesAndCondiments = "SAUCES_AND_CONDIMENTS"
    case preparedAndFrozen = "PREPARED_AND_FROZEN"
    case meatFishEggs = "MEAT_FISH_EGGS"
    case cosmeticsAndHygiene = "COSMETICS_AND_HYGIENE"
    case petFood = "PET_FOOD"
    case other = "OTHER"

    var localizedName: String {
        L("product_category_\(rawValue.lowercased())")
    }
}

private let productCategoryTags: [String: ProductCategory] = {
    var map: [String: ProductCategory] = [:]
    func add(_ tags: [String], _ category: ProductCategory) {
        tags.forEach { map[$0] = category }
    }
    add(["dairies", "dairy-substitutes", "milks", "plant-based-milks", "plant-milks",
         "cheeses", "cheese-substitutes", "yogurts", "plant-based-yogurts", "creams",
         "butters", "fermented-milk-products", "fermented-dairy-desserts"], .dairyAndAlternatives)
    add(["beverages", "beverages-and-beverages-preparations", "waters", "spring-waters",
         "mineral-waters", "juices", "fruit-juices", "fruit-based-beverages", "sodas",
         "carbonated-drinks", "energy-drinks", "coffees", "teas", "herbal-teas",
         "alcoholic-beverages", "beers", "wines"], .beverages)
    add(["sweet-snacks", "sugary-snacks", "chocolates", "chocolate-candies",
         "biscuits-and-cakes", "biscuits", "cakes", "candies", "confectioneries",
         "desserts", "ice-cream", "frozen-desserts", "spreads", "sweet-spreads",
         "chocolate-spreads", "jams", "honeys"], .sweetSnacks)
    add(["salty-snacks", "appetizers", "crisps", "chips-and-fries", "crackers",
         "popcorn", "nuts", "salted-nuts", "nuts-and-their-products", "seeds"], .saltySnacks)
    add(["breads", "bread", "sandwich-breads", "viennoiserie", "viennoiseries",
         "pastries", "breakfast-cereals", "cereals-and-their-products",
         "cereals-and-potatoes", "flours", "wheat-flours", "biscuit-and-cake-mixes",
         "toasts"], .bakeryAndCereals)
    add(["fruits", "vegetables", "fruits-and-vegetables-based-foods", "fresh-vegetables",
         "fresh-fruits", "canned-vegetables", "canned-fruits", "frozen-vegetables",
         "dried-fruits", "olives", "mushrooms", "potatoes"], .fruitsAndVegetables)
    add(["legumes", "legumes-and-their-products", "pulses", "lentils", "chickpeas",
         "beans", "pastas", "fresh-pastas", "dry-pastas", "noodles", "rices",
         "cereal-grains", "couscous", "quinoa"], .legumesPastaRice)
    add(["sauces", "tomato-sauces", "condiments", "dressings", "salad-dressings",
         "mayonnaises", "ketchup", "mustards", "vinegars", "spices", "herbs-and-spices",
         "salts", "fats", "vegetable-fats", "fats-and-oils", "vegetable-oils",
         "olive-oils"], .saucesAndCondiments)
    add(["meals", "prepared-meals", "ready-made-meals", "frozen-foods", "pizzas",
         "pizzas-pies-and-quiches", "sandwiches", "soups", "canned-foods", "salads",
         "hamburgers"], .preparedAndFrozen)
    add(["meats", "meats-and-their-products", "prepared-meats", "poultry", "chicken",
         "beef", "pork", "charcuteries", "sausages", "hams", "fishes",
         "fishes-and-their-products", "seafood", "canned-fishes", "eggs", "chicken-eggs"],
        .meatFishEggs)
    return map
}()

func categoryFor(source: ProductSource, categoriesTags: [String]?) -> ProductCategory {
    switch source {
    case .openBeautyFacts:
        return .cosmeticsAndHygiene
    case .openPetFoodFacts:
        return .petFood
    case .openProductFacts:
        return .other
    case .openFoodFacts:
        return categoriesTags?
            .reversed()
            .compactMap { tag in
                productCategoryTags[tag.trimmingCharacters(in: .whitespacesAndNewlines)
                    .lowercased()
                    .split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
                    .last
                    .map(String.init)]
            }
            .compactMap { productCategoryTags[$0] }
            .first ?? .other
    }
}

extension Optional where Wrapped == String {
    func persistedProductCategory() -> ProductCategory {
        guard let value = self, let category = ProductCategory(rawValue: value) else {
            return .other
        }
        return category
    }
}
