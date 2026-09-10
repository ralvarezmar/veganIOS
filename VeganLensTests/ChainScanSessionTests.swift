import XCTest
@testable import VeganLens

@MainActor
final class ChainScanSessionTests: XCTestCase {
    func testSuppressesDuplicateWithinThreeSeconds() {
        let session = ChainScanSession()
        let start = Date(timeIntervalSince1970: 100)

        XCTAssertTrue(session.register(barcode: "1", now: start))
        XCTAssertFalse(session.register(barcode: "1", now: start.addingTimeInterval(2.9)))
        XCTAssertTrue(session.register(barcode: "1", now: start.addingTimeInterval(3)))
        XCTAssertEqual(session.entries.map(\.barcode), ["1"])
    }

    func testKeepsAtMostTenEntriesAndPutsNewestFirst() {
        let session = ChainScanSession()
        let start = Date(timeIntervalSince1970: 100)

        for value in 0..<11 {
            XCTAssertTrue(
                session.register(
                    barcode: "\(value)",
                    now: start.addingTimeInterval(TimeInterval(value))
                )
            )
        }

        XCTAssertEqual(session.entries.count, 10)
        XCTAssertEqual(session.entries.first?.barcode, "10")
        XCTAssertFalse(session.entries.contains { $0.barcode == "0" })
    }
}
