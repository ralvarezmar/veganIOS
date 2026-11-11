import XCTest
@testable import VeganLens

final class DishPhotoAnalyzerTests: XCTestCase {
    func testIgnoresNonFoodLabels() {
        XCTAssertNil(DishPhotoAnalyzer.recognizedFood("table"))
        XCTAssertNil(DishPhotoAnalyzer.recognizedFood("food"))
    }

    func testRecognizesSpecificFoodsAndNormalizesIdentifiers() {
        XCTAssertEqual(DishPhotoAnalyzer.recognizedFood("hot_dog"), .hotDog)
        XCTAssertEqual(DishPhotoAnalyzer.recognizedFood("Steak"), .meat)
        XCTAssertEqual(DishPhotoAnalyzer.recognizedFood("ice_cream"), .iceCream)
    }

    func testRecognizedFoodsAreFilteredSortedAndDeduplicated() {
        let foods = DishPhotoAnalyzer.recognizedFoods(from: [
            ("salad", 0.6),
            ("cheese", 0.9),
            ("table", 0.95),
            ("vegetables", 0.4),
            ("lettuce", 0.7),
            ("tomato", 0.65)
        ])
        XCTAssertEqual(foods, [.cheese, .vegetable, .salad])
    }

    func testCaloriesScaleWithPortionAndAddUpPerFood() {
        XCTAssertEqual(DishPhotoAnalyzer.calories(for: .pizza, portion: .normal), 450...850)
        XCTAssertEqual(DishPhotoAnalyzer.calories(for: .pizza, portion: .small), 320...600)
        XCTAssertEqual(DishPhotoAnalyzer.calories(for: .salad, portion: .large), 140...490)
        XCTAssertEqual(DishPhotoAnalyzer.totalCalories(for: [.salad, .vegetable], portion: .normal), 150...550)
        XCTAssertNil(DishPhotoAnalyzer.totalCalories(for: [], portion: .normal))
    }

    func testVeganHintFlagsAnimalFoodsAndOnlyAllPlantDishes() {
        XCTAssertEqual(DishPhotoAnalyzer.veganHint(for: [.salad, .cheese]), .animal)
        XCTAssertEqual(DishPhotoAnalyzer.veganHint(for: [.salad, .fruit]), .plant)
        XCTAssertNil(DishPhotoAnalyzer.veganHint(for: [.salad, .pasta]))
        XCTAssertNil(DishPhotoAnalyzer.veganHint(for: []))
    }

    func testEveryDishFoodIsLocalized() {
        for food in DishFood.allCases {
            XCTAssertNotEqual(L(food.localizationKey), food.localizationKey, food.rawValue)
        }
    }
}
