import XCTest
@testable import VeganLens

final class ProductCategoryTests: XCTestCase {
    func testRecognizesEveryTagCategory() {
        let cases: [(ProductCategory, String)] = [
            (.dairyAndAlternatives, "en:plant-based-milks"),
            (.beverages, "en:sodas"),
            (.sweetSnacks, "en:chocolates"),
            (.saltySnacks, "en:crisps"),
            (.bakeryAndCereals, "en:breads"),
            (.fruitsAndVegetables, "en:vegetables"),
            (.legumesPastaRice, "en:lentils"),
            (.saucesAndCondiments, "en:ketchup"),
            (.preparedAndFrozen, "en:pizzas"),
            (.meatFishEggs, "en:eggs")
        ]
        for (category, tag) in cases {
            XCTAssertEqual(categoryFor(source: .openFoodFacts, categoriesTags: [tag]), category)
        }
    }

    func testSpecificTagWinsAndUnknownTagsFallback() {
        XCTAssertEqual(
            categoryFor(source: .openFoodFacts, categoriesTags: ["en:beverages", "fr:plant-based-milks"]),
            .dairyAndAlternatives
        )
        XCTAssertEqual(categoryFor(source: .openFoodFacts, categoriesTags: ["es:bebidas"]), .other)
        XCTAssertEqual(categoryFor(source: .openFoodFacts, categoriesTags: nil), .other)
    }

    func testSiblingSourcesIgnoreFoodTags() {
        let tags = ["en:beverages"]
        XCTAssertEqual(categoryFor(source: .openBeautyFacts, categoriesTags: tags), .cosmeticsAndHygiene)
        XCTAssertEqual(categoryFor(source: .openPetFoodFacts, categoriesTags: tags), .petFood)
        XCTAssertEqual(categoryFor(source: .openProductFacts, categoriesTags: tags), .other)
    }
}
