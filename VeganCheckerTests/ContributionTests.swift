import XCTest
@testable import VeganChecker

final class ContributionTests: XCTestCase {
    func testContributionFieldsAlwaysIncludeCodeAndOmitBlankValues() {
        let fields = ContributionFormData(
            productName: "  Oat milk ",
            brands: "",
            quantity: " ",
            categories: "Plant drinks",
            ingredientsText: "",
            labels: "Vegan"
        ).fields(code: " 12345 ")

        XCTAssertEqual(fields["code"], "12345")
        XCTAssertEqual(fields["product_name"], "Oat milk")
        XCTAssertEqual(fields["categories"], "Plant drinks")
        XCTAssertEqual(fields["labels"], "Vegan")
        XCTAssertNil(fields["brands"])
        XCTAssertNil(fields["quantity"])
        XCTAssertNil(fields["ingredients_text"])
        XCTAssertFalse(fields.keys.contains("user_id"))
        XCTAssertFalse(fields.keys.contains("password"))
    }

    func testImageFieldUsesSupportedLanguageAndFallsBackToSpanish() {
        XCTAssertEqual(imageField(for: .front, locale: Locale(identifier: "en_US")), "front_en")
        XCTAssertEqual(imageField(for: .ingredients, locale: Locale(identifier: "es_ES")), "ingredients_es")
        XCTAssertEqual(imageField(for: .nutrition, locale: Locale(identifier: "fr_FR")), "nutrition_fr")
        XCTAssertEqual(imageField(for: .packaging, locale: Locale(identifier: "de_DE")), "packaging_de")
        XCTAssertEqual(imageField(for: .front, locale: Locale(identifier: "it_IT")), "front_it")
        XCTAssertEqual(imageField(for: .front, locale: Locale(identifier: "pt_PT")), "front_pt")
        XCTAssertEqual(imageField(for: .front, locale: Locale(identifier: "ja_JP")), "front_es")
    }

    func testProductLanguageUsesSupportedLanguageAndEnglishFallback() {
        XCTAssertEqual(supportedProductLanguage("es"), "es")
        XCTAssertEqual(supportedProductLanguage("EN_us"), "en")
        XCTAssertEqual(supportedProductLanguage("de-DE"), "de")
        XCTAssertEqual(supportedProductLanguage("fr"), "fr")
        XCTAssertEqual(supportedProductLanguage("it"), "it")
        XCTAssertEqual(supportedProductLanguage("pt"), "pt")
        XCTAssertEqual(supportedProductLanguage("ja"), "en")
    }

    func testContributionEndpointsUseSelectedSource() {
        XCTAssertEqual(
            contributionURL(for: .openBeautyFacts).absoluteString,
            "https://world.openbeautyfacts.org/cgi/product_jqm2.pl"
        )
        XCTAssertEqual(
            productImageUploadURL(for: .openPetFoodFacts).absoluteString,
            "https://world.openpetfoodfacts.org/cgi/product_image_upload.pl"
        )
    }

    func testAnonymousImageFieldsContainNoCredentials() {
        let fields = anonymousImageFields(code: "123", imageField: "front_es")
        XCTAssertEqual(fields, ["code": "123", "imagefield": "front_es"])
        XCTAssertNil(fields["user_id"])
        XCTAssertNil(fields["password"])
    }

    func testContributionAccountFieldsRequireBothConfiguredValues() {
        XCTAssertEqual(
            contributionAccountFields(
                infoDictionary: [
                    "OFFAppUsername": " u ",
                    "OFFAppPassword": " p "
                ]
            ),
            ["user_id": "u", "password": "p"]
        )
        XCTAssertEqual(
            contributionAccountFields(
                infoDictionary: ["OFFAppUsername": "u", "OFFAppPassword": ""]
            ),
            [:]
        )
        XCTAssertEqual(contributionAccountFields(infoDictionary: [:]), [:])
    }
}
