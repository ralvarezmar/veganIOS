import XCTest
@testable import VeganLens

final class HistorySupportTests: XCTestCase {
    func testTrimsOldestEntriesToHistoryLimit() {
        let entries = (0..<305).map {
            HistoryEntryMetadata(
                barcode: "\($0)",
                timestamp: Date(timeIntervalSince1970: TimeInterval($0))
            )
        }

        let trimmed = historyBarcodesToTrim(entries: entries)

        XCTAssertEqual(trimmed.count, 5)
        XCTAssertEqual(trimmed, Set((0..<5).map(String.init)))
    }
}
