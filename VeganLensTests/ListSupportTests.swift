import XCTest
@testable import VeganLens

final class ListSupportTests: XCTestCase {
    private struct Item {
        let name: String
        let verdict: VeganStatus?
        let category: ProductCategory?
        let timestamp: Date
    }

    private let items = [
        Item(name: "Vegan", verdict: .vegan, category: .sweetSnacks, timestamp: Date(timeIntervalSince1970: 1)),
        Item(name: "Maybe", verdict: .maybe, category: .beverages, timestamp: Date(timeIntervalSince1970: 2)),
        Item(name: "Not vegan", verdict: .notVegan, category: .other, timestamp: Date(timeIntervalSince1970: 3)),
        Item(name: "Unknown", verdict: nil, category: nil, timestamp: Date(timeIntervalSince1970: 4))
    ]

    func testEmptySelectionReturnsAllItems() {
        let result = filter(items, selectedVerdicts: [])
        XCTAssertEqual(result.map(\.name), ["Unknown", "Not vegan", "Maybe", "Vegan"])
    }

    func testFiltersVeganItems() {
        let result = filter(items, selectedVerdicts: [.vegan])
        XCTAssertEqual(result.map(\.name), ["Vegan"])
    }

    func testFiltersVeganAndMaybeTogether() {
        let result = filter(items, selectedVerdicts: [.vegan, .maybe])
        XCTAssertEqual(result.map(\.name), ["Maybe", "Vegan"])
    }

    func testFiltersNotVeganItems() {
        let result = filter(items, selectedVerdicts: [.notVegan])
        XCTAssertEqual(result.map(\.name), ["Not vegan"])
    }

    func testNilVerdictIsUnknown() {
        let result = filter(items, selectedVerdicts: [.unknown])
        XCTAssertEqual(result.map(\.name), ["Unknown"])
    }

    func testCategoryAndVerdictAndSearchAreCombined() {
        let result = filter(
            items,
            selectedVerdicts: [.maybe],
            selectedCategories: [.beverages],
            query: "may"
        )
        XCTAssertEqual(result.map(\.name), ["Maybe"])
    }

    func testPersistedVerdictsUseStableValuesAndTolerateUnknownInput() {
        XCTAssertEqual(VeganStatus.vegan.persistedValue, "VEGAN")
        XCTAssertEqual(VeganStatus.notVegan.persistedValue, "NOT_VEGAN")
        XCTAssertEqual(VeganStatus.maybe.persistedValue, "MAYBE")
        XCTAssertEqual(VeganStatus.unknown.persistedValue, "UNKNOWN")
        XCTAssertEqual(VeganStatus(persisted: "unexpected"), .unknown)
        XCTAssertEqual(VeganStatus(persisted: nil), .unknown)
    }

    private func filter(
        _ items: [Item],
        selectedVerdicts: Set<VeganStatus>,
        selectedCategories: Set<ProductCategory> = [],
        query: String = ""
    ) -> [Item] {
        filterAndSortItems(
            items,
            query: query,
            sortOrder: .mostRecent,
            selectedVerdicts: selectedVerdicts,
            selectedCategories: selectedCategories,
            productName: { $0.name },
            brand: { _ in nil },
            barcode: { $0.name },
            timestamp: { $0.timestamp },
            verdict: { $0.verdict },
            category: { $0.category }
        )
    }

    func testOnlyDifferencesHidesRowsWithIdenticalLoadedValues() {
        XCTAssertTrue(showComparisonRow(onlyDifferences: false, values: [1.0, 1.0], loading: []))
        XCTAssertFalse(showComparisonRow(onlyDifferences: true, values: [1.0, 1.0], loading: []))
        XCTAssertTrue(showComparisonRow(onlyDifferences: true, values: [1.0, 2.0], loading: []))
        XCTAssertFalse(showComparisonRow(onlyDifferences: true, values: [1.0, 2.0], loading: [1]))
        XCTAssertTrue(showComparisonRow(onlyDifferences: true, values: [nil, 2.0] as [Double?], loading: []))
    }

    func testComparisonRowsUseSoldValuesAndConvertKilojoules() throws {
        let product = try JSONDecoder().decode(
            Product.self,
            from: Data(#"{"nutriments":{"energy-kj_100g":418.4,"sugars_100g":5}}"#.utf8)
        )
        let rows = nutrientComparisons(products: [product, nil], basis: .asSold)
        XCTAssertEqual(rows.map(\.titleKey), ["nutrition_energy", "nutrition_sugars"])
        XCTAssertEqual(rows[0].values[0] ?? 0, 100, accuracy: 0.001)
        XCTAssertNil(rows[0].values[1])
        XCTAssertTrue(nutrientComparisons(products: [product], basis: .prepared).isEmpty)
    }

    func testLabelComparisonsKeepMissingDataDistinctFromEmptyLists() throws {
        let listed = try JSONDecoder().decode(Product.self, from: Data(#"{"allergens_tags":[],"traces_tags":["en:milk"]}"#.utf8))
        let rows = labelComparisons(products: [listed, nil]) { $0 }
        XCTAssertEqual(rows[0].values[0], [])
        XCTAssertEqual(rows[1].values[0], ["en:milk"])
        XCTAssertNil(rows[0].values[1])
    }
}
