import XCTest
@testable import VeganLens

final class ChainScanSummaryTests: XCTestCase {
    private func entry(_ barcode: String, _ verdict: VeganStatus?, _ state: ChainScanState = .done) -> ChainScanEntry {
        ChainScanEntry(barcode: barcode, productName: nil, verdict: verdict, state: state, addedAt: Date())
    }

    func testCountsOnlyCompletedEntriesByVerdict() {
        let summary = summarizeChainScan([
            entry("1", .vegan),
            entry("2", .vegan),
            entry("3", .notVegan),
            entry("4", .maybe),
            entry("5", nil),
            entry("6", nil, .loading),
            entry("7", nil, .error),
        ])

        XCTAssertEqual(summary, ChainScanSummary(vegan: 2, notVegan: 1, maybe: 1, unknown: 1))
        XCTAssertEqual(summary.total, 5)
    }
}
