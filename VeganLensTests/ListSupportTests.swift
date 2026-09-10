import XCTest
@testable import VeganLens

final class ListSupportTests: XCTestCase {
    private struct Item {
        let name: String
        let verdict: VeganStatus?
        let timestamp: Date
    }

    private let items = [
        Item(name: "Vegan", verdict: .vegan, timestamp: Date(timeIntervalSince1970: 1)),
        Item(name: "Maybe", verdict: .maybe, timestamp: Date(timeIntervalSince1970: 2)),
        Item(name: "Not vegan", verdict: .notVegan, timestamp: Date(timeIntervalSince1970: 3)),
        Item(name: "Unknown", verdict: nil, timestamp: Date(timeIntervalSince1970: 4))
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
        selectedVerdicts: Set<VeganStatus>
    ) -> [Item] {
        filterAndSortItems(
            items,
            query: "",
            sortOrder: .mostRecent,
            selectedVerdicts: selectedVerdicts,
            productName: { $0.name },
            brand: { _ in nil },
            barcode: { $0.name },
            timestamp: { $0.timestamp },
            verdict: { $0.verdict }
        )
    }
}
