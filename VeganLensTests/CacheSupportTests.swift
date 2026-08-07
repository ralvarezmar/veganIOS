import XCTest
@testable import VeganLens

final class CacheSupportTests: XCTestCase {
    func testCacheAgeUsesLocalizedFriendlyUnits() {
        let now = Date(timeIntervalSince1970: 10_000)

        XCTAssertEqual(cacheAge(from: now.addingTimeInterval(-30), now: now), CacheAge(value: 30, unit: .seconds))
        XCTAssertEqual(cacheAge(from: now.addingTimeInterval(-60), now: now), CacheAge(value: 1, unit: .minute))
        XCTAssertEqual(cacheAge(from: now.addingTimeInterval(-7_200), now: now), CacheAge(value: 2, unit: .hours))
        XCTAssertEqual(cacheAge(from: now.addingTimeInterval(-172_800), now: now), CacheAge(value: 2, unit: .days))
    }

    func testCacheAgeDoesNotBecomeNegativeForFutureDate() {
        XCTAssertEqual(
            cacheAge(from: Date(timeIntervalSince1970: 20), now: Date(timeIntervalSince1970: 10)),
            CacheAge(value: 0, unit: .seconds)
        )
    }

    func testEvictionSelectsOldestEntriesBeyondLimit() {
        let entries = (0..<4).map {
            CacheEntryMetadata(
                barcode: "\($0)",
                cachedAt: Date(timeIntervalSince1970: TimeInterval($0))
            )
        }

        XCTAssertEqual(
            cacheBarcodesToEvict(entries: entries, limit: 2),
            Set(["0", "1"])
        )
    }

    func testEvictionDoesNothingAtOrBelowLimit() {
        let entries = [
            CacheEntryMetadata(barcode: "1", cachedAt: Date()),
            CacheEntryMetadata(barcode: "2", cachedAt: Date())
        ]

        XCTAssertTrue(cacheBarcodesToEvict(entries: entries, limit: 2).isEmpty)
        XCTAssertEqual(cacheBarcodesToEvict(entries: entries, limit: 100), [])
    }

    func testCacheEntryJustBelowTtlIsValid() {
        let now = Date(timeIntervalSince1970: 1_000_000)
        let cachedAt = now.addingTimeInterval(-cacheTTLSeconds + 1)

        XCTAssertFalse(isCacheEntryExpired(cachedAt: cachedAt, now: now))
    }

    func testCacheEntryJustAboveTtlIsExpired() {
        let now = Date(timeIntervalSince1970: 1_000_000)
        let cachedAt = now.addingTimeInterval(-cacheTTLSeconds - 1)

        XCTAssertTrue(isCacheEntryExpired(cachedAt: cachedAt, now: now))
    }
}
