import XCTest
@testable import VeganLens

final class ResultShareTextTests: XCTestCase {
    func testIncludesNameAndBrand() {
        XCTAssertEqual(
            buildShareText(
                headline: "Vegan",
                productName: "Oat Bar",
                brand: "Green Co",
                barcode: "123",
                footer: "Analysed with VeganLens"
            ),
            "Vegan — Oat Bar · Green Co\n123\nAnalysed with VeganLens"
        )
    }

    func testOmitsBrandWhenMissingOrBlank() {
        XCTAssertEqual(
            buildShareText(headline: "Vegan", productName: "Oat Bar", brand: nil, barcode: "123", footer: "Footer"),
            "Vegan — Oat Bar\n123\nFooter"
        )
        XCTAssertEqual(
            buildShareText(headline: "Vegan", productName: "Oat Bar", brand: "  ", barcode: "123", footer: "Footer"),
            "Vegan — Oat Bar\n123\nFooter"
        )
    }

    func testOmitsProductNameWhenMissingOrBlank() {
        XCTAssertEqual(
            buildShareText(headline: "Vegan", productName: nil, brand: "Brand", barcode: "123", footer: "Footer"),
            "Vegan\n123\nFooter"
        )
        XCTAssertEqual(
            buildShareText(headline: "Vegan", productName: "  ", brand: "Brand", barcode: "123", footer: "Footer"),
            "Vegan\n123\nFooter"
        )
    }

    func testIncludesBarcodeAndFooterWithoutURL() {
        let text = buildShareText(headline: "Vegan", productName: "Oat Bar", brand: nil, barcode: "123", footer: "Footer")
        XCTAssertTrue(text.contains("123"))
        XCTAssertTrue(text.contains("Footer"))
        XCTAssertFalse(text.contains("http"))
    }

    func testCombinesVerdictAccessibilityText() {
        XCTAssertEqual(
            verdictAccessibilityText(headline: "Vegan", subtitle: "No animal ingredients", explanation: "Explanation"),
            "Vegan. No animal ingredients. Explanation"
        )
        XCTAssertEqual(
            verdictAccessibilityText(headline: "Vegan", subtitle: "No animal ingredients", explanation: nil),
            "Vegan. No animal ingredients"
        )
    }
}
