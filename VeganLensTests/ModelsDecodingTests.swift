import Foundation
import XCTest
@testable import VeganLens

final class ModelsDecodingTests: XCTestCase {
    func testNutrimentsDecodeNumericStrings() throws {
        let response = try decodeResponse(
            """
            {"status":1,"product":{"nutriments":{"fat_100g":"1,5","proteins_100g":"3"}}}
            """
        )

        XCTAssertEqual(response.product?.nutriments?.fat100g, 1.5)
        XCTAssertEqual(response.product?.nutriments?.proteins100g, 3.0)
    }

    func testProductWithoutNutrimentsStillDecodes() throws {
        let response = try decodeResponse(
            """
            {"status":1,"product":{"product_name":"Oat drink"}}
            """
        )

        XCTAssertEqual(response.product?.productName, "Oat drink")
        XCTAssertNil(response.product?.nutriments)
    }

    func testNovaGroupDecodesNumericString() throws {
        let response = try decodeResponse(
            """
            {"status":1,"product":{"nova_group":"3"}}
            """
        )

        XCTAssertEqual(response.product?.novaGroup, 3)
    }

    func testEnergyFallsBackToKilojoules() throws {
        let response = try decodeResponse(
            """
            {"status":1,"product":{"nutriments":{"energy-kj_100g":200}}}
            """
        )

        XCTAssertEqual(response.product?.nutriments?.energyKj100g, 200)
        XCTAssertNil(response.product?.nutriments?.energyKcal100g)
    }

    func testMalformedArrayDoesNotPreventProductDecoding() throws {
        let response = try decodeResponse(
            """
            {"status":1,"product":{"product_name":"Oat drink","additives_tags":"x"}}
            """
        )

        XCTAssertEqual(response.product?.productName, "Oat drink")
        XCTAssertNil(response.product?.additivesTags)
    }

    func testOpenFoodFactsExtrasDecodeFlexibleValuesAndPartialLevels() throws {
        let response = try decodeResponse(
            """
            {
              "status":1,
              "product":{
                "environmental_score_grade":"b",
                "environmental_score_score":"72",
                "environmental_score_data":{"agribalyse":{"co2_total":"2,3"}},
                "nutrient_levels":{"fat":"low","sugars":"high"},
                "nutriments":{
                  "added-sugars_100g":"4,5",
                  "carbon-footprint_100g":"12"
                }
              }
            }
            """
        )

        XCTAssertEqual(response.product?.environmentalScoreGrade, "b")
        XCTAssertEqual(response.product?.environmentalScoreScore, 72)
        XCTAssertEqual(response.product?.environmentalScoreData?.agribalyse?.co2Total, 2.3)
        XCTAssertEqual(response.product?.nutrientLevels?.fat, "low")
        XCTAssertNil(response.product?.nutrientLevels?.saturatedFat)
        XCTAssertEqual(response.product?.nutriments?.addedSugars100g, 4.5)
        XCTAssertEqual(response.product?.nutriments?.carbonFootprint100g, 12)
    }

    func testGreenScoreRejectsInvalidGradesAndOutOfRangeValues() throws {
        for grade in ["unknown", "not-applicable", " "] {
            let response = try decodeResponse(
                """
                {"status":1,"product":{"environmental_score_grade":"\(grade)"}}
                """
            )
            XCTAssertNil(response.product?.greenScoreGrade)
        }

        let response = try decodeResponse(
            """
            {"status":1,"product":{"environmental_score_score":101}}
            """
        )
        XCTAssertNil(response.product?.greenScoreValue)
    }

    func testGreenScoreFallsBackToLegacyEcoScore() throws {
        let response = try decodeResponse(
            """
            {"status":1,"product":{"ecoscore_grade":" c ","ecoscore_score":"40"}}
            """
        )

        XCTAssertEqual(response.product?.greenScoreGrade, "C")
        XCTAssertEqual(response.product?.greenScoreValue, 40)
    }

    func testCarbonFootprintPrefersDeclaredAndConvertsEstimatedValue() throws {
        let declared = try decodeResponse(
            """
            {
              "status":1,
              "product":{
                "environmental_score_data":{"agribalyse":{"co2_total":2.3}},
                "nutriments":{"carbon-footprint_100g":18}
              }
            }
            """
        ).product
        let estimated = try decodeResponse(
            """
            {
              "status":1,
              "product":{
                "environmental_score_data":{"agribalyse":{"co2_total":2.3}}
              }
            }
            """
        ).product

        XCTAssertEqual(declared?.carbonFootprint?.value, 18)
        XCTAssertEqual(declared?.carbonFootprint?.source, .declared)
        XCTAssertEqual(estimated?.carbonFootprint?.value, 230)
        XCTAssertEqual(estimated?.carbonFootprint?.source, .estimated)
        XCTAssertNil(Product(
            productName: nil,
            brands: nil,
            imageUrl: nil,
            ingredientsText: nil,
            ingredientsAnalysisTags: nil,
            categoriesTags: nil,
            labelsTags: nil,
            ingredients: nil,
            additivesTags: nil,
            allergensTags: nil,
            nutriments: nil,
            nutriscoreGrade: nil,
            ecoscoreGrade: nil,
            novaGroup: nil,
            quantity: nil
        ).carbonFootprint)
    }

    func testNutrientLevelsKeepRequiredOrderAndIgnoreInvalidValues() throws {
        let response = try decodeResponse(
            """
            {
              "status":1,
              "product":{
                "nutrient_levels":{
                  "fat":"LOW",
                  "saturated-fat":"invalid",
                  "sugars":" moderate ",
                  "salt":"high"
                }
              }
            }
            """
        )

        XCTAssertEqual(response.product?.nutrientLevelEntries.map(\.key), [.fat, .sugars, .salt])
        XCTAssertEqual(response.product?.nutrientLevelEntries.map(\.level), [.low, .moderate, .high])
    }

    private func decodeResponse(_ json: String) throws -> OpenFactsResponse {
        try JSONDecoder().decode(
            OpenFactsResponse.self,
            from: Data(json.utf8)
        )
    }
}
