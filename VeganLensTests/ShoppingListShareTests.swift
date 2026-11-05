import XCTest
@testable import VeganLens

final class ShoppingListShareTests: XCTestCase {
    func testFormatsPendingThenCheckedItems() {
        let text = formatShoppingListShareText(
            header: "Lista",
            checkedSectionTitle: "Comprado",
            items: [
                ShoppingShareItem(barcode: "1", productName: "Leche de avena", brand: "Oatly", verdict: "VEGAN", checked: false),
                ShoppingShareItem(barcode: "2", productName: nil, brand: " ", verdict: nil, checked: false),
                ShoppingShareItem(barcode: "3", productName: "Galletas", brand: nil, verdict: "MAYBE", checked: true),
            ],
            verdictLabel: { $0.persistedValue.lowercased() }
        )

        XCTAssertEqual(text, "Lista\n\n☐ Leche de avena (Oatly) · vegan\n☐ 2\n\nComprado:\n☑ Galletas · maybe")
    }
}
