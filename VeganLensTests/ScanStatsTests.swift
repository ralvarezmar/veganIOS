import XCTest
@testable import VeganLens

final class ScanStatsTests: XCTestCase {
    private let now = Date(timeIntervalSince1970: 100 * 86_400)

    private func scan(_ verdict: String?, _ category: String?, daysAgo: Double) -> ScanStatsInput {
        ScanStatsInput(verdict: verdict, category: category, timestamp: now.addingTimeInterval(-daysAgo * 86_400))
    }

    func testCountsVerdictsRecentScansAndTopCategories() {
        let stats = computeScanStats(
            [
                scan("VEGAN", "BEVERAGES", daysAgo: 1),
                scan("VEGAN", "BEVERAGES", daysAgo: 2),
                scan("NOT_VEGAN", "SWEET_SNACKS", daysAgo: 40),
                scan("MAYBE", "OTHER", daysAgo: 3),
                scan(nil, nil, daysAgo: 50),
                scan("garbage", "SWEET_SNACKS", daysAgo: 5),
            ],
            now: now
        )

        XCTAssertEqual(stats.total, 6)
        XCTAssertEqual(stats.vegan, 2)
        XCTAssertEqual(stats.notVegan, 1)
        XCTAssertEqual(stats.maybe, 1)
        XCTAssertEqual(stats.unknown, 2)
        XCTAssertEqual(stats.lastThirtyDays, 4)
        XCTAssertEqual(stats.veganPercent, 50)
        XCTAssertEqual(
            stats.topCategories,
            [CategoryCount(category: .beverages, count: 2), CategoryCount(category: .sweetSnacks, count: 2)]
        )
    }

    func testVeganPercentIsNilWithoutVerdicts() {
        XCTAssertNil(computeScanStats([scan("UNKNOWN", nil, daysAgo: 0)], now: now).veganPercent)
        XCTAssertEqual(computeScanStats([], now: now).total, 0)
    }
}
