import Foundation
import XCTest
@testable import VeganChecker

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

    private func decodeResponse(_ json: String) throws -> OpenFactsResponse {
        try JSONDecoder().decode(
            OpenFactsResponse.self,
            from: Data(json.utf8)
        )
    }
}
