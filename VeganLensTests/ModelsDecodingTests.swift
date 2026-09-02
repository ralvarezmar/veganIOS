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
        XCTAssertEqual(estimated?.carbonFootprint?.value ?? -1, 230, accuracy: 0.0001)
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

    func testCarbonFootprintFallsBackToLegacyEcoScoreData() throws {
        let product = try decodeResponse(
            """
            {"status":1,"product":{"ecoscore_data":{"agribalyse":{"co2_total":2.3}}}}
            """
        ).product

        XCTAssertEqual(product?.carbonFootprint?.value ?? -1, 230, accuracy: 0.0001)
        XCTAssertEqual(product?.carbonFootprint?.source, .estimated)
    }

    func testCarbonFootprintPrefersEnvironmentalScoreDataWhenBothKeysExist() throws {
        let product = try decodeResponse(
            """
            {
              "status":1,
              "product":{
                "ecoscore_data":{"agribalyse":{"co2_total":9.0}},
                "environmental_score_data":{"agribalyse":{"co2_total":1.0}}
              }
            }
            """
        ).product

        XCTAssertEqual(product?.carbonFootprint?.value ?? -1, 100, accuracy: 0.0001)
    }

    func testCarbonFootprintReturnsNilForLegacyEcoScoreDataWithoutAgribalyse() throws {
        let product = try decodeResponse(
            """
            {"status":1,"product":{"ecoscore_data":{}}}
            """
        ).product

        XCTAssertNil(product?.carbonFootprint)
    }

    func testCarbonFootprintLevelUsesApprovedBoundaries() throws {
        let values: [(Double, CarbonFootprintLevel)] = [
            (149, .low),
            (150, .moderate),
            (500, .moderate),
            (501, .high)
        ]
        for (value, expected) in values {
            let product = try decodeResponse(
                """
                {"status":1,"product":{"nutriments":{"carbon-footprint_100g":\(value)}}}
                """
            ).product
            XCTAssertEqual(product?.carbonFootprintLevel, expected)
        }
    }

    func testSustainabilityImpactsFallsBackToLegacyEcoScoreDataAndDecodesFlexibleValues() throws {
        let product = try decodeResponse(
            """
            {
              "status":1,
              "product":{
                "ecoscore_data":{
                  "agribalyse":{
                    "co2_packaging":"0,174",
                    "co2_transportation":0.207
                  },
                  "adjustments":{
                    "packaging":{
                      "value":"-10",
                      "non_recyclable_and_non_biodegradable_materials":"1"
                    },
                    "origins_of_ingredients":{
                      "transportation_value":"-5"
                    }
                  }
                }
              }
            }
            """
        ).product

        XCTAssertEqual(product?.sustainabilityImpacts?.packagingCo2Per100g ?? -1, 17.4, accuracy: 0.0001)
        XCTAssertEqual(product?.sustainabilityImpacts?.transportCo2Per100g ?? -1, 20.7, accuracy: 0.0001)
        XCTAssertEqual(product?.sustainabilityImpacts?.packagingPenalty, -10)
        XCTAssertEqual(product?.sustainabilityImpacts?.nonRecyclablePackaging, true)
        XCTAssertEqual(product?.sustainabilityImpacts?.transportPenalty, -5)
    }

    func testSustainabilityImpactsHidesTransportPenaltyForUnknownOrigins() throws {
        let product = try decodeResponse(
            """
            {
              "status":1,
              "product":{
                "ecoscore_data":{
                  "adjustments":{
                    "origins_of_ingredients":{
                      "transportation_value":-5,
                      "warning":"origins_are_100_percent_unknown"
                    }
                  }
                }
              }
            }
            """
        ).product

        XCTAssertNil(product?.sustainabilityImpacts?.transportPenalty)
    }

    func testSustainabilityImpactsReturnsNilWithoutStagesOrPenalties() throws {
        XCTAssertNil(try decodeResponse(#"{"status":1,"product":{}}"#).product?.sustainabilityImpacts)
        XCTAssertNil(
            try decodeResponse(
                #"{"status":1,"product":{"ecoscore_data":{"agribalyse":{"co2_total":1.0}}}}"#
            ).product?.sustainabilityImpacts
        )
    }

    func testNutritionFactsFallsBackToPreparedValues() throws {
        let product = try decodeResponse(
            """
            {
              "status":1,
              "product":{
                "nutriments":{
                  "fat_prepared_100g":28.6666666666667,
                  "carbohydrates_prepared_100g":53.3333333333333,
                  "proteins_prepared_100g":6,
                  "energy-kcal_prepared_100g":503.333333333333,
                  "salt_prepared_100g":0.966666666666667,
                  "sugars_prepared_100g":3.33333333333333,
                  "saturated-fat_prepared_100g":2.33333333333333
                }
              }
            }
            """
        ).product

        let facts = product?.nutritionFacts
        XCTAssertEqual(facts?.basis, .prepared)
        XCTAssertEqual(facts?.fat ?? -1, 28.6666666666667, accuracy: 0.0001)
        XCTAssertEqual(facts?.carbohydrates ?? -1, 53.3333333333333, accuracy: 0.0001)
        XCTAssertEqual(facts?.proteins ?? -1, 6, accuracy: 0.0001)
        XCTAssertEqual(facts?.energyKcal ?? -1, 503.333333333333, accuracy: 0.0001)
        XCTAssertEqual(facts?.salt ?? -1, 0.966666666666667, accuracy: 0.0001)
        XCTAssertEqual(facts?.sugars ?? -1, 3.33333333333333, accuracy: 0.0001)
        XCTAssertEqual(facts?.saturatedFat ?? -1, 2.33333333333333, accuracy: 0.0001)
    }

    func testNutritionFactsPrefersAsSoldRegardlessOfJSONOrder() throws {
        let asSoldFirst = try decodeResponse(
            """
            {
              "status":1,
              "product":{
                "nutriments":{
                  "fat_100g":10.0,
                  "fat_prepared_100g":28.0
                }
              }
            }
            """
        ).product?.nutritionFacts
        let preparedFirst = try decodeResponse(
            """
            {
              "status":1,
              "product":{
                "nutriments":{
                  "fat_prepared_100g":28.0,
                  "fat_100g":10.0
                }
              }
            }
            """
        ).product?.nutritionFacts

        XCTAssertEqual(asSoldFirst?.basis, .asSold)
        XCTAssertEqual(asSoldFirst?.fat ?? -1, 10, accuracy: 0.0001)
        XCTAssertEqual(preparedFirst?.basis, .asSold)
        XCTAssertEqual(preparedFirst?.fat ?? -1, 10, accuracy: 0.0001)
    }

    func testNutritionFactsReturnsNilWithoutDeterminingValues() throws {
        let product = try decodeResponse(
            """
            {"status":1,"product":{"nutriments":{"carbon-footprint_100g":12.0}}}
            """
        ).product

        XCTAssertNil(product?.nutritionFacts)
    }

    func testNutritionFactsReturnsNilWithoutNutriments() throws {
        XCTAssertNil(try decodeResponse(
            """
            {"status":1,"product":{}}
            """
        ).product?.nutritionFacts)
    }

    func testPreparedAddedSugarsAloneDoesNotDetermineNutritionBasis() throws {
        let product = try decodeResponse(
            """
            {"status":1,"product":{"nutriments":{"added-sugars_prepared_100g":4.0}}}
            """
        ).product

        XCTAssertNil(product?.nutritionFacts)
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
