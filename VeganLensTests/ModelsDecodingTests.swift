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

    func testEnvironmentalImpactDecodesStagesGreenScorePackagingAndQuality() throws {
        let product = try decodeResponse(
            """
            {
              "status":1,
              "product":{
                "ecoscore_data":{
                  "agribalyse":{
                    "co2_agriculture":0.756,
                    "co2_processing":0.233,
                    "co2_transportation":0.207,
                    "co2_packaging":0.174,
                    "co2_distribution":0.0269,
                    "score":90,
                    "name_en":"Potato crisps",
                    "name_fr":"Chips de pomme de terre"
                  },
                  "score":75,
                  "grade":"B",
                  "scores":{"world":74},
                  "grades":{"world":"C"},
                  "missing":{"origins":1,"labels":1},
                  "missing_data_warning":1,
                  "adjustments":{
                    "packaging":{
                      "value":-10,
                      "packagings":[{
                        "material":"en:plastic",
                        "shape":"en:bag",
                        "recycling":"en:recycle-with-plastics-metal-and-bricks",
                        "non_recyclable_and_non_biodegradable":"maybe"
                      }]
                    },
                    "origins_of_ingredients":{
                      "epi_value":0,
                      "transportation_value":-5,
                      "warning":"origins_are_100_percent_unknown"
                    },
                    "production_system":{
                      "value":0,
                      "warning":"no_label"
                    },
                    "threatened_species":{
                      "value":0
                    }
                  }
                }
              }
            }
            """
        ).product

        let impact = try XCTUnwrap(product?.environmentalImpact)
        XCTAssertEqual(impact.stages.map(\.stage), [.agriculture, .processing, .transport, .packaging, .distribution])
        XCTAssertEqual(impact.stages.map(\.sharePercent).reduce(0, +), 100)
        XCTAssertEqual(impact.stages[0].gramsPer100g, 75.6, accuracy: 0.0001)
        XCTAssertEqual(impact.stages[1].gramsPer100g, 23.3, accuracy: 0.0001)
        XCTAssertEqual(impact.stages[2].gramsPer100g, 20.7, accuracy: 0.0001)
        XCTAssertEqual(impact.stages[3].gramsPer100g, 17.4, accuracy: 0.0001)
        XCTAssertEqual(impact.stages[4].gramsPer100g, 2.69, accuracy: 0.0001)
        XCTAssertEqual(impact.greenScore?.baseScore, 90)
        XCTAssertEqual(impact.greenScore?.finalScore, 74)
        XCTAssertEqual(impact.greenScore?.grade, "C")
        XCTAssertEqual(impact.greenScore?.adjustments.map(\.kind), [.packaging, .origins, .productionSystem])
        XCTAssertEqual(impact.greenScore?.adjustments[0].points, -10)
        XCTAssertEqual(impact.greenScore?.adjustments[1].points, -5)
        XCTAssertTrue(impact.greenScore?.adjustments[1].unknownOrigin == true)
        XCTAssertTrue(impact.greenScore?.adjustments[2].noProductionLabel == true)
        XCTAssertEqual(impact.packaging.first?.materialTag, "en:plastic")
        XCTAssertEqual(impact.packaging.first?.shapeTag, "en:bag")
        XCTAssertEqual(impact.packaging.first?.recyclingTag, "en:recycle-with-plastics-metal-and-bricks")
        XCTAssertEqual(impact.packaging.first?.recyclability, .maybeNonRecyclable)
        XCTAssertEqual(impact.dataQuality?.missing, [.origins, .labels])
        XCTAssertTrue(impact.dataQuality?.incomplete == true)
    }

    func testEnvironmentalImpactReturnsNilForSingleStageWithoutOtherData() throws {
        let product = try decodeResponse(
            """
            {
              "status":1,
              "product":{
                "ecoscore_data":{
                  "agribalyse":{
                    "co2_agriculture":0.756
                  }
                }
              }
            }
            """
        ).product

        XCTAssertNil(product?.environmentalImpact)
    }

    func testEnvironmentalGreenScoreFallsBackToBlockScoreAndGrade() throws {
        let product = try decodeResponse(
            """
            {"status":1,"product":{"environmental_score_data":{"score":64,"grade":"d"}}}
            """
        ).product

        XCTAssertEqual(product?.environmentalImpact?.greenScore?.finalScore, 64)
        XCTAssertEqual(product?.environmentalImpact?.greenScore?.grade, "D")
    }

    func testEnvironmentalGreenScoreUsesDeviceCountryBeforeWorld() throws {
        let country = Locale.current.region?.identifier.lowercased() ?? ""
        guard !country.isEmpty, country != "world" else {
            return
        }
        let countryKey = country
        let product = try decodeResponse(
            """
            {"status":1,"product":{"environmental_score_data":{"scores":{"\(countryKey)":81,"world":74},"grades":{"\(countryKey)":"A","world":"C"}}}}
            """
        ).product

        XCTAssertEqual(product?.environmentalImpact?.greenScore?.finalScore, 81)
        XCTAssertEqual(product?.environmentalImpact?.greenScore?.grade, "A")
    }

    func testEnvironmentalImpactReturnsNilWithoutEnvironmentalData() throws {
        XCTAssertNil(try decodeResponse(#"{"status":1,"product":{}}"#).product?.environmentalImpact)
        XCTAssertNil(try decodeResponse(#"{"status":1,"product":{"ecoscore_data":{"agribalyse":{"co2_total":1.0}}}}"#).product?.environmentalImpact)
    }

    func testEnvironmentalTagMapsOmitUnknownTags() {
        XCTAssertNil(environmentalMaterialLabelKeys["en:unknown"])
        XCTAssertEqual(environmentalMaterialLabelKeys["en:plastic"], "env_material_plastic")
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
